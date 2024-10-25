-- poke1024 - TÖVE (SVG) - May 19, 2018
-- https://github.com/poke1024/tove2d

-- nasso - Lovector (SVG) - March 16, 2019
-- https://github.com/nasso/lovector

-- nkorth - Sunday September 18, 2011 10:14pm
-- https://love2d.org/forums/viewtopic.php?t=3636

-- (Vrld) Matthias Richter - hump (camera) - May 1, 2016
-- https://github.com/vrld/hump

-- 2dengine - love.maker - December 4, 2021
-- https://github.com/2dengine/love.maker

-- local tove = require "lib.ext.tove"
local lovector = require "lib.ext.lovector"
local camera = require 'lib.humpcamera'
local music
local musicStart
local font
local graphics = nil

Menu = require 'lib.menu'

fullscreen = false

-- load graphics from svg file. TÖVE also supports
-- constructing vector graphics on the fly.

-- svgData = love.filesystem.read("assets/img/vector/emoji_u274c2.svg")
-- graphics = tove.newGraphics(svgData, 200)
frames = 0
musicNumi = love.math.random(0, 1)
if musicNumi == 0 then
    music = love.audio.newSource("assets/audio/music/wav/Blue Warrior - papermariotyd-menuscreenGS-loop.wav", "stream")
    musicStart = love.audio.newSource("assets/audio/music/wav/Blue Warrior - papermariotyd-menuscreenGS-full-intro.wav", "stream")
end
if musicNumi == 1 then
    music = love.audio.newSource("assets/audio/music/wav/flappygolf2 - 1-pancakes.wav", "stream")
    musicStart = love.audio.newSource("assets/audio/sfx/wav/null.wav", "stream")
end
music:setLooping(true)
musicStart:play()
-- music:setPitch(0.8)

-- for rendering, choose among three renderers:
-- "texture" will render into a bitmap
-- "mesh" will tesselate into a mesh
-- "gpux" will use a shader implementation

-- graphics:setDisplay("mesh", 200)

local Dropdown1is_open = false
local Dropdown1selected_index = 1
local DropdownOptions1 = {
    "Option 1",
    "Option 2",
    { text = "Option 3", value = 3 }
}  

function love.load()
    screen_width = 800
    screen_height = 450
    CamX = screen_width / 2
    CamY = screen_height / 2
    cam = camera(CamX,CamY)
    windowScale = 1
    ActualWindowScale = 1
    
    love.window.setTitle("First Lua Game")
    love.window.setMode(screen_width, screen_height, {resizable = true, msaa = 0, highdpi = true, vsync = false})
    love.graphics.setDefaultFilter('nearest', 'nearest')
    graphics = lovector.SVG("assets/img/vector/emoji_u274c2.svg")
    font = love.graphics.newFont("assets/fonts/Roboto/Roboto-Regular.ttf", 24)
    love.graphics.setFont(font)
    Screen = "TitleMenu"
    
    MusicSlider = {
        x = 1210,
        y = 230,
        width = 200,
        endx = 300,
        height = 20,
        value = 0.5,
        dragging = false
    }
    love.audio.setVolume(0.5)
    TestMenu1 = Menu.new()
	TestMenu1:addItem{
		name = 'Start Game',
		action = function()
			-- do something
		end
	}
    TestMenu1:addItem{
		name = 'Donate',
		action = function()
			-- do something
		end
	}
	TestMenu1:addItem{
		name = 'Options',
		action = function()
            Screen = "SettingsScreen"
			CamX = (screen_width / 2)*4
		end
	}
	TestMenu1:addItem{
		name = 'Quit',
		action = function()
			love.event.quit()  -- Quit the game
		end
	}
    TestMenu2 = Menu.new()
	TestMenu2:addItem{
		name = 'Start Game',
		action = function()
			-- do something
		end
	}
    TestMenu2:addItem{
		name = '< Screen Size                   >',
		action = function()
			-- do something
		end
	}
	TestMenu2:addItem{
		name = 'Back',
		action = function()
            Screen = "TitleMenu"
			CamX = (screen_width / 2)*1
		end
	}
	TestMenu2:addItem{
		name = 'Quit',
		action = function()
			love.event.quit()  -- Quit the game
		end
	}
end
ActualWindowScale = 1
WindowYScale = 1
WindowXScale = 1
oldWindowScale = 1
windowWidth, windowHeight = 800, 450
function love.update(dt)
    frames = frames + 1
    oldWindowWidth, oldWindowHeight, oldFlags = love.window.getMode()
    if windowWidth ~= oldWindowWidth or windowHeight ~= oldWindowHeight then
        cam:move((CamX*WindowXScale) - (cam.x*1), (CamY*WindowYScale) - (cam.y*1))
    end
    windowWidth, windowHeight, flags = love.window.getMode()
    WindowXScale = windowWidth / screen_width
    WindowYScale = windowHeight / screen_height
    if WindowXScale < 0.1 and WindowYScale < 0.1 then
        windowScale = math.max(WindowXScale, WindowYScale)
    elseif WindowXScale > 0.1 and WindowYScale > 0.1 then
        windowScale = math.min(WindowXScale, WindowYScale)
    else
        windowScale = 0.1
    end
    if ActualWindowScale < 0.5 then
        ActualWindowScale = 0.5
        love.window.setMode(screen_width * ActualWindowScale, screen_height * ActualWindowScale, {resizable = true, msaa = 0, highdpi = true})
    end
    if windowScale ~= oldWindowScale then
        cam:move((CamX*WindowXScale) - (cam.x*1), (CamY*WindowYScale) - (cam.y*1))
    end
    local dx,dy = (CamX*WindowXScale) - cam.x, (CamY*WindowYScale) - cam.y
    cam:move(dx/(0.1/dt), dy/(0.1/dt))
	mouseX, mouseY = love.mouse.getPosition()
    mouseeX, mouseeY = mouseX + (cam.x-((screen_width*WindowXScale)/2)), mouseY + (cam.y-((screen_height*WindowYScale)/2))
    -- Update MusicSlider value based on mouse position when dragging
    if MusicSlider.dragging then
        MusicSlider.value = math.min(1, math.max(0, (mouseeX/WindowXScale - MusicSlider.x) / MusicSlider.width))
    end
    love.audio.setVolume(MusicSlider.value)
    if not musicStart:isPlaying() then
        music:play()
    end
    TestMenu1:update(dt)
    TestMenu2:update(dt)
    oldWindowScale = windowScale
end

function love.draw()
    cam:attach()
    font = love.graphics.newFont("assets/fonts/Roboto/Roboto-Regular.ttf", 24*windowScale)
    TestMenu1:draw(10 * WindowXScale, 275 * WindowYScale, 300 * WindowXScale, 40 * WindowYScale, 128, 0, 255, 128)
    TestMenu2:draw(10*WindowXScale + (windowWidth/2)*3, 275 * WindowYScale, 300 * WindowXScale, 40 * WindowYScale, 128, 0, 255, 128)
    love.graphics.setFont(font)
    -- render svg at mouse position.
    love.graphics.print(windowScale, 10*WindowXScale, 50*windowScale)
    graphics = lovector.SVG("assets/img/vector/emoji_u274c2.svg")
    graphics:draw(mouseeX, mouseeY, 50 * windowScale)
    love.graphics.draw(love.graphics.newImage("/assets/img/raster/emoji_u274c2.png"), mouseeX - 32*windowScale, mouseeY - 32*windowScale, 0, windowScale/32)
    -- others
    love.graphics.setFont(love.graphics.newFont("assets/fonts/Roboto/Roboto-Bold.ttf", 24*windowScale))
    love.graphics.print("Hello World!", 10*WindowXScale, 10*windowScale)
    love.graphics.print("Settings", 10*WindowXScale + (windowWidth/2)*3, 10*windowScale)
    love.graphics.setFont(font)
    love.graphics.print("FPS: ".. tostring(love.timer.getFPS()), 10*WindowXScale + (windowWidth/2)*3, 35*windowScale)
    love.graphics.print("REAL FPS: ".. tostring(1/love.timer.getDelta()), 10*WindowXScale + (windowWidth/2)*3, 60*windowScale)
    love.graphics.print("Average FPS: ".. tostring(1/love.timer.getAverageDelta()), 10*WindowXScale + (windowWidth/2)*3, 85*windowScale)
    love.graphics.print("Total Frames: ".. frames, 10*WindowXScale + (windowWidth/2)*3, 110*windowScale)
    love.graphics.print("You wasted ".. tostring(love.timer.getTime()) .. " seconds of your life.", 10*WindowXScale + (windowWidth/2)*3, 135*windowScale)
    love.graphics.print("Mouse Position: " .. mouseX .. ", " .. mouseY, 10*WindowXScale + (windowWidth/2)*3, 160*windowScale)
    love.graphics.setFont(love.graphics.newFont("assets/fonts/Roboto/Roboto-Bold.ttf", 24*windowScale))
    love.graphics.print("Music Volume", 10*WindowXScale + (windowWidth/2)*3, 200*windowScale)
    love.graphics.print(math.ceil(MusicSlider.value*100) .. "%", 225*WindowXScale + (windowWidth/2)*3, 225*windowScale)
    love.graphics.setFont(font)
    
    -- Draw MusicSlider background
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", MusicSlider.x*WindowXScale, MusicSlider.y*windowScale, MusicSlider.width*WindowXScale, MusicSlider.height*windowScale)
    
    -- Draw MusicSlider handle
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", ((MusicSlider.x + MusicSlider.width * MusicSlider.value) - 5)*WindowXScale, (MusicSlider.y - 5)*windowScale, 10*WindowXScale, (MusicSlider.height + 10)*windowScale)
    cam:detach()
end

function love.mousepressed(x, y, button, istouch, presses)
    cam:attach()
    -- Check if the mouse click is on the MusicSlider handle
    local handleX = (MusicSlider.x + MusicSlider.width * MusicSlider.value)*WindowXScale
    local handleY = (MusicSlider.y - 5)*windowScale
    local handleWidth = 10*WindowXScale
    local handleHeight = (MusicSlider.height + 10)*windowScale

    if x + (CamX - screen_width/2)*WindowXScale >= handleX - handleWidth / 2 and x - (CamX - screen_width/2)*WindowXScale  <= handleX + handleWidth / 2 and
       y >= handleY and y <= handleY + handleHeight then
        MusicSlider.dragging = true
    end
    cam:detach()
end

function love.mousereleased(x, y, button, istouch, presses)
    -- Stop dragging when mouse is released
    MusicSlider.dragging = false
end

function love.keypressed(key)
    if (Screen == "TitleMenu") then
        TestMenu1:keypressed(key)
        if key == 'up' then
            -- sound
        end
    elseif (Screen == "SettingsScreen") then
        TestMenu2:keypressed(key)
    end
    -- Press 'Up' arrow key to increase window scale
    if key == "right" then
        if (TestMenu2.selected == 2) and (Screen == "SettingsScreen") then
            ActualWindowScale = ActualWindowScale + 0.5
            love.window.setMode(screen_width * ActualWindowScale, screen_height * ActualWindowScale, {resizable = true, msaa = 0, highdpi = true})
            cam:move((CamX*ActualWindowScale) - cam.x, (CamY*ActualWindowScale) - cam.y)
        end
    end
    if key == "left" and (ActualWindowScale > 0.5) then
        if (TestMenu2.selected == 2) and (Screen == "SettingsScreen") then
            ActualWindowScale = ActualWindowScale - 0.5
            love.window.setMode(screen_width * ActualWindowScale, screen_height * ActualWindowScale, {resizable = true, msaa = 0, highdpi = true})
            cam:move((CamX*ActualWindowScale) - cam.x, (CamY*ActualWindowScale) - cam.y)
        end
    end
end