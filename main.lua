function love.load()
	fontcolor = {r=255,g=115,b=46}
end

function love.draw()
	love.graphics.setColor(fontcolor.r+1, fontcolor.g, fontcolor.b ,255)
	love.graphics.print("hello world", 0 ,200)
end

function love.update()
    fontcolor.r = fontcolor.r+1
end