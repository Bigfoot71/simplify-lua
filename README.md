# Simplify-lua

This is a Lua port of [simplify-js](https://github.com/mourner/simplify-js) by Vladimir Agafonkin.

# Usage

```
simplify = require("simplify")
local points = simplify(points, tolerance, highestQuality)
```

### Function parameters

`points`: Table containing the points. Can be represented as a single table or as a table of tables depending on the version chosen, i.e. like this:
```
Single table:

	local points = {x1,y1, x2,y2, x3,y3, ...}
```

```
Table of tables:

	local points = { {x,y}, {x,y}, {x,y}, ...}
```
`tolerance [optional, 0.1 by default]`: Affects the amount of simplification that occurs (the smaller, the less simplification).

`highestQuality [optional, true by default]`: Flag to exclude the distance pre-processing. Produces higher quality results, but runs slower.
