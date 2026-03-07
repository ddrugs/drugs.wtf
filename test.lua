local _0x0000 = _0x0000 or {}
local _0x0002 = _0x0002 or {
    _0x0003 = function(r, g, b) 
        return Color3.new(r/255, g/255, b/255) 
    end
}
local _0x0006 = _0x0006 or game:GetService("ReplicatedStorage")
local _0x0021 = _0x0021 or Instance
local _0x0026 = _0x0026 or BrickColor
local _0x0028 = _0x0028 or {
    _0x0027 = {
        _0x0029 = Enum.Font.SourceSans
    },
    _0x0049 = {
        _0x004a = RaycastParams.new()
    },
    _0x0113 = {}
}
local _0x002d = _0x002d or Drawing
local _0x0046 = _0x0046 or RaycastParams
local _0x0079 = _0x0079 or Vector2
local _0x007e = _0x007e or Vector3
local _0x0099 = _0x0099 or function(service) return {} end
local _0x009f = _0x009f or function() return false end
local _0x00a6 = _0x00a6 or function() end
local _0x00fd = _0x00fd or {
    _0x00fe = function() end
}

-- Initialize Keyboard constants
for i, v in pairs(Enum.KeyCode:GetEnumItems()) do
    _0x0028._0x0113[v.Name] = v
end
_0x0000._0x0001 = {
[string.char(83, 101, 116, 116, 105, 110, 103, 115)] = {
[string.char(84, 97, 114, 103, 101, 116, 32, 65, 105, 109)] = true,
[string.char(75, 110, 111, 99, 107, 32, 67, 104, 101, 99, 107)] = true,
[string.char(86, 105, 115, 105, 98, 108, 101, 32, 67, 104, 101, 99, 107)] = true,
[string.char(83, 101, 108, 102, 32, 75, 110, 111, 99, 107, 32, 67, 104, 101, 99, 107)] = true,
},
[string.char(75, 101, 121, 98, 105, 110, 100, 115)] = {
[string.char(84, 97, 114, 103, 101, 116, 32, 76, 111, 99, 107)] = {
[string.char(75, 101, 121)] = string.char(67),
[string.char(77, 111, 100, 101)] = string.char(84, 111, 103, 103, 108, 101),
},
[string.char(84, 114, 105, 103, 103, 101, 114, 32, 66, 111, 116)] = {
[string.char(75, 101, 121)] = string.char(86),
[string.char(77, 111, 100, 101)] = string.char(72, 111, 108, 100),
},
[string.char(83, 112, 101, 101, 100)] = string.char(90),
[string.char(69, 83, 80)] = string.char(89),
},
[string.char(70, 79, 86)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = false,
[string.char(86, 105, 115, 105, 98, 108, 101)] = true,
[string.char(84, 104, 105, 99, 107, 110, 101, 115, 115)] = 4,
[string.char(65, 99, 116, 105, 118, 101, 32, 67, 111, 108, 111, 114)] = _0x0002._0x0003(0, 17, (127 + 128)),
[string.char(83, 105, 122, 101)] = (5 + 5),
},
[string.char(84, 97, 114, 103, 101, 116, 32, 76, 105, 110, 101)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(84, 104, 105, 99, 107, 110, 101, 115, 115)] = 2.2,
[string.char(84, 114, 97, 110, 115, 112, 97, 114, 101, 110, 99, 121)] = 0.8,
[string.char(86, 117, 108, 110, 101, 114, 97, 98, 108, 101)] = _0x0002._0x0003((510 / 2), 85, 127),
[string.char(73, 110, 118, 117, 108, 110, 101, 114, 97, 98, 108, 101)] = _0x0002._0x0003((75 + 75), 150, 150),
},
[string.char(83, 105, 108, 101, 110, 116, 32, 65, 105, 109)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(72, 105, 116, 32, 80, 97, 114, 116)] = string.char(85, 112, 112, 101, 114, 84, 111, 114, 115, 111),
[string.char(80, 114, 101, 102, 101, 114, 114, 101, 100, 32, 80, 97, 114, 116)] = string.char(85, 112, 112, 101, 114, 84, 111, 114, 115, 111),
[string.char(70, 97, 108, 108, 98, 97, 99, 107, 32, 80, 97, 114, 116)] = string.char(85, 112, 112, 101, 114, 84, 111, 114, 115, 111),
[string.char(85, 115, 101, 32, 80, 114, 101, 100, 105, 99, 116, 105, 111, 110)] = true,
[string.char(80, 114, 101, 100, 105, 99, 116, 105, 111, 110)] = {
[string.char(88)] = 0,
[string.char(89)] = 0,
[string.char(90)] = 0.046,
},
},
[string.char(67, 97, 109, 101, 114, 97, 32, 76, 111, 99, 107)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = false,
[string.char(72, 105, 116, 32, 80, 97, 114, 116)] = string.char(72, 101, 97, 100),
[string.char(83, 109, 111, 111, 116, 104, 105, 110, 103)] = {
[string.char(88)] = 40,
[string.char(89)] = 40,
[string.char(90)] = 40,
},
[string.char(85, 115, 101, 32, 80, 114, 101, 100, 105, 99, 116, 105, 111, 110)] = true,
[string.char(80, 114, 101, 100, 105, 99, 116, 105, 111, 110)] = {
[string.char(88)] = 0.133,
[string.char(89)] = 0.133,
[string.char(90)] = 0.133,
},
},
[string.char(84, 114, 105, 103, 103, 101, 114, 32, 66, 111, 116)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(68, 101, 108, 97, 121)] = 0.01,
[string.char(82, 101, 113, 117, 105, 114, 101, 32, 84, 97, 114, 103, 101, 116)] = false,
[string.char(83, 112, 101, 99, 105, 102, 105, 99, 32, 87, 101, 97, 112, 111, 110, 115)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = false,
[string.char(87, 101, 97, 112, 111, 110, 115)] = {
string.char(91, 68, 111, 117, 98, 108, 101, 45, 66, 97, 114, 114, 101, 108, 32, 83, 71, 93),
string.char(91, 82, 101, 118, 111, 108, 118, 101, 114, 93),
string.char(91, 84, 97, 99, 116, 105, 99, 97, 108, 83, 104, 111, 116, 103, 117, 110, 93),
},
},
},
[string.char(83, 112, 114, 101, 97, 100)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = false,
[string.char(65, 109, 111, 117, 110, 116)] = 1,
[string.char(83, 112, 101, 99, 105, 102, 105, 99, 32, 87, 101, 97, 112, 111, 110, 115)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = false,
[string.char(87, 101, 97, 112, 111, 110, 115)] = {
string.char(91, 68, 111, 117, 98, 108, 101, 45, 66, 97, 114, 114, 101, 108, 32, 83, 71, 93),
string.char(91, 84, 97, 99, 116, 105, 99, 97, 108, 83, 104, 111, 116, 103, 117, 110, 93),
},
},
},
[string.char(83, 112, 101, 101, 100)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(77, 117, 108, 116, 105, 112, 108, 105, 101, 114)] = 35,
[string.char(65, 110, 116, 105, 32, 70, 108, 105, 110, 103)] = false,
},
[string.char(72, 105, 116, 98, 111, 120, 32, 69, 120, 112, 97, 110, 100, 101, 114)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(83, 105, 122, 101)] = (10 + 10),
},
[string.char(83, 112, 105, 100, 101, 114, 109, 97, 110)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
},
[string.char(86, 105, 115, 117, 97, 108, 32, 65, 119, 97, 114, 101, 110, 101, 115, 115)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(67, 111, 108, 111, 114)] = _0x0002._0x0003((510 / 2), 255, 255),
[string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] = _0x0002._0x0003(255, 0, 0),
[string.char(85, 115, 101, 32, 68, 105, 115, 112, 108, 97, 121, 32, 78, 97, 109, 101)] = false,
[string.char(78, 97, 109, 101, 32, 65, 98, 111, 118, 101)] = false,
},
[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(66, 111, 120, 101, 115)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(67, 111, 108, 111, 114)] = _0x0002._0x0003(255, (348 - 93), 255),
[string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] = _0x0002._0x0003((294 - 39), 0, 0),
[string.char(84, 104, 105, 99, 107, 110, 101, 115, 115)] = 2,
[string.char(84, 114, 97, 110, 115, 112, 97, 114, 101, 110, 99, 121)] = 0.5,
[string.char(70, 105, 108, 108)] = false,
[string.char(70, 105, 108, 108, 32, 67, 111, 108, 111, 114)] = _0x0002._0x0003(255, (127 + 128), (265 - 10)),
[string.char(70, 105, 108, 108, 32, 84, 114, 97, 110, 115, 112, 97, 114, 101, 110, 99, 121)] = 0.8,
[string.char(83, 99, 97, 108, 101)] = 1.1,
[string.char(87, 105, 100, 116, 104, 32, 82, 97, 116, 105, 111)] = 0.6,
},
[string.char(78, 97, 109, 101)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(67, 111, 108, 111, 114)] = _0x0002._0x0003((127 + 128), 255, 255),
[string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] = _0x0002._0x0003(255, 0, 0),
[string.char(83, 105, 122, 101)] = (7 + 7),
[string.char(80, 111, 115, 105, 116, 105, 111, 110)] = string.char(84, 111, 112),
[string.char(79, 102, 102, 115, 101, 116, 32, 88)] = 0,
[string.char(79, 102, 102, 115, 101, 116, 32, 89)] = 0,
[string.char(85, 115, 101, 32, 68, 105, 115, 112, 108, 97, 121, 32, 78, 97, 109, 101)] = false,
},
[string.char(68, 105, 115, 116, 97, 110, 99, 101)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(67, 111, 108, 111, 114)] = _0x0002._0x0003((324 - 69), (303 - 48), 255),
[string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] = _0x0002._0x0003(255, 0, 0),
[string.char(83, 105, 122, 101)] = 12,
[string.char(80, 111, 115, 105, 116, 105, 111, 110)] = string.char(66, 111, 116, 116, 111, 109),
[string.char(79, 102, 102, 115, 101, 116, 32, 88)] = 0,
[string.char(79, 102, 102, 115, 101, 116, 32, 89)] = 0,
[string.char(70, 111, 114, 109, 97, 116)] = string.char(123, 125, 32, 115, 116, 117, 100, 115),
},
[string.char(87, 101, 97, 112, 111, 110, 115)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = true,
[string.char(67, 111, 108, 111, 114)] = _0x0002._0x0003((343 - 88), (279 - 24), 255),
[string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] = _0x0002._0x0003(255, 0, 0),
[string.char(83, 105, 122, 101)] = (39 - 27),
[string.char(80, 111, 115, 105, 116, 105, 111, 110)] = string.char(84, 111, 112),
[string.char(79, 102, 102, 115, 101, 116, 32, 88)] = 0,
[string.char(79, 102, 102, 115, 101, 116, 32, 89)] = 15,
[string.char(83, 104, 111, 119, 65, 109, 109, 111)] = true,
[string.char(70, 111, 114, 109, 97, 116)] = string.char(123, 125),
},
[string.char(84, 114, 97, 99, 101, 114, 115)] = {
[string.char(69, 110, 97, 98, 108, 101, 100)] = false,
[string.char(67, 111, 108, 111, 114)] = _0x0002._0x0003((281 - 26), 255, (510 / 2)),
[string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] = _0x0002._0x0003((127 + 128), 0, 0),
[string.char(84, 104, 105, 99, 107, 110, 101, 115, 115)] = 1.5,
[string.char(84, 114, 97, 110, 115, 112, 97, 114, 101, 110, 99, 121)] = 0.5,
[string.char(79, 114, 105, 103, 105, 110)] = string.char(66, 111, 116, 116, 111, 109),
},
},
}
local _0x0004 = _0x0000._0x0001
local _0x0005 = _0x0006:_0x0007(string.char(80, 108, 97, 121, 101, 114, 115))
local _0x0008 = _0x0006:_0x0007(string.char(85, 115, 101, 114, 73, 110, 112, 117, 116, 83, 101, 114, 118, 105, 99, 101))
local _0x0009 = _0x0006:_0x0007(string.char(82, 117, 110, 83, 101, 114, 118, 105, 99, 101))
local _0x000a = _0x0006:_0x0007(string.char(87, 111, 114, 107, 115, 112, 97, 99, 101))
local _0x000b = _0x000a._0x000c
local _0x000d = _0x0005._0x000d
local _0x000e = _0x000d:_0x000f()
local _0x0011 = nil
local _0x0012 = nil
local _0x0013 = false
local _0x0014 = false
local _0x0015 = {}
local _0x0016 = false
local _0x0017 = (8 + 8)
local _0x0018 = 0
local _0x001d = {}
local _0x0020 = _0x0021._0x0022(string.char(80, 97, 114, 116))
_0x0020._0x0023 = true
_0x0020._0x0024 = false
_0x0020._0x0025 = 0.85
_0x0020._0x0026 = _0x0026._0x0022(string.char(71, 114, 101, 121))
_0x0020._0x0027 = _0x0028._0x0027._0x0029
_0x0020._0x002a = string.char(70, 79, 86, 79, 117, 116, 108, 105, 110, 101, 51, 68)
_0x0020._0x002b = _0x000a
local _0x002c = _0x002d._0x0022(string.char(76, 105, 110, 101))
_0x002c._0x002e = false
_0x002c._0x002f = _0x0004[string.char(84, 97, 114, 103, 101, 116, 32, 76, 105, 110, 101)][string.char(84, 104, 105, 99, 107, 110, 101, 115, 115)]
_0x002c._0x0025 = _0x0004[string.char(84, 97, 114, 103, 101, 116, 32, 76, 105, 110, 101)][string.char(84, 114, 97, 110, 115, 112, 97, 114, 101, 110, 99, 121)]
_0x002c._0x0030 = 999
local function _0x0033(_0x0034)
if not _0x0004[string.char(83, 101, 116, 116, 105, 110, 103, 115)][string.char(75, 110, 111, 99, 107, 32, 67, 104, 101, 99, 107)] then return false end
if _0x0034 and _0x0034._0x0035 then
local _0x0036 = _0x0034._0x0035:_0x0037(string.char(66, 111, 100, 121, 69, 102, 102, 101, 99, 116, 115))
if _0x0036 then
local _0x0038 = _0x0036:_0x0037(string.char(75, 46, 79))
if _0x0038 and _0x0038._0x0039 == true then return true end
local _0x003a = _0x0036:_0x0037(string.char(75, 110, 111, 99, 107, 101, 100))
if _0x003a and _0x003a._0x0039 == true then return true end
end
end
return false
end
local function _0x003b()
if not _0x0004[string.char(83, 101, 116, 116, 105, 110, 103, 115)][string.char(83, 101, 108, 102, 32, 75, 110, 111, 99, 107, 32, 67, 104, 101, 99, 107)] then return false end
if _0x000d._0x0035 then
local _0x0036 = _0x000d._0x0035:_0x0037(string.char(66, 111, 100, 121, 69, 102, 102, 101, 99, 116, 115))
if _0x0036 then
local _0x0038 = _0x0036:_0x0037(string.char(75, 46, 79))
if _0x0038 and _0x0038._0x0039 == true then return true end
local _0x003a = _0x0036:_0x0037(string.char(75, 110, 111, 99, 107, 101, 100))
if _0x003a and _0x003a._0x0039 == true then return true end
end
end
return false
end
local function _0x003c(_0x003d)
if not _0x0004[string.char(83, 101, 116, 116, 105, 110, 103, 115)][string.char(86, 105, 115, 105, 98, 108, 101, 32, 67, 104, 101, 99, 107)] then return true end
if not _0x003d or not _0x003d._0x002b then return false end
local _0x003e = _0x003d._0x002b
local _0x003f = _0x000b._0x0040._0x0041
local _0x0042 = (_0x003d._0x0041 - _0x003f)._0x0043 * (_0x003d._0x0041 - _0x003f)._0x0044
local _0x0045 = _0x0046._0x0022()
_0x0045._0x0047 = {_0x000d._0x0035, _0x003e, _0x0020}
_0x0045._0x0048 = _0x0028._0x0049._0x004a
_0x0045._0x004b = true
local _0x004c = _0x000a:_0x004d(_0x003f, _0x0042, _0x0045)
return _0x004c == nil or _0x004c._0x0021:_0x004e(_0x003e)
end
local function _0x0057(_0x003e, _0x0058)
if not _0x003e then return nil end
local _0x003d = _0x003e:_0x0037(_0x0058)
if _0x003d and _0x003d:_0x005c(string.char(66, 97, 115, 101, 80, 97, 114, 116)) then return _0x003d end
local _0x005f = {
string.char(72, 101, 97, 100),
string.char(72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116),
string.char(84, 111, 114, 115, 111),
string.char(85, 112, 112, 101, 114, 84, 111, 114, 115, 111),
string.char(76, 111, 119, 101, 114, 84, 111, 114, 115, 111),
string.char(82, 105, 103, 104, 116, 32, 65, 114, 109),
string.char(76, 101, 102, 116, 32, 65, 114, 109),
string.char(82, 105, 103, 104, 116, 32, 76, 101, 103),
string.char(76, 101, 102, 116, 32, 76, 101, 103)
}
for _0x0060, _0x0061 in ipairs(_0x005f) do
_0x003d = _0x003e:_0x0037(_0x0061)
if _0x003d and _0x003d:_0x005c(string.char(66, 97, 115, 101, 80, 97, 114, 116)) then
return _0x003d
end
end
for _0x0060, _0x0066 in pairs(_0x003e:_0x0067()) do
if _0x0066:_0x005c(string.char(66, 97, 115, 101, 80, 97, 114, 116)) and _0x0066._0x002a ~= string.char(72, 97, 110, 100, 108, 101) then
return _0x0066
end
end
return nil
end
local function _0x0068(_0x003e)
return _0x0057(_0x003e, string.char(72, 101, 97, 100))
end
local function _0x0069()
if not _0x0011 or not _0x0011._0x0035 then
return false
end
local _0x006a = _0x0068(_0x0011._0x0035)
if _0x006a then
_0x0012 = _0x006a
return true
end
return false
end
local function _0x006b()
local _0x006c = nil
local _0x006d = nil
local _0x006e = math._0x006f
local _0x0070 = _0x0008:_0x0071()
for _0x0060, _0x0034 in pairs(_0x0005:_0x0072()) do
if _0x0034 ~= _0x000d and _0x0034._0x0035 then
local _0x0073 = _0x0068(_0x0034._0x0035)
if _0x0073 then
local _0x0074, _0x0075 = _0x000b:_0x0076(_0x0073._0x0041)
if _0x0075 and _0x0074._0x0077 > 0 then
local _0x0078 = (_0x0079._0x0022(_0x0074._0x007a, _0x0074._0x007b) - _0x0070)._0x0044
if _0x0078 < _0x006e then
_0x006e = _0x0078
_0x006c = _0x0034
_0x006d = _0x0073
end
end
end
end
end
if _0x006c then
_0x0012 = _0x006d
return _0x006c
end
return nil
end
local function _0x007c(_0x003d, _0x007d)
if not _0x007d[string.char(85, 115, 101, 32, 80, 114, 101, 100, 105, 99, 116, 105, 111, 110)] or not _0x003d then return _0x003d and _0x003d._0x0041 or _0x007e._0x0022() end
local _0x007f = _0x003d._0x0080
local _0x0081 = _0x007d[string.char(80, 114, 101, 100, 105, 99, 116, 105, 111, 110)]
return _0x003d._0x0041 + _0x007e._0x0022(
_0x007f._0x007a * (_0x0081._0x007a or 0),
_0x007f._0x007b * (_0x0081._0x007b or 0),
_0x007f._0x0077 * (_0x0081._0x0077 or 0)
)
end
local function _0x0082()
if not _0x0013 then return end
if _0x003b() then
_0x0013 = false
_0x002c._0x002e = false
return
end
if not _0x0011 then return end
if not _0x0012 or not _0x0012._0x002b then
if not _0x0069() then
return
end
end
if not _0x0012 then return end
local _0x0083 = _0x007c(_0x0012, _0x0004[string.char(67, 97, 109, 101, 114, 97, 32, 76, 111, 99, 107)])
local _0x0084 = _0x000b._0x0040
local _0x0085 = _0x0040._0x0022(_0x0084._0x0041, _0x0083)
local _0x0086 = _0x0004[string.char(67, 97, 109, 101, 114, 97, 32, 76, 111, 99, 107)][string.char(83, 109, 111, 111, 116, 104, 105, 110, 103)]
local _0x0087 = 1 / ((_0x0086[string.char(88)] + _0x0086[string.char(89)] + _0x0086[string.char(90)]) / 3)
_0x000b._0x0040 = _0x0084:_0x0088(_0x0085, _0x0087)
end
local function _0x0089()
if not _0x0004[string.char(70, 79, 86)][string.char(69, 110, 97, 98, 108, 101, 100)] or not _0x0004[string.char(70, 79, 86)][string.char(86, 105, 115, 105, 98, 108, 101)] then
_0x0020._0x0025 = 1
return
end
if _0x0011 and _0x0011._0x0035 then
local _0x008a = _0x0011._0x0035:_0x0037(string.char(72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116))
if _0x008a then
local _0x008b = _0x0004[string.char(70, 79, 86)][string.char(83, 105, 122, 101)]
_0x0020._0x008c = _0x008a._0x008c + _0x007e._0x0022(_0x008b, _0x008b, _0x008b)
_0x0020._0x0040 = _0x008a._0x0040
_0x0020._0x0025 = 0.85
else
_0x0020._0x0025 = 1
end
else
_0x0020._0x0025 = 1
end
end
local function _0x008d()
if not _0x0004[string.char(84, 97, 114, 103, 101, 116, 32, 76, 105, 110, 101)][string.char(69, 110, 97, 98, 108, 101, 100)] or not _0x0011 or not _0x0013 then
_0x002c._0x002e = false
return
end
if not _0x0011._0x0035 then
_0x002c._0x002e = false
return
end
local _0x008a = _0x0011._0x0035:_0x0037(string.char(72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116))
if not _0x008a then
_0x002c._0x002e = false
return
end
local _0x0074, _0x0075 = _0x000b:_0x0076(_0x008a._0x0041)
if _0x0075 and _0x0074._0x0077 > 0 then
local _0x0070 = _0x0008:_0x0071()
_0x002c._0x008e = _0x0079._0x0022(_0x0070._0x007a, _0x0070._0x007b)
_0x002c._0x008f = _0x0079._0x0022(_0x0074._0x007a, _0x0074._0x007b)
_0x002c._0x002f = _0x0004[string.char(84, 97, 114, 103, 101, 116, 32, 76, 105, 110, 101)][string.char(84, 104, 105, 99, 107, 110, 101, 115, 115)]
_0x002c._0x0025 = _0x0004[string.char(84, 97, 114, 103, 101, 116, 32, 76, 105, 110, 101)][string.char(84, 114, 97, 110, 115, 112, 97, 114, 101, 110, 99, 121)]
_0x0069()
if _0x0012 and _0x003c(_0x0012) then
_0x002c._0x0090 = _0x0004[string.char(84, 97, 114, 103, 101, 116, 32, 76, 105, 110, 101)][string.char(86, 117, 108, 110, 101, 114, 97, 98, 108, 101)]
else
_0x002c._0x0090 = _0x0004[string.char(84, 97, 114, 103, 101, 116, 32, 76, 105, 110, 101)][string.char(73, 110, 118, 117, 108, 110, 101, 114, 97, 98, 108, 101)]
end
_0x002c._0x002e = true
else
_0x002c._0x002e = false
end
end
local function _0x0091()
if not _0x0004[string.char(84, 114, 105, 103, 103, 101, 114, 32, 66, 111, 116)][string.char(69, 110, 97, 98, 108, 101, 100)] or not _0x0014 then return end
if _0x0092() - _0x0018 < _0x0004[string.char(84, 114, 105, 103, 103, 101, 114, 32, 66, 111, 116)][string.char(68, 101, 108, 97, 121)] then return end
if _0x0004[string.char(84, 114, 105, 103, 103, 101, 114, 32, 66, 111, 116)][string.char(82, 101, 113, 117, 105, 114, 101, 32, 84, 97, 114, 103, 101, 116)] and not _0x0011 then return end
if _0x0011 and _0x0011._0x0035 then
_0x0069()
if not _0x0012 or not _0x003c(_0x0012) then return end
end
local _0x0093 = _0x000d._0x0035 and _0x000d._0x0035:_0x0094(string.char(84, 111, 111, 108))
if _0x0093 then
_0x0093:_0x0095()
_0x0018 = _0x0092()
end
end
local _0x0098 = _0x0099(_0x0006)
local _0x009a = _0x0098._0x009b
_0x009c(_0x0098, false)
_0x0098._0x009b = function(_0x009d, _0x009e)
if not _0x009f() and _0x009d == _0x000e and _0x0004[string.char(83, 105, 108, 101, 110, 116, 32, 65, 105, 109)][string.char(69, 110, 97, 98, 108, 101, 100)] then
if _0x009e == string.char(72, 105, 116) then
if _0x0011 then
if _0x0011._0x0035 then
local _0x003e = _0x0011._0x0035
local _0x00a0 = _0x0004[string.char(83, 105, 108, 101, 110, 116, 32, 65, 105, 109)][string.char(72, 105, 116, 32, 80, 97, 114, 116)]
local _0x0073 = _0x0057(_0x003e, _0x00a0)
if _0x0073 then
if _0x0004[string.char(83, 101, 116, 116, 105, 110, 103, 115)][string.char(86, 105, 115, 105, 98, 108, 101, 32, 67, 104, 101, 99, 107)] and not _0x003c(_0x0073) then
return _0x009a(_0x009d, _0x009e)
end
local _0x0083 = _0x0073._0x0041
if _0x0004[string.char(83, 105, 108, 101, 110, 116, 32, 65, 105, 109)][string.char(85, 115, 101, 32, 80, 114, 101, 100, 105, 99, 116, 105, 111, 110)] then
local _0x00a1 = _0x0073._0x0080
local _0x00a2 = _0x0004[string.char(83, 105, 108, 101, 110, 116, 32, 65, 105, 109)][string.char(80, 114, 101, 100, 105, 99, 116, 105, 111, 110)]
_0x0083 = _0x0073._0x0041 + _0x007e._0x0022(
_0x00a1._0x007a * (_0x00a2._0x007a or 0),
_0x00a1._0x007b * (_0x00a2._0x007b or 0),
_0x00a1._0x0077 * (_0x00a2._0x0077 or 0.046)
)
end
return _0x0040._0x0022(_0x0083)
end
end
return _0x009a(_0x009d, _0x009e)
end
return _0x009a(_0x009d, _0x009e)
end
end
return _0x009a(_0x009d, _0x009e)
end
_0x009c(_0x0098, true)
local _0x00a5
_0x00a5 = _0x00a6(math.random, function(...)
local _0x00a7 = {...}
if _0x009f() then return _0x00a5(...) end
if (#_0x00a7 == 0) or (_0x00a7[1] == -0.05 and _0x00a7[2] == 0.05) or (_0x00a7[1] == -0.1) or (_0x00a7[1] == -0.05) then
if _0x0004[string.char(83, 112, 114, 101, 97, 100)][string.char(69, 110, 97, 98, 108, 101, 100)] then
return _0x00a5(...) * (_0x0004[string.char(83, 112, 114, 101, 97, 100)][string.char(65, 109, 111, 117, 110, 116)] / (156 - 56))
end
end
return _0x00a5(...)
end)
local function _0x00a9(_0x0034)
if not _0x0034 or not _0x0034._0x0035 then return string.char(78, 111, 110, 101) end
local _0x0093 = _0x0034._0x0035:_0x0094(string.char(84, 111, 111, 108))
if _0x0093 then
local _0x00aa = _0x0093._0x002a
local _0x00ab = ""
if _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(87, 101, 97, 112, 111, 110, 115)][string.char(83, 104, 111, 119, 65, 109, 109, 111)] then
local _0x00ac = _0x0093:_0x0037(string.char(65, 109, 109, 111)) or _0x0093:_0x0037(string.char(67, 117, 114, 114, 101, 110, 116, 65, 109, 109, 111))
if _0x00ac then
_0x00ab = string.char(32, 91) .. tostring(_0x00ac._0x0039) .. string.char(93)
end
end
return _0x00aa .. _0x00ab
end
return string.char(78, 111, 110, 101)
end
local function _0x00ad(_0x0034)
if not _0x0034 or not _0x0034._0x0035 or not _0x000d._0x0035 then return 0 end
local _0x008a = _0x0034._0x0035:_0x0037(string.char(72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116))
local _0x00ae = _0x000d._0x0035:_0x0037(string.char(72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116))
if _0x008a and _0x00ae then
return math.floor((_0x008a._0x0041 - _0x00ae._0x0041)._0x0044)
end
return 0
end
local function _0x00af(_0x0034)
if not _0x0034 or not _0x0034._0x0035 then return nil end
local _0x00b0 = _0x0034._0x0035:_0x0094(string.char(72, 117, 109, 97, 110, 111, 105, 100))
local _0x008a = _0x0034._0x0035:_0x0037(string.char(72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116))
local _0x00b1 = _0x0034._0x0035:_0x0037(string.char(72, 101, 97, 100))
if not _0x00b0 or not _0x008a or not _0x00b1 then return nil end
local _0x00b2, _0x00b3 = _0x000b:_0x0076(_0x00b1._0x0041 + _0x007e._0x0022(0, 0.5, 0))
local _0x00b4, _0x00b5 = _0x000b:_0x0076(_0x008a._0x0041 - _0x007e._0x0022(0, 2, 0))
if not _0x00b3 or not _0x00b5 or _0x00b2._0x0077 <= 0 or _0x00b4._0x0077 <= 0 then return nil end
local _0x00b6 = math.abs(_0x00b2._0x007b - _0x00b4._0x007b)
local _0x00b7 = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(66, 111, 120, 101, 115)][string.char(83, 99, 97, 108, 101)] or 1.1
local _0x00b8 = _0x00b6 * _0x00b7
local _0x00b9 = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(66, 111, 120, 101, 115)][string.char(87, 105, 100, 116, 104, 32, 82, 97, 116, 105, 111)] or 0.6
local _0x00ba = _0x00b8 * _0x00b9
local _0x00bb = (_0x00b2._0x007b + _0x00b4._0x007b) / 2
local _0x00bc = _0x0079._0x0022(_0x00b4._0x007a, _0x00bb)
return {
_0x00bd = _0x0079._0x0022(_0x00bc._0x007a - _0x00ba/2, _0x00bc._0x007b - _0x00b8/2),
_0x00be = _0x0079._0x0022(_0x00bc._0x007a + _0x00ba/2, _0x00bc._0x007b - _0x00b8/2),
_0x00bf = _0x0079._0x0022(_0x00bc._0x007a - _0x00ba/2, _0x00bc._0x007b + _0x00b8/2),
_0x00c0 = _0x0079._0x0022(_0x00bc._0x007a + _0x00ba/2, _0x00bc._0x007b + _0x00b8/2),
_0x00c1 = _0x00bc,
_0x00c2 = _0x00b8,
_0x00c3 = _0x00ba
}
end
local function _0x00c4(_0x00c5, _0x00c6, _0x00c7, _0x00c8, _0x00c9)
if not _0x00c5 then return _0x0079._0x0022(0, 0) end
local _0x00ca = _0x0079._0x0022(0, 0)
local _0x00cb = 0
if _0x00c9 == string.char(110, 97, 109, 101) then
_0x00cb = (60 / 3)
elseif _0x00c9 == string.char(119, 101, 97, 112, 111, 110) then
_0x00cb = 35
elseif _0x00c9 == string.char(100, 105, 115, 116, 97, 110, 99, 101) then
_0x00cb = 5
end
if _0x00c6 == string.char(84, 111, 112) then
_0x00ca = _0x0079._0x0022(_0x00c5._0x00c1._0x007a, _0x00c5._0x00bd._0x007b - _0x00cb)
elseif _0x00c6 == string.char(66, 111, 116, 116, 111, 109) then
_0x00ca = _0x0079._0x0022(_0x00c5._0x00c1._0x007a, _0x00c5._0x00bf._0x007b + _0x00cb)
elseif _0x00c6 == string.char(76, 101, 102, 116) then
_0x00ca = _0x0079._0x0022(_0x00c5._0x00bd._0x007a - 50, _0x00c5._0x00c1._0x007b)
elseif _0x00c6 == string.char(82, 105, 103, 104, 116) then
_0x00ca = _0x0079._0x0022(_0x00c5._0x00be._0x007a + 50, _0x00c5._0x00c1._0x007b)
elseif _0x00c6 == string.char(84, 111, 112, 76, 101, 102, 116) then
_0x00ca = _0x0079._0x0022(_0x00c5._0x00bd._0x007a - (90 / 3), _0x00c5._0x00bd._0x007b - _0x00cb)
elseif _0x00c6 == string.char(84, 111, 112, 82, 105, 103, 104, 116) then
_0x00ca = _0x0079._0x0022(_0x00c5._0x00be._0x007a + (120 - 90), _0x00c5._0x00be._0x007b - _0x00cb)
elseif _0x00c6 == string.char(66, 111, 116, 116, 111, 109, 76, 101, 102, 116) then
_0x00ca = _0x0079._0x0022(_0x00c5._0x00bf._0x007a - 30, _0x00c5._0x00bf._0x007b + _0x00cb)
elseif _0x00c6 == string.char(66, 111, 116, 116, 111, 109, 82, 105, 103, 104, 116) then
_0x00ca = _0x0079._0x0022(_0x00c5._0x00c0._0x007a + (60 / 2), _0x00c5._0x00c0._0x007b + _0x00cb)
end
return _0x0079._0x0022(_0x00ca._0x007a + _0x00c7, _0x00ca._0x007b + _0x00c8)
end
local function _0x00cc(_0x00cd, _0x00c5, _0x00ce)
if not _0x00c5 then return end
local _0x00cf = _0x00ce and _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(66, 111, 120, 101, 115)][string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] or _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(66, 111, 120, 101, 115)][string.char(67, 111, 108, 111, 114)]
local _0x00d0 = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(66, 111, 120, 101, 115)][string.char(84, 104, 105, 99, 107, 110, 101, 115, 115)]
local _0x00d1 = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(66, 111, 120, 101, 115)][string.char(84, 114, 97, 110, 115, 112, 97, 114, 101, 110, 99, 121)]
for _0x00d2 = 1, 4 do
_0x00cd._0x00d3[_0x00d2]._0x002e = true
_0x00cd._0x00d3[_0x00d2]._0x0090 = _0x00cf
_0x00cd._0x00d3[_0x00d2]._0x002f = _0x00d0
_0x00cd._0x00d3[_0x00d2]._0x0025 = _0x00d1
end
_0x00cd._0x00d3[1]._0x008e, _0x00cd._0x00d3[1]._0x008f = _0x00c5._0x00bd, _0x00c5._0x00be
_0x00cd._0x00d3[2]._0x008e, _0x00cd._0x00d3[2]._0x008f = _0x00c5._0x00be, _0x00c5._0x00c0
_0x00cd._0x00d3[3]._0x008e, _0x00cd._0x00d3[3]._0x008f = _0x00c5._0x00c0, _0x00c5._0x00bf
_0x00cd._0x00d3[(2 + 2)]._0x008e, _0x00cd._0x00d3[4]._0x008f = _0x00c5._0x00bf, _0x00c5._0x00bd
if _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(66, 111, 120, 101, 115)][string.char(70, 105, 108, 108)] then
if not _0x00cd._0x00d4 then
_0x00cd._0x00d4 = _0x002d._0x0022(string.char(83, 113, 117, 97, 114, 101))
_0x00cd._0x00d4._0x00d5 = true
_0x00cd._0x00d4._0x002f = 0
end
_0x00cd._0x00d4._0x002e = true
_0x00cd._0x00d4._0x0090 = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(66, 111, 120, 101, 115)][string.char(70, 105, 108, 108, 32, 67, 111, 108, 111, 114)]
_0x00cd._0x00d4._0x0025 = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(66, 111, 120, 101, 115)][string.char(70, 105, 108, 108, 32, 84, 114, 97, 110, 115, 112, 97, 114, 101, 110, 99, 121)]
_0x00cd._0x00d4._0x008c = _0x0079._0x0022(_0x00c5._0x00c3, _0x00c5._0x00c2)
_0x00cd._0x00d4._0x0041 = _0x00c5._0x00bd
elseif _0x00cd._0x00d4 then
_0x00cd._0x00d4._0x002e = false
end
end
local function _0x00d6(_0x00cd, _0x00c5, _0x00ce)
if not _0x00c5 then return end
local _0x00d7 = _0x000b._0x00d8
local _0x00d9 = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(84, 114, 97, 99, 101, 114, 115)][string.char(79, 114, 105, 103, 105, 110)]
local _0x00da = _0x00ce and _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(84, 114, 97, 99, 101, 114, 115)][string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] or _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(84, 114, 97, 99, 101, 114, 115)][string.char(67, 111, 108, 111, 114)]
local _0x00db
if _0x00d9 == string.char(66, 111, 116, 116, 111, 109) then
_0x00db = _0x0079._0x0022(_0x00d7._0x007a/2, _0x00d7._0x007b)
elseif _0x00d9 == string.char(84, 111, 112) then
_0x00db = _0x0079._0x0022(_0x00d7._0x007a/2, 0)
elseif _0x00d9 == string.char(77, 105, 100, 100, 108, 101) then
_0x00db = _0x0079._0x0022(_0x00d7._0x007a/2, _0x00d7._0x007b/2)
elseif _0x00d9 == string.char(77, 111, 117, 115, 101) then
_0x00db = _0x0008:_0x0071()
end
if not _0x00cd._0x00dc then
_0x00cd._0x00dc = _0x002d._0x0022(string.char(76, 105, 110, 101))
end
_0x00cd._0x00dc._0x008e = _0x00db
_0x00cd._0x00dc._0x008f = _0x00c5._0x00c1
_0x00cd._0x00dc._0x0090 = _0x00da
_0x00cd._0x00dc._0x002f = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(84, 114, 97, 99, 101, 114, 115)][string.char(84, 104, 105, 99, 107, 110, 101, 115, 115)]
_0x00cd._0x00dc._0x0025 = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(84, 114, 97, 99, 101, 114, 115)][string.char(84, 114, 97, 110, 115, 112, 97, 114, 101, 110, 99, 121)]
_0x00cd._0x00dc._0x002e = true
end
local function _0x00dd(_0x0034)
if _0x0034 == _0x000d then return end
local _0x00cd = {
_0x0034 = _0x0034,
_0x00de = _0x002d._0x0022(string.char(84, 101, 120, 116)),
_0x00df = _0x002d._0x0022(string.char(84, 101, 120, 116)),
_0x00e0 = _0x002d._0x0022(string.char(84, 101, 120, 116)),
_0x00d3 = {},
}
for _0x00d2 = 1, 4 do
_0x00cd._0x00d3[_0x00d2] = _0x002d._0x0022(string.char(76, 105, 110, 101))
_0x00cd._0x00d3[_0x00d2]._0x002e = false
_0x00cd._0x00d3[_0x00d2]._0x0030 = (1026 - 26)
end
_0x00cd._0x00de._0x008c = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(78, 97, 109, 101)][string.char(83, 105, 122, 101)]
_0x00cd._0x00de._0x00c1 = true
_0x00cd._0x00de._0x00e1 = true
_0x00cd._0x00de._0x00e2 = _0x0002._0x0003(0, 0, 0)
_0x00cd._0x00de._0x00e3 = _0x002d._0x00e4._0x00e5
_0x00cd._0x00de._0x002e = false
_0x00cd._0x00de._0x0030 = 1000
_0x00cd._0x00df._0x008c = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(68, 105, 115, 116, 97, 110, 99, 101)][string.char(83, 105, 122, 101)]
_0x00cd._0x00df._0x00c1 = true
_0x00cd._0x00df._0x00e1 = true
_0x00cd._0x00df._0x00e2 = _0x0002._0x0003(0, 0, 0)
_0x00cd._0x00df._0x00e3 = _0x002d._0x00e4._0x00e5
_0x00cd._0x00df._0x002e = false
_0x00cd._0x00df._0x0030 = (2000 / 2)
_0x00cd._0x00e0._0x008c = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(87, 101, 97, 112, 111, 110, 115)][string.char(83, 105, 122, 101)]
_0x00cd._0x00e0._0x00c1 = true
_0x00cd._0x00e0._0x00e1 = true
_0x00cd._0x00e0._0x00e2 = _0x0002._0x0003(0, 0, 0)
_0x00cd._0x00e0._0x00e3 = _0x002d._0x00e4._0x00e5
_0x00cd._0x00e0._0x002e = false
_0x00cd._0x00e0._0x0030 = 1000
_0x0015[_0x0034._0x00e6] = _0x00cd
end
local function _0x00e7(_0x0034)
local _0x00cd = _0x0015[_0x0034._0x00e6]
if _0x00cd then
_0x00cd._0x00de:_0x00e8()
_0x00cd._0x00df:_0x00e8()
_0x00cd._0x00e0:_0x00e8()
for _0x0060, _0x00e9 in pairs(_0x00cd._0x00d3) do
_0x00e9:_0x00e8()
end
if _0x00cd._0x00d4 then _0x00cd._0x00d4:_0x00e8() end
if _0x00cd._0x00dc then _0x00cd._0x00dc:_0x00e8() end
_0x0015[_0x0034._0x00e6] = nil
end
end
local function _0x00ea()
if not _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(69, 110, 97, 98, 108, 101, 100)] then
for _0x0060, _0x00cd in pairs(_0x0015) do
_0x00cd._0x00de._0x002e = false
_0x00cd._0x00df._0x002e = false
_0x00cd._0x00e0._0x002e = false
for _0x0060, _0x00e9 in pairs(_0x00cd._0x00d3) do
_0x00e9._0x002e = false
end
if _0x00cd._0x00d4 then _0x00cd._0x00d4._0x002e = false end
if _0x00cd._0x00dc then _0x00cd._0x00dc._0x002e = false end
end
return
end
for _0x00eb, _0x00cd in pairs(_0x0015) do
local _0x0034 = _0x00cd._0x0034
if not _0x0034 or not _0x0034._0x002b then
_0x00e7(_0x0034)
else
if _0x0034._0x0035 and _0x0034._0x0035._0x002b then
local _0x00b0 = _0x0034._0x0035:_0x0094(string.char(72, 117, 109, 97, 110, 111, 105, 100))
if not _0x00b0 or _0x00b0._0x00ec <= 0 then
_0x00cd._0x00de._0x002e = false
_0x00cd._0x00df._0x002e = false
_0x00cd._0x00e0._0x002e = false
for _0x0060, _0x00e9 in pairs(_0x00cd._0x00d3) do
_0x00e9._0x002e = false
end
if _0x00cd._0x00d4 then _0x00cd._0x00d4._0x002e = false end
if _0x00cd._0x00dc then _0x00cd._0x00dc._0x002e = false end
else
local _0x00ce = (_0x0011 == _0x0034)
local _0x00c5 = _0x00af(_0x0034)
if _0x00c5 then
if _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(66, 111, 120, 101, 115)][string.char(69, 110, 97, 98, 108, 101, 100)] then
_0x00cc(_0x00cd, _0x00c5, _0x00ce)
else
for _0x0060, _0x00e9 in pairs(_0x00cd._0x00d3) do
_0x00e9._0x002e = false
end
end
if _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(84, 114, 97, 99, 101, 114, 115)][string.char(69, 110, 97, 98, 108, 101, 100)] then
_0x00d6(_0x00cd, _0x00c5, _0x00ce)
elseif _0x00cd._0x00dc then
_0x00cd._0x00dc._0x002e = false
end
if _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(78, 97, 109, 101)][string.char(69, 110, 97, 98, 108, 101, 100)] then
local _0x00ed = _0x00c4(
_0x00c5,
_0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(78, 97, 109, 101)][string.char(80, 111, 115, 105, 116, 105, 111, 110)],
_0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(78, 97, 109, 101)][string.char(79, 102, 102, 115, 101, 116, 32, 88)],
_0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(78, 97, 109, 101)][string.char(79, 102, 102, 115, 101, 116, 32, 89)],
string.char(110, 97, 109, 101)
)
_0x00cd._0x00de._0x0041 = _0x00ed
_0x00cd._0x00de._0x00ee = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(78, 97, 109, 101)][string.char(85, 115, 101, 32, 68, 105, 115, 112, 108, 97, 121, 32, 78, 97, 109, 101)] and _0x0034._0x00ef or _0x0034._0x002a
_0x00cd._0x00de._0x0090 = _0x00ce and _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(78, 97, 109, 101)][string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] or _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(78, 97, 109, 101)][string.char(67, 111, 108, 111, 114)]
_0x00cd._0x00de._0x002e = true
else
_0x00cd._0x00de._0x002e = false
end
if _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(68, 105, 115, 116, 97, 110, 99, 101)][string.char(69, 110, 97, 98, 108, 101, 100)] then
local _0x00f0 = _0x00ad(_0x0034)
local _0x00f1 = _0x00c4(
_0x00c5,
_0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(68, 105, 115, 116, 97, 110, 99, 101)][string.char(80, 111, 115, 105, 116, 105, 111, 110)],
_0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(68, 105, 115, 116, 97, 110, 99, 101)][string.char(79, 102, 102, 115, 101, 116, 32, 88)],
_0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(68, 105, 115, 116, 97, 110, 99, 101)][string.char(79, 102, 102, 115, 101, 116, 32, 89)],
string.char(100, 105, 115, 116, 97, 110, 99, 101)
)
_0x00cd._0x00df._0x0041 = _0x00f1
_0x00cd._0x00df._0x00ee = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(68, 105, 115, 116, 97, 110, 99, 101)][string.char(70, 111, 114, 109, 97, 116)]:gsub(string.char(123, 125), tostring(_0x00f0))
_0x00cd._0x00df._0x0090 = _0x00ce and _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(68, 105, 115, 116, 97, 110, 99, 101)][string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] or _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(68, 105, 115, 116, 97, 110, 99, 101)][string.char(67, 111, 108, 111, 114)]
_0x00cd._0x00df._0x002e = true
else
_0x00cd._0x00df._0x002e = false
end
if _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(87, 101, 97, 112, 111, 110, 115)][string.char(69, 110, 97, 98, 108, 101, 100)] then
local _0x00f2 = _0x00a9(_0x0034)
local _0x00f3 = _0x00c4(
_0x00c5,
_0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(87, 101, 97, 112, 111, 110, 115)][string.char(80, 111, 115, 105, 116, 105, 111, 110)],
_0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(87, 101, 97, 112, 111, 110, 115)][string.char(79, 102, 102, 115, 101, 116, 32, 88)],
_0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(87, 101, 97, 112, 111, 110, 115)][string.char(79, 102, 102, 115, 101, 116, 32, 89)],
string.char(119, 101, 97, 112, 111, 110)
)
_0x00cd._0x00e0._0x0041 = _0x00f3
_0x00cd._0x00e0._0x00ee = _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(87, 101, 97, 112, 111, 110, 115)][string.char(70, 111, 114, 109, 97, 116)]:gsub(string.char(123, 125), _0x00f2)
_0x00cd._0x00e0._0x0090 = _0x00ce and _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(87, 101, 97, 112, 111, 110, 115)][string.char(84, 97, 114, 103, 101, 116, 32, 67, 111, 108, 111, 114)] or _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(87, 101, 97, 112, 111, 110, 115)][string.char(67, 111, 108, 111, 114)]
_0x00cd._0x00e0._0x002e = true
else
_0x00cd._0x00e0._0x002e = false
end
else
_0x00cd._0x00de._0x002e = false
_0x00cd._0x00df._0x002e = false
_0x00cd._0x00e0._0x002e = false
for _0x0060, _0x00e9 in pairs(_0x00cd._0x00d3) do
_0x00e9._0x002e = false
end
if _0x00cd._0x00d4 then _0x00cd._0x00d4._0x002e = false end
if _0x00cd._0x00dc then _0x00cd._0x00dc._0x002e = false end
end
end
else
_0x00cd._0x00de._0x002e = false
_0x00cd._0x00df._0x002e = false
_0x00cd._0x00e0._0x002e = false
for _0x0060, _0x00e9 in pairs(_0x00cd._0x00d3) do
_0x00e9._0x002e = false
end
if _0x00cd._0x00d4 then _0x00cd._0x00d4._0x002e = false end
if _0x00cd._0x00dc then _0x00cd._0x00dc._0x002e = false end
end
end
end
end
for _0x0060, _0x0034 in pairs(_0x0005:_0x0072()) do
if _0x0034 ~= _0x000d then
_0x00dd(_0x0034)
end
end
_0x0005._0x00f5:_0x00f6(function(_0x0034)
if _0x0034 ~= _0x000d then
_0x00dd(_0x0034)
end
end)
_0x0005._0x00f7:_0x00f6(function(_0x0034)
if _0x0011 == _0x0034 then
_0x0011 = nil
_0x0012 = nil
_0x0013 = false
end
_0x00e7(_0x0034)
end)
local function _0x00fb(_0x0034)
if _0x0034 ~= _0x0011 then return end
_0x0034._0x00fc:_0x00f6(function(_0x003e)
if _0x0034 == _0x0011 then
_0x00fd._0x00fe(0.5)
_0x0069()
end
end)
end
local function _0x0101(_0x003d)
if not _0x003d or _0x001d[_0x003d] then return end
_0x001d[_0x003d] = _0x003d._0x008c
end
local function _0x0102(_0x003d)
if _0x003d and _0x001d[_0x003d] then
pcall(function()
_0x003d._0x008c = _0x001d[_0x003d]
end)
end
end
local function _0x0103(_0x003d, _0x0104)
if not _0x003d then return end
_0x0101(_0x003d)
_0x003d._0x008c = _0x007e._0x0022(_0x0104, _0x0104, _0x0104)
end
local function _0x0105()
for _0x003d, _0x0106 in pairs(_0x001d) do
if _0x003d and _0x003d._0x002b then
pcall(function()
_0x003d._0x008c = _0x0106
end)
else
_0x001d[_0x003d] = nil
end
end
end
local function _0x0107()
if not _0x0004[string.char(72, 105, 116, 98, 111, 120, 32, 69, 120, 112, 97, 110, 100, 101, 114)][string.char(69, 110, 97, 98, 108, 101, 100)] then
_0x0105()
return
end
local _0x0108 = _0x0004[string.char(72, 105, 116, 98, 111, 120, 32, 69, 120, 112, 97, 110, 100, 101, 114)][string.char(83, 105, 122, 101)]
_0x0105()
if _0x0013 and _0x0011 and _0x0011._0x0035 then
local _0x0109 = _0x0011._0x0035:_0x0037(string.char(72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116))
if _0x0109 then
_0x0103(_0x0109, _0x0108)
end
end
end
_0x0009._0x010c:_0x00f6(function()
if _0x003b() and _0x0013 then
_0x0013 = false
_0x002c._0x002e = false
end
if _0x0011 then
if _0x0011._0x0035 then
if not _0x0012 or not _0x0012._0x002b then
_0x0069()
end
end
end
_0x0091()
if _0x0016 and _0x0004[string.char(83, 112, 101, 101, 100)][string.char(69, 110, 97, 98, 108, 101, 100)] then
local _0x00b0 = _0x000d._0x0035 and _0x000d._0x0035:_0x0037(string.char(72, 117, 109, 97, 110, 111, 105, 100))
if _0x00b0 then
_0x00b0._0x010d = _0x0017 * _0x0004[string.char(83, 112, 101, 101, 100)][string.char(77, 117, 108, 116, 105, 112, 108, 105, 101, 114)]
end
end
_0x0107()
_0x0089()
_0x008d()
_0x00ea()
if _0x0004[string.char(67, 97, 109, 101, 114, 97, 32, 76, 111, 99, 107)][string.char(69, 110, 97, 98, 108, 101, 100)] then
_0x0082()
end
end)
_0x0008._0x0110:_0x00f6(function(_0x0111, _0x0112)
if _0x0112 then return end
if _0x0111._0x0113 == _0x0028._0x0113[_0x0004[string.char(75, 101, 121, 98, 105, 110, 100, 115)][string.char(84, 97, 114, 103, 101, 116, 32, 76, 111, 99, 107)][string.char(75, 101, 121)]] then
local _0x0114 = _0x0004[string.char(75, 101, 121, 98, 105, 110, 100, 115)][string.char(84, 97, 114, 103, 101, 116, 32, 76, 111, 99, 107)][string.char(77, 111, 100, 101)]
if _0x0114 == string.char(84, 111, 103, 103, 108, 101) then
if _0x0004[string.char(83, 101, 116, 116, 105, 110, 103, 115)][string.char(84, 97, 114, 103, 101, 116, 32, 65, 105, 109)] then
if _0x0013 then
_0x0013 = false
_0x0011 = nil
_0x0012 = nil
_0x002c._0x002e = false
else
local _0x0115 = _0x006b()
if _0x0115 then
_0x0011 = _0x0115
_0x00fb(_0x0115)
_0x0013 = true
end
end
else
_0x0013 = not _0x0013
if not _0x0013 then
_0x002c._0x002e = false
end
end
elseif _0x0114 == string.char(72, 111, 108, 100) then
if _0x0004[string.char(83, 101, 116, 116, 105, 110, 103, 115)][string.char(84, 97, 114, 103, 101, 116, 32, 65, 105, 109)] then
local _0x0115 = _0x006b()
if _0x0115 then
_0x0011 = _0x0115
_0x00fb(_0x0115)
_0x0013 = true
end
else
_0x0013 = true
end
end
end
if _0x0111._0x0113 == _0x0028._0x0113[_0x0004[string.char(75, 101, 121, 98, 105, 110, 100, 115)][string.char(84, 114, 105, 103, 103, 101, 114, 32, 66, 111, 116)][string.char(75, 101, 121)]] then
local _0x0114 = _0x0004[string.char(75, 101, 121, 98, 105, 110, 100, 115)][string.char(84, 114, 105, 103, 103, 101, 114, 32, 66, 111, 116)][string.char(77, 111, 100, 101)]
if _0x0114 == string.char(84, 111, 103, 103, 108, 101) then
_0x0014 = not _0x0014
elseif _0x0114 == string.char(72, 111, 108, 100) then
_0x0014 = true
end
end
if _0x0111._0x0113 == _0x0028._0x0113[_0x0004[string.char(75, 101, 121, 98, 105, 110, 100, 115)][string.char(83, 112, 101, 101, 100)]] then
_0x0016 = not _0x0016
if not _0x0016 then
local _0x00b0 = _0x000d._0x0035 and _0x000d._0x0035:_0x0037(string.char(72, 117, 109, 97, 110, 111, 105, 100))
if _0x00b0 then
_0x00b0._0x010d = _0x0017
end
end
end
if _0x0111._0x0113 == _0x0028._0x0113[_0x0004[string.char(75, 101, 121, 98, 105, 110, 100, 115)][string.char(69, 83, 80)]] then
_0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(69, 110, 97, 98, 108, 101, 100)] = not _0x0004[string.char(69, 83, 80, 32, 83, 101, 116, 116, 105, 110, 103, 115)][string.char(69, 110, 97, 98, 108, 101, 100)]
end
end)
_0x0008._0x0116:_0x00f6(function(_0x0111, _0x0112)
if _0x0112 then return end
if _0x0111._0x0113 == _0x0028._0x0113[_0x0004[string.char(75, 101, 121, 98, 105, 110, 100, 115)][string.char(84, 97, 114, 103, 101, 116, 32, 76, 111, 99, 107)][string.char(75, 101, 121)]] then
local _0x0114 = _0x0004[string.char(75, 101, 121, 98, 105, 110, 100, 115)][string.char(84, 97, 114, 103, 101, 116, 32, 76, 111, 99, 107)][string.char(77, 111, 100, 101)]
if _0x0114 == string.char(72, 111, 108, 100) then
_0x0013 = false
_0x0011 = nil
_0x0012 = nil
_0x002c._0x002e = false
end
end
if _0x0111._0x0113 == _0x0028._0x0113[_0x0004[string.char(75, 101, 121, 98, 105, 110, 100, 115)][string.char(84, 114, 105, 103, 103, 101, 114, 32, 66, 111, 116)][string.char(75, 101, 121)]] then
local _0x0114 = _0x0004[string.char(75, 101, 121, 98, 105, 110, 100, 115)][string.char(84, 114, 105, 103, 103, 101, 114, 32, 66, 111, 116)][string.char(77, 111, 100, 101)]
if _0x0114 == string.char(72, 111, 108, 100) then
_0x0014 = false
end
end
end)
local _0x0119 = _0x0006:_0x0007(string.char(86, 105, 114, 116, 117, 97, 108, 85, 115, 101, 114))
_0x000d._0x011a:_0x00f6(function()
_0x0119:_0x011b()
_0x0119:_0x011c(_0x0079._0x0022())
end)
