local utf8 = require("utf8") --leftover from ytp+ studio, is this needed?
local Audio = require("common/audio") --audio/sound related data
local GFX = require("common/gfx") --images and other graphical data
local Enums = require("common/enums") --static enumerables
local Data = require("common/data") --save data
local Func = require("common/func") --commonly used functions
local GameVars = require("common/gamevars") --gameplay variables
local Scenes = require("common/scenes") --gameplay environments

function love.load()
	--initialize
	love.audio.setVolume(Data.Volume)
	if GFX.Cursor then
		love.mouse.setCursor(GFX.Cursor)
	end
	Func.ScreenCfg(Data)
	Func.Save()
	--temp
	Scenes[GameVars.ActiveScene].LoadScene()
end

function love.draw(screen)
	love.graphics.clear() --prepare for drawing
	love.graphics.setColor(1,1,1,1) --opaque white

	--TOP SCREEN--
	if not screen then love.graphics.setCanvas(GameVars.TopCanvas) end
	if screen ~= "bottom" or not screen then Scenes[GameVars.ActiveScene].DrawSceneTop() end

	--BOTTOM SCREEN--
	if not screen then love.graphics.setCanvas(GameVars.BottomCanvas) end
	if screen == "bottom" or not screen then Scenes[GameVars.ActiveScene].DrawSceneBottom() end

	if not love._console_name then --RESET TO MAIN SCREEN--
		love.graphics.setCanvas()
		love.graphics.setColor(1,1,1,1) --opaque white
		--this should be done with variables instead - temporary solution
		if Data.Orientation == Enums.OriHorizontal then
			love.graphics.draw(GameVars.TopCanvas, 0, 0, 0, Data.Scaling, Data.Scaling)
			love.graphics.draw(GameVars.BottomCanvas, (Enums.Width)*Data.Scaling, 0, 0, Data.Scaling, Data.Scaling)
		elseif Data.Orientation == Enums.OriVerticalInverted then
			love.graphics.draw(GameVars.TopCanvas, 0, (Enums.Height/2)*Data.Scaling, 0, Data.Scaling, Data.Scaling)
			love.graphics.draw(GameVars.BottomCanvas, 0, 0, 0, Data.Scaling, Data.Scaling)
		elseif Data.Orientation == Enums.OriHorizontalInverted then
			love.graphics.draw(GameVars.TopCanvas, (Enums.Width)*Data.Scaling, 0, 0, Data.Scaling, Data.Scaling)
			love.graphics.draw(GameVars.BottomCanvas, 0, 0, 0, Data.Scaling, Data.Scaling)
		else --default
			love.graphics.draw(GameVars.TopCanvas, 0, 0, 0, Data.Scaling, Data.Scaling)
			love.graphics.draw(GameVars.BottomCanvas, 0, (Enums.Height/2)*Data.Scaling, 0, Data.Scaling, Data.Scaling)
		end
	end
end

--below are unused for now but will be useful in the future--

function love.update(dt)
	Scenes[GameVars.ActiveScene].UpdateScene(dt)
end

function love.mousepressed(x, y, button, istouch, presses)
	x = x/Data.Scaling --scale up mouse positions
	y = y/Data.Scaling
	--is there an easier way to do this?--
	if Data.Orientation == Enums.OriHorizontal then
		if x > Enums.Width then
			x = x - Enums.Width
		end
	elseif Data.Orientation == Enums.OriVerticalInverted then
		if y > Enums.Height/2 then
			y = y - Enums.Height/2
		end
	elseif Data.Orientation == Enums.OriHorizontalInverted then
		if x > Enums.Width then
			x = x - Enums.Width
		end
	end
	--wrap around
	if y < Enums.Height/2 then
		Scenes[GameVars.ActiveScene].MousePressedTopScene(x, y, button, istouch, presses)
	else
		y = y-Enums.Height/2
		-- y = y - Data.ScreenGap
		Scenes[GameVars.ActiveScene].MousePressedBottomScene(x, y, button, istouch, presses)
	end
end

function love.wheelmoved(x, y)
	Scenes[GameVars.ActiveScene].WheelMovedScene(x, y)
end

function love.keypressed(k)
	Scenes[GameVars.ActiveScene].KeyPressedScene()
end

function love.textinput(text)
	Scenes[GameVars.ActiveScene].TextInputScene()
end
