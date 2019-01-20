treble = require '.'

--local t = treble:new(2,2)

for n, p in pairs(treble.inPorts('MINI')) do
  print(n .. " " .. p)
end

for n, p in pairs(treble.outPorts('MINI')) do
  print(n .. " " .. p)
end
