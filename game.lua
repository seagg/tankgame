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
    game.player.moving = false
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
    game.move(game.player, 50, dt)
	for bi,bv in ipairs(game.player.bullets) do
        bv.moving = true
        game.move(bv, 100, dt)
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
		
	if key == "up" then
		game.player.direction = "up"
	elseif key == "down" then
		game.player.direction = "down"
	elseif key == "left" then
		game.player.direction = "left"
	elseif key == "right" then
		game.player.direction = "right"
	end

	if key == "up" or key == "down" or key == "left" or key == "right" then
		game.player.moving = true
	end

end

function game.keyreleased(key)
	if key == "escape" then
        love.event.push("quit")   -- actually causes the app to quit
    end
    game.player.moving = false
end

function game.move(obj, speed, dt)
	if obj.moving == true then
		if obj.direction == "up" then
			obj.y = obj.y - speed*dt*scale
		elseif obj.direction == "down" then
			obj.y = obj.y + speed*dt*scale
		elseif obj.direction == "right" then
			obj.x = obj.x + speed*dt*scale
		elseif obj.direction == "left" then
			obj.x = obj.x - speed*dt*scale
		end
	end
end