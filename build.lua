love.maker = require("maker")
love.maker.setExtensions('lua', 'png', 'txt') -- include only the specified extensions

local build = love.maker.newBuild("./build") -- create from source folder
build:ignore('/readme.txt') -- exclude a specific file
build:ignoreMatch('^/%.git') -- exclude based on pattern matching
build:allow('/images/exception.jpg') -- whitelist a specific file

build:save('./build/game.love', 'DEMO') -- build the .love project file
local comment = love.maker.getComment(dest)
print(comment)