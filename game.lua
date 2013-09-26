game = {}
direction = {
  up = 270;
  down = 90;
  right = 0;
  left = 180;
}
function game.load()
	game.player = {}
	game.player.size = imgs["player"]:getWidth()
    game.player.x = love.graphics.getWidth() / 2 - game.player.size / 2
    game.player.y = love.graphics.getHeight() / 2 - game.player.size / 2
    game.player.direction = "left"
    game.player.bullets = {}
end

function game.draw()
	love.graphics.draw(imgs["player"], game.player.x, game.player.y, math.rad(direction[game.player.direction]),
	    1, 1 , game.player.size/2,game.player.size/2)	
    for bi,bv in ipairs(game.player.bullets) do
    	love.graphics.setColor(80, 80, 80)
		love.graphics.circle("fill", bv.x, bv.y, 2)
    end
end

function game.update(dt)
	if love.keyboard.isDown("right") then
		game.player.direction = "right"
		game.player.x = game.player.x + 50*dt*scale
	end
	if love.keyboard.isDown("left") then
		game.player.direction = "left"
		game.player.x = game.player.x - 50*dt*scale
	end
	if love.keyboard.isDown("up") then
		game.player.direction = "up"
		game.player.y = game.player.y - 50*dt*scale
	end
	if love.keyboard.isDown("down") then
		game.player.direction = "down"
		game.player.y = game.player.y + 50*dt*scale
	end

	for bi,bv in ipairs(game.player.bullets) do
		if bv.direction == "up" then
            bv.y = bv.y - 100*dt*scale
        elseif bv.direction == "down" then
        	bv.y = bv.y + 100*dt*scale
        elseif bv.direction == "right" then
        	bv.x = bv.x + 100*dt*scale
        elseif bv.direction == "left" then
        	bv.x = bv.x - 100*dt*scale
        end
        if bv.x<0 or bv.x>love.graphics.getWidth() or bv.y<0 or bv.y>love.graphics.getHeight() then
        	table.remove(game.player.bullets, bi)
        end
    end
end

function game.keypressed(key)
	if key == " " then
		local bullet = {}
		bullet.x = game.player.x
		bullet.y = game.player.y
		bullet.direction = game.player.direction
		table.insert(game.player.bullets, bullet)
	end
end