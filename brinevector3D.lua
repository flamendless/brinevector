--[[
BrineVector3D3D: a luajit ffi-accelerated vector library for 3D (x,y,z)

3D SUPPORT implemented by:
Brandon Blanker Lim-it @flamendless

ORIGINAL Brinevector lib by:
Copyright 2018 Brian Sarfati

Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
and associated documentation files (the "Software"), to deal in the Software without restriction, 
including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or 
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE 
AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local ffi = require "ffi"
ffi.cdef[[
typedef struct {
  float x;
  float y;
  float z;
} brinevector3D;
]]

local Vector3D = {}
setmetatable(Vector3D,Vector3D)


function Vector3D.__index(t, k)
  if k == "length" then
    return Vector3D.getLength(t)
  elseif k == "normalized" then
    return Vector3D.getNormalized(t)
  elseif k == "angle" then
    return Vector3D.getAngle(t)
  elseif k == "length2" then
    return Vector3D.getLengthSquared(t)
  end
  return rawget(Vector3D,k)
end

function Vector3D.getLength(v)
  return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
end

function Vector3D.getLengthSquared(v)
  return v.x*v.x + v.y*v.y + v.z*v.z
end

function Vector3D.getNormalized(v)
  local length = v.length
  if length == 0 then return Vector3D(0,0,0) end
  return Vector3D(v.x / length, v.y / length, v.z/length)
end

function Vector3D.getAngle(v)
  return math.atan2(v.y, v.x, v/z)
end

function Vector3D.__newindex(t,k,v)
  if k == "length" then
    local res = t.normalized * v
    t.x = res.x
    t.y = res.y
    t.z = res.z
    return
  end
  if k == "angle" then
    local res = t:angled(v)
    t.x = res.x
    t.y = res.y
    t.z = res.z
    return
  end
  if type(t) == "cdata" then
    error("Cannot assign a new property '" .. k .. "' to a Vector3D") 
  else
    rawset(t,k,v)
  end
end

function Vector3D.angled(v, angle)
  local length = v.length
  return Vector3D(math.cos(angle) * length, math.sin(angle) * length, math.tan(angle) * length)
end

function Vector3D.trim(v,mag)
  if v.length < mag then return v end
  return v.normalized * mag
end

function Vector3D.split(v)
  return v.x, v.y, v.z
end

function Vector3D.hadamard(v1, v2) -- also known as "Componentwise multiplication"
  return Vector3D(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z)
end

local iteraxes_lookup = {
  xy = {"x","y"},
  yx = {"y","x"},
  xz = {"x","z"},
  zx = {"z","x"},
  yz = {"y", "z"},
  zy = {"z","y"}
}
local function iteraxes(ordertable, i)
  i = i + 1
  if i > 2 then return nil end
  return i, ordertable[i]
end

function Vector3D.axes(order)
  return iteraxes, iteraxes_lookup[order or "yx"], 0
end

function Vector3D.isVector(arg)
  return ffi.istype("brinevector3D",arg)
end

function Vector3D.__add(v1, v2)
  return Vector3D(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
end

function Vector3D.__sub(v1, v2)
  return Vector3D(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
end

function Vector3D.__mul(v1, op)
  -- acts as a dot multiplication if op is a vector
  -- if op is a scalar then works as usual
  if type(v1) == "number" then
    return Vector3D(op.x * v1, op.y * v1, op.z * v1)
  end
  if type(op) == "cdata" then
    return v1.x * op.x + v1.y * op.y + v1.z * op.z
  else
    return Vector3D(v1.x * op, v1.y * op, v1.z * op)
  end
end

function Vector3D.__div(v1, op)
  if type(op) ~= "number" then error("must divide by a scalar") end
  return Vector3D(v1.x / op, v1.y / op, v1.z / op)
end

function Vector3D.__unm(v)
  return Vector3D(-v.x, -v.y, -v.z)
end

function Vector3D.__eq(v1,v2)
  if (not ffi.istype("brinevector3D",v2)) or (not ffi.istype("brinevector3D",v1)) then return false end
  return v1.x == v2.x and v1.y == v2.y and v1.z == v2.z
end

function Vector3D.__mod(v1,v2)  -- ran out of symbols, so i chose % for the hadamard product
  return Vector3D(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z)
end

function Vector3D.__tostring(t)
  return string.format("Vector3D{%.4f,%.4f,%.4f}",t.x,t.y,t.z)
end

function Vector3D.__concat(v1, v2)
	return v1 .. tostring(v2)
end

function Vector3D.__call(t,x,y,z)
  return ffi.new("brinevector3D",x or 0,y or 0, z or 0)
end

ffi.metatype("brinevector3D",Vector3D)

return Vector3D
