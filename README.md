# brinevector3D
A simple vector lua library for everyone for 3D!

# This is a fork of the brinevector (2D only)

### Motivation
I personally like brinevector, because it uses ffi to make structs for vectors instead of using tables, which makes it faster and more efficient, but I also need this for [bump3dpd](http://github.com/oniietzschan/bump-3dpd) which needs x,y,z.
### Compatibility
BrineVector3D was written for LOVE2D and is accelerated by the ffi module in luajit, but can be used for any luajit program.

# installation
Paste the `brinevector3D.lua` file and its accompanying `BRINEVECTOR_LICENSE3D` into your project.

Simply `require` the file in your projects and give the returned table a name
```lua
Vector3D = require "brinevector3D"
```
Or, 
```lua
local Vector3D = require "brinevector3D"
```
You can replace `Vector3D` with any name you wish to use. Even `V`, for brevity. If you gave it any other name than `Vector3D`, in all code examples that follow, replace `Vector3D` with whatever name you gave it in the `require` call.
# usage
[Here](https://github.com/novemberisms/brinevector/blob/master/cheatsheet.md) is an overview of all the features, properties, and methods of this library all in one place, and for most people, is everything they need to use this library. 

For beginners, or for anyone who wants more details, read the sections down below.
## Instantiating a vector
To create a new vector, just call the module directly
```lua
local myVec = Vector3D(3,4,5) --x = 3, y = 4, z = 5
```
where 
-   the first argument will be the x-component of the new vector, 
-   and the second argument will be the y-component of the new vector.

If no arguments are given, then it defaults to creating a zero-vector. (x component equals `0` and y component equals `0` and z component equals `0`). Thus
```lua
local zVec = Vector3D()
```
is equivalent to 
```lua
local zVec = Vector3D(0,0,0)
```

NOTE: You can also just use this for 2D Vectors like `local myVector = Vector3D(32,32)`, but c'mon, use the original brinevector for that

## Accessing a vector's components
### Getting
Getting the x,y, and z components of a vector works as you expect. 

If you have
```lua
local myVec = Vector3D(3,4,5)
```
then `myVec.x` and `myVec.y` and `myVec.z` will return the x,y, and z components of `myVec`, respectively.
(`3` and `4` and `5`)
```lua
print ( myVec.x )   -- prints "3"
print ( myVec.y )   -- prints "4"
print ( myVec.z )   -- prints "5"
```
### Setting
Assigning and modifying the x,y and z components is also straightforward
```lua
myVec.x = 10
myVec.y = 20
myVec.z = 30
```
will set the x component of `myVec` to `10` and the y component to `20` and z component to `30`
## Printing a vector
When using `tostring` or `print` on a vector, it will display in a readable format with 4 decimal places for each component. Thus,
```lua
local myVec = Vector3D(3,4,5)
print(myVec)
```
## Vector3D Arithmetic
### Addition and Subtraction
You can add and subtract vectors using `+` and `-`
If you have
```lua
local a = Vector3D(3,4,5)
local b = Vector3D(1,2,3)
```
then
```lua
a + b       -- returns a vector <4,6,8>
a - b       -- returns a vector <2,2,2>
b - a       -- returns a vector <-2,-2,-2>
a = a + b   -- a then becomes <4,6,8>
```

### Multiplication with a scalar
There are a few different types of vector multiplication. The simplest is multiplication of a vector with a number. 
```lua
local a = Vector3D(3,4,5)
a * 5           -- returns <15,20,25>
a * -1          -- returns <-3,-4,-5>
local c = a * 2 -- instantiates a new vector with values <6,8,10>
```
### Multiplication with another vector
Multiplying two vectors together with the operator `*` performs the [dot product](https://en.wikipedia.org/wiki/Dot_product), which returns a single number.
```lua
local a = Vector3D(1,2,3)
local b = Vector3D(3,4,5)
a * b   -- results with (a.x * b.x) + (a.y * b.y) + (a.z * b.z), which is 19
```
### Hadamard product
In some cases, you might want to get a vector whose x component is the product of two other vectors' x components, and whose y component is the product of their y components. (ie. "Component-wise" or "Freshman" multiplication)
```lua
local a = Vector3D(3,4,5)
local b = Vector3D(1,-1,1)
local c = Vector3D(a.x * b.x, a.y * b.y, a.z * b.z)  -- c becomes <3,-4,5>
```
There really isn't a predefined mathematical symbol for this, so I chose the `%` operator, as it has no uses with vectors otherwise. Thus the above example can also be written more succinctly as
```lua
local c = a % b         -- c becomes <3,-4,5>
```
If that makes you uncomfortable because % to you can only mean modulo, then alternatively you can use
```lua
local c = a:hadamard(b) -- c becomes <3,-4,5>
```
### Division with a scalar
Dividing a vector `V` with a scalar `x`, is exactly equivalent to multiplying `V` with `1/x`. Thus,
```lua
local a = Vector3D(3,4,5)
a / 5   -- returns <0.6,0.8,1>
```
### Division with a vector?
In mathematics, there is no rule for dividing a vector with another vector, and so trying
```lua
local a = Vector3D(1,1,1)
local b = Vector3D(5,5,1)
a / b
```
produces an error: `must divide by a scalar`

### Negation
A vector preceded by the unary minus operation (like `-v`, where `v` is a vector) is exactly equivalent to `v * -1`
```lua
local a = Vector3D(3,4,5)
-a      -- returns <-3,-4,-5>
-a * 5  -- returns <-15,-20,-25>
```
## Vector3D properties
For maximum convenience and ease of use, the most common properties of a vector are accessed just like any members of a table, **_without having to call any methods_** like in other libraries.

These are:
-   `length`
-   `angle`
-   `normalized`
-   `length2`
### length
You can access the length of a vector with `.length`. 
Thus if you have
```lua
local myVec = Vector3D(3,4,5)
```
then
```lua
myVec.length
```
produces `5`. 
Even if you edit the vector later on, accessing the `length` property automatically computes the new length. This makes code shorter and more understandable. This is true for all the other special properties. They are generated on the fly when you ask for them.
```lua
local myVec = Vector3D(3,4,5)
local a = myVec.length        -- a becomes '5'
myVec = myVec * 3             -- myVec is now <9,12>
local b = myVec.length        -- b becomes '15'
```
Notice how you don't need to use a method like `a:length()` or `a:getLength()`. 
You simply use `a.length`
### angle
Using `.angle` gives the angle of a vector in radians
```lua
local myVec = Vector3D(1,1)
myVec.angle     -- produces PI/4 radians, or 0.78539816339744828
```
### normalized
Using `.normalized` gives the normalized vector of a given vector. That is, a vector with the same angle as the original, but whose length is `1`.
```lua
local myVec = Vector3D(3,4)
local myVecN = myVec.normalized    -- myVecN becomes <0.6,0.8>
myVecN.length                      -- is '1'
```
### length2
For most purposes (like comparing the lengths of vectors) you only need to compare the squares of the lengths of the vectors. This is because to get the length, any library needs to call `math.sqrt`. This can be slow, and so if you're conscious about performance, you can use `.length2`, which returns the length of a vector squared
```lua
-- compare the lengths of two vectors
local bakery = Vector3D(3,4)
local restaurant = Vector3D(10,10)

if bakery.length2 < restaurant.length2 then
    print("The bakery is closer")
elseif bakery.length2 > restaurant.length2 then
    print("The restaurant is closer")
end
-- outputs "The bakery is closer"
```
## Vector3D methods
### Property methods
If you prefer getting the above properties with methods instead like in other libraries, you can always still use the following:
-   `myVec:getLength()`   -- equivalent to `myVec.length`
-   `myVec:getAngle()`    -- equivalent to `myVec.angle`
-   `myVec:getNormalized()` -- equivalent to `myVec.normalized`
-   `myVec:getLengthSquared()`  -- equivalent to `myVec.length2`

### angled
###### `myVec:angled( angle )`
This returns a vector whose length is the same as `myVec` but whose angle is set to `angle` (in radians). For example,
```lua
local a = Vector3D(3,4)
local b = a:angled(0)
```
will set `b` to a vector with length `5` and whose angle is `0`. ie. `<5,0>`

This is equivalent to 
```lua
local a = Vector3D(3,4)
local b = Vector3D(a.length*math.cos(0), a.length*math.cos(0))
```
### trim
###### `myVec:trim( length )`
This returns a vector with the same angle as `myVec`, but whose length is "trimmed" down to `length` only if it is longer than `length`. 

That is, if the length of `myVec` is greater than `length`, then the returned vector will have length `length`. If the length of `myVec` is less than `length` then it will return a vector identical to `myVec`

```lua
local a = myVec:trim( 10 )
```
is equivalent to the following code:
```lua
local a = Vector3D(myVec.x, myVec.y)
if a.length > 10 then
    a = a.normalized * 10
end
```
This is useful for applying max velocity to an accelerating object. For example if you're updating the velocity `vel` of an object with acceleration `acc`, and whose speed must be capped to `MAXSPEED`, you can write,
```lua
vel = (vel + acc):trim(MAXSPEED)
```
instead of 
```lua
vel = vel + acc
if vel.length > MAXSPEED then
    vel = vel.normalized * MAXSPEED
end
```
### hadamard
###### `myVec:hadamard( otherVec )`
This returns a vector that is the result of a component-wise multiplication between `myVec` and `otherVec`. Thus `a = b:hadamard(c)` is equivalent to
```lua
a = Vector3D( b.x * c.x, b.y * c.y )
```
Alternatively, you can use `a = b % c`.

### split
###### `myVec:split( )`
This returns two values: the x component of the vector, and the y component of the vector.
Thus,
```lua
local x, y = myVec:split()
```
is equivalent to 
```lua
local x, y = myVec.x, myVec.y
```
## Method Shortcuts
Vector3Ds can also be directly modified through their `length` and `angle` properties. This makes for some very short code.

If you have
```lua
myVec = Vector3D(3,4)
```
, and you want to modify it such that it keeps its direction but its length changes to `20`, then you can simply do
```lua
myVec.length = 20
```
And now if you inspect `myVec`,
```lua
"Vector3D{12.0000,16.0000}"
```
This is equivalent to 
```lua
myVec = myVec.normalized * 20
```
---
Similarly, if you have a vector
```lua
myUnitVec = Vector3D(1,0)
```
And you want it to point to an angle called `someangle`, but still have a length of 1, then simply do
```lua
myUnitVec.angle = someangle
```
This is equivalent to
```lua
myUnitVec = myUnitVec:angled(someangle)
```

## Comparing vectors with `==`
Vector3Ds can be compared with any other data using `==`. 

`myVec == something` will only return `true` if 
-   `something` is another vector and
-   `something.x` == `myVec.x` and
-   `something.y` == `myVec.y`
-   `something.z` == `myVec.z`

Otherwise, it will return `false`
## Checking if a variable is a vector
Use __`Vector3D.isVector3D(x)`__ to check if `x` is a vector instantiated from the table returned by `require "brinevector"`.

## SUPPORT
You can look at more functionalities in the original [brinevector](http://github.com/novemberisms/brinevector)

# license

>Copyright 2018 'novemberisms' aka. Brian Sarfati
>
>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
