levels = {}
--[[
local o = 'empty space'
local a = 'asteroid'
local s = 'start'

levels.first_level = {
  a, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, -- row 1
  o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o,
  o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, -- row 3
  o, o, o, s, o, o, o, o, o, o, o, o, a, o, o, o,
  o, o, o, o, o, o, o, o, o, o, o, o, a, o, o, o, -- row 5
  o, o, o, o, o, o, o, o, o, o, o, a, o, o, o, o,
  o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, -- row 7
  o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o,
  o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, o, -- row 9
}
]]--

levels.first_level = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -- row 1
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -- row 3
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, -- row 5
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -- row 7
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -- row 9
}
