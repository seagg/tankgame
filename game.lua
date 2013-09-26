game = {}
direction = {
  up = 270;
  down = 90;
  right = 0;
  left = 180;
}
function game.load()
	game.player_size = imgs["player"]:getWidth()
    game.playerx = love.graphics.getWidth() / 2 - game.player_size / 2
    game.playery = love.graphics.getHeight() / 2 - game.player_size / 2
    game.player_direction = "left"
end

function game.draw()
	love.graphics.draw(imgs["player"], game.playerx, game.playery, math.rad(direction[game.player_direction]),
	    1, 1 , game.player_size/2,game.player_size/2)	

end

function game.update(dt)
	if love.keyboard.isDown("right") then
		game.player_direction = "right"
		game.playerx = game.playerx + 50*dt*scale
	end
	if love.keyboard.isDown("left") then
		game.player_direction = "left"
		game.playerx = game.playerx - 50*dt*scale
	end
	if love.keyboard.isDown("up") then
		game.player_direction = "up"
		game.playery = game.playery - 50*dt*scale
	end
	if love.keyboard.isDown("down") then
		game.player_direction = "down"
		game.playery = game.playery + 50*dt*scale
	end
end

function game.keypressed(key)
	if key == " " then
		
	end
end