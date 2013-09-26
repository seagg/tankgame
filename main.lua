require('menu')
require('game')
function love.load()
	img_fn = {"tank_title", "player"}
	imgs = {}
	for _,v in ipairs(img_fn) do
		imgs[v] = love.graphics.newImage("assets/"..v..".gif")
	end
	-- Initialize font, and set it.
	font = love.graphics.newFont("assets/font.ttf",5*scale)
	love.graphics.setFont(font)
	-- define colors (global assets)
    bgcolor = {r=190,g=100,b=0}
    fontcolor = {r=100,g=100,b=255}
    state = "menu"
    menu.load()
end

function love.draw()
	love.graphics.setColor(bgcolor.r, bgcolor.g, bgcolor.b)
	--love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    if state == "menu" then
    	menu.draw()
    end
    if state == "game" then
    	game.draw()
    end
    love.graphics.setColor(255, 255, 255)
end

function love.update(dt)
    if state == "menu" then
    	menu.update(dt)
    end
    if state == "game" then
    	game.update(dt)
    end
end

function love.keypressed(key)
	if state == "menu" then
		menu.keypressed(key)
    elseif state == "game" then
        game.keypressed(key)
    end
end