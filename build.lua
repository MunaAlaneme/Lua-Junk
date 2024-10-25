love.maker = require("maker")
-- love.maker.setExtensions('lua', 'png', 'txt', 'svg') -- include only the specified extensions

local build = love.maker.newBuild("./build") -- create from source folder
build:ignore('/readme.txt') -- exclude a specific file
build:ignoreMatch('^/%.git') -- exclude based on pattern matching
build:allow('/assets/img/raster/emoji_u274c2.png') -- whitelist a specific file

build:save('./makelove-build/love/LuaLovePlatformer.love', 'DEMO') -- build the .love project file
local comment = love.maker.getComment(dest)
print(comment)