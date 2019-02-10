local Treble = require '.'

local xtouch
local worlde
local virmid


function love.load()
	print("Input Ports:")
	for n,p in pairs(Treble.inPorts('')) do print("    " .. p) end
	print("Output Ports:")
	for n,p in pairs(Treble.outPorts('')) do print("    " .. p) end
	print()
	xtouch = Treble:new(Treble.get_io_ports('MINI'))
  worlde = Treble:new(Treble.get_io_ports('WORLDE'))
  virmid = Treble:new(Treble.get_io_ports('14:0'))

end

function love.update(dt)
	if xtouch then xtouch:update(dt) end
	if worlde then worlde:update(dt) end
	if virmid then virmid:update(dt) end
end

function love.draw()
end
