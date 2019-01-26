local Treble = require '.'

local xtouch

function love.load()
  for n, p in pairs(Treble.inPorts('MINI')) do
    print(n .. " " .. p)
  end

  for n, p in pairs(Treble.outPorts('MINI')) do
    print(n .. " " .. p)
  end

  xtouch = Treble:new(1, 1)

end

function love.update(dt)
end

function love.draw()
end
