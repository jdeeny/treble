local class = require 'lib.middleclass'

local Messages = {}

local Message = class('MidiMessage')
function Message:initialize()
end

Messages.NoteOff = class("NoteOff", Message)
function Messages.NoteOff:initialize(n)
  Message.initialize(self)
  self.prefix = 0
  self.note = n
end

Messages.NoteOn = class("NoteOn", Message)
function Messages.NoteOn:initialize(n)
  Message.initialize(self)
  self.prefix = 1
  self.note = n
end

Messages.KeyPressure = class("KeyPressure", Message)
function Messages.KeyPressure:initialize(n)
  Message.initialize(self)
  self.prefix = 2
end

Messages.ControlChange = class("ControlChange", Message)
function Messages.ControlChange:initialize(n)
  Message.initialize(self)
  self.prefix = 3
end

Messages.ProgramChange = class("ProgramChange", Message)
function Messages.ProgramChange:initialize(n)
  Message.initialize(self)
  self.prefix = 4
end

Messages.ChannelPressure = class("ChannelPressure", Message)
function Messages.ChannelPressure:initialize(n)
  Message.initialize(self)
  self.prefix = 5
end

Messages.PitchBend = class("PitchBend", Message)
function Messages.PitchBend:initialize(n)
  Message.initialize(self)
  self.prefix = 6
end

Messages.SystemCommon = class("SystemCommon", Message)
function Messages.SystemCommon:initialize(n)
  Message.initialize(self)
  self.prefix = 7
end

return Messages
