package.path = "lib/treble/?.lua;" .. package.path

package.cpath = "lib/lovemidi/?.so;" .. package.cpath
package.cpath = "lib/treble/lib/lovemidi/?.so;" .. package.cpath

local midi = require 'luamidi'

local bit = require 'bit'
local class = require 'lib.middleclass.middleclass'

local Dispatcher = require('dispatcher')
local Treble = class('Treble')

function Treble:initialize(inport, outport)
  if inport and midi.getinportcount() > inport then self.inport = inport else self.inport = nil end
  if outport and midi.getoutportcount() > outport then self.outport = outport else self.outport = nil end
  self.state = { system={{},{}}, channel={{},{}}, }
  self.callbacks = { __mode='kv' }
end

function Treble.get_io_ports( port_match_string )
  local input, output
  for n, p in pairs(Treble.inPorts(port_match_string)) do
    input = n
    print("Input '" .. p .. "' found for " .. "'" .. port_match_string .. "'")
  end

  for n, p in pairs(Treble.outPorts(port_match_string)) do
    output = n
    print("Output '" .. p .. "' found for " .. "'" .. port_match_string .. "'")
  end

  if input and output then
    return input, output
  else
    if input == nil then
      print("No input found for '" .. port_match_string .. "'")
    end
    if output == nil then
      print("No output found for '" .. port_match_string .. "'")
    end
    return nil,nil
  end
end


-- loads the controls into an elements table.
-- the elements table has a table for each type of midi signal, each of which
-- is an array with the lookup of the channel/note/etc. That will get you
-- the configuration for the control so you know how to handle it as well as
-- callbacks, etc.
function Treble:load_controls(control_config)
  self.control_config = control_config
  self.elements = {}
  self.controls = {}

  for element,conf in pairs(self.control_config) do
    -- print(element,conf)
    if conf.control then
      if not self.elements.control_changes then self.elements.control_changes={} end
      
      self.elements.control_changes[conf.control] = conf
      self.elements.control_changes[conf.control].value = nil
      self.controls[element] = conf

    elseif conf.note then
      if not self.elements.notes then self.elements.notes={} end
      
      self.elements.notes[conf.note] = conf
    
    end
  end
end

-- returns the current valut of the element
function Treble:get( element )
  return self.controls[element].value
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



-- PROCESSORS
-- They process the different midi message types
-- this is where and and all massage magic happens

-- the kinds of processors
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

local function _noteOn(self, ch, key, value)
  if not self.channel[ch] then self.channel[ch] = {} end
  self.channel[ch][key] = { 'on', vel }
end

local function _controlChange(self, _port, control, value )
  local conf = self.elements.control_changes[control]
  if conf then
    local last_val = self.elements.control_changes[control].value
    local new_val = nil
    if conf.type == 'button' then
      new_val = bit.band(bit.rshift(value, 6), 1)
      if last_val == nil and new_val == 0 and conf.on_release then conf.on_release() end
      if last_val == nil and new_val == 1 and conf.on_press then conf.on_press() end
      if last_val == 0 and new_val == 1 and conf.on_press then conf.on_press() end
      if last_val == 1 and new_val == 0 and conf.on_release then conf.on_release() end
    elseif conf.type == 'fader' or conf.type == 'knob' then
      new_val = value
      if conf.on_change then conf.on_change(new_val) end
    end
    self.elements.control_changes[control].value = new_val
  else
    print("Control " .. control .. " not configured.")
  end
end

local _processors = {}
_processors[M_NOTEOFF] = _noteOff
_processors[M_NOTEON] = _noteOn
_processors[M_CONTROLCHANGE] = _controlChange

local function port_to_processor_kind(port)
  return bit.band(bit.rshift(port, 4), 7)   -- 1kkk nnnn
end

function Treble:processInput(port, control, value, _delta)
  if port then
    local kind = port_to_processor_kind(port)
    -- print("port:"..port, "kind:"..kind, "control:"..control, "value:"..value, "_delta:".._delta)
    if _processors[kind] then _processors[kind](self, port, control, value) end
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
