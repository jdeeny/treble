local class = require 'lib.middleclass.middleclass'

local Dispatcher = class('Dispatcher')

function Dispatcher:initialize()
  self.callbacks = { __mode='k' }
end

function Dispatcher:addCallback(fn)
  self.callbacks[fn] = true
end

function Dispatcher:removeCallback(fn)
  self.callbacks[fn] = nil
end

function Dispatcher:dispatch(...)
  for k, _ in pairs(self.callbacks) do
    k(...)
  end
end

return Dispatcher
