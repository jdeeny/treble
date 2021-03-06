package.path = "lib/treble/?.lua;" .. package.path

package.cpath = "lib/lovemidi/?.so;" .. package.cpath
package.cpath = "lib/treble/lib/lovemidi/?.so;" .. package.cpath

local midi = require 'luamidi'

local bit = require 'bit'
local class = require 'lib.middleclass.middleclass'

local Dispatcher = require('dispatcher')
local Treble = class('Treble')

function Treble:initialize(inport, outport)
  self.inport = inport and midi.getinportcount() > inport or nil
  self.outport = outport and midi.getoutportcount() > outport or nil
  self.state = { system={{},{}}, channel={{},{}}, }
  self.callbacks = { __mode='kv' }
end

local function _filter_ports(ports, name)
  local result = {}
  for n, p in pairs(ports) do
    if not name or p:find(name) then
      result[n] = p
    end
  end
  return result
end

function Treble.inPorts(name) return _filter_ports(midi.enumerateinports(), name) end
function Treble.outPorts(name) return _filter_ports(midi.enumerateoutports(), name) end


function Treble:update(dt)
  if self.inport then
    repeat
      self:processInput(midi.getMessage(self.inport))
    until not port
  end
end

local function port_to_kind(port)
  return bit.band(bit.rshift(port, 4), 7)   -- 1kkk nnnn
end

local M_NOTEOFF = 0
local M_NOTEON = 1
local M_KEYPRESSURE = 2
local M_CONTROLCHANGE = 3
local M_PROGRAMCHANGE = 4
local M_CHANNELPRESSURE = 5
local M_PITCHBEND = 6
local M_SYSTEMCOMMON = 7


local function _noteOff(self, ch, key, vel)
  if not self.channel[ch] then self.channel[ch] = {} end
  self.channel[ch][key] = { 'off', vel }
  local kind = {M_NOTEOFF, ch, key, vel}
  repeat
    if self.callbacks[kind] then self.callbacks[kind].dispatch() end
  until #kind == 1
end

local function _noteOn(self, ch, key, velocity)
  if not self.channel[ch] then self.channel[ch] = {} end
  self.channel[ch][key] = { 'on', vel }
end

local _processors = {}
_processors[M_NOTEOFF] = _noteOff
_processors[M_NOTEON] = _noteOn

function Treble:processInput(port, control, velocity, _delta)
  if port then
    local kind = port_to_kind(port)
    if _processors[kind] then _processors[kind](port, control, velocity) end
  end
end

function Treble:note(ch, key)
  return self.channel[ch] and self.channel[ch][key] or { 'off', 0 }
end

function Treble:channel(ch)
end

function Treble:system(ch)
end

function Treble:watch(kind, fn)
  if not self.channel_callbacks[kind] then self.channel_callbacks[kind] = Dispatcher:new() end
  self.channel_callbacks[kind].addCallback(fn)
end

function Treble:forget(kind, fn)
  if self.channel_callbacks[kind] then self.channel_callbacks[kind].removeCallback(fn) end
end



return Treble
