local Treble = require '.'

local xtouch

local function create_treble(port_match_string)
  local input, output
  for n, p in pairs(Treble.inPorts(port_match_string)) do
    input = n
    print("Input '" .. p .. "' found for " .. "'" .. port_match_string .. "")
  end

  for n, p in pairs(Treble.outPorts(port_match_string)) do
  	output = n
    print("Output '" .. p .. "' found for " .. "'" .. port_match_string .. "")
  end

  if input and output then
  	return Treble:new(input, output)
  else
  	if input == nil then
  		print("No input found for '" .. port_match_string .. "'")
  	end
  	if output == nil then
  		print("No output found for '" .. port_match_string .. "'")
  	end
  	return nil
  end
end

function love.load()
	xtouch = create_treble('MINI')
  worlde = create_treble('WORLDE')
  virmid = create_treble('28:0')

end

function love.update(dt)
	if xtouch then xtouch:update(dt) end
	if worlde then worlde:update(dt) end
	if virmid then virmid:update(dt) end
end

function love.draw()
end
