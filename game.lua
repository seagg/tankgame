game = {}
direction = {
  up = 90;
  down = 270;
  right = 180;
  left = 0;
}

function game.load()
	game.player = {}
	game.player.size = imgs["player"]:getWidth()
    game.player.x = love.graphics.getWidth() / 2 
    game.player.y = love.graphics.getHeight() - game.player.size / 2
    game.player.direction = "left"
    game.player.moving = false
    game.player.bullets = {}
    
    game.enemy_size = imgs["enemy"]:getWidth()
    game.enemy_interval = 3
    game.enemy_where = 1
    game.enemy_where_x = {0, love.graphics.getWidth()/2-game.enemy_size/2, love.graphics.getWidth()-game.enemy_size}
    game.enemies = {}

    game.direction = {"up", "down", "right", "left"}
    game.map = {}
    --load map
    for i = 1, map_w do
    	for j = 1, map_h do
            if map[i][j] == 1 then
                local _obs = {}
                _obs.y = (i-1)*imgs["brick"]:getWidth()+imgs["brick"]:getWidth()/2
                _obs.x = (j-1)*imgs["brick"]:getWidth()+imgs["brick"]:getWidth()/2
                _obs.size = imgs["brick"]:getWidth()
                table.insert(game.map, _obs)
            end
        end
    end
end

function game.draw()
	--draw player
	love.graphics.draw(imgs["player"], game.player.x, game.player.y, math.rad(direction[game.player.direction]),
	    1, 1 , game.player.size/2,game.player.size/2)	
	love.graphics.setColor(bulletcolor.r, bulletcolor.g, bulletcolor.b)

	--draw player's bullet
    for bi,bv in ipairs(game.player.bullets) do
		love.graphics.circle("fill", bv.x, bv.y, 2)
    end
    love.graphics.setColor(bgcolor.r, bgcolor.g, bgcolor.b)

    --draw enemy and their bullets
    for _, ev in ipairs(game.enemies) do
    	love.graphics.draw(imgs['enemy'], ev.x, ev.y, math.rad(direction[ev.direction]), 1, 1 , game.enemy_size/2,game.enemy_size/2)
        for _, bv in ipairs(ev.bullets) do
            love.graphics.circle("fill", bv.x, bv.y, 2)
        end	
    end

    for mi, mv in ipairs(game.map) do
    	love.graphics.draw(imgs["brick"], mv.x, mv.y, 0, 1, 1, imgs["brick"]:getWidth()/2, imgs["brick"]:getHeight()/2)
    end
    love.graphics.setColor(255, 255, 255)
end

function game.update(dt)
	--player part
    game.move(game.player, 50, dt)
    game.outline(game.player)
	if game.player.out == true then
    	game.moveback(game.player, 50, dt)
    	game.player.out = false
    end
    for _, v in ipairs(game.enemies) do
        if game.isCross(game.player, v) then
        	game.moveback(game.player, 50, dt)
        end
    end


	for bi,bv in ipairs(game.player.bullets) do
        bv.moving = true
        game.move(bv, 100, dt)
        for ei, ev in ipairs(game.enemies) do
            if game.dist(bv.x, bv.y, ev.x, ev.y) < (2 + game.enemy_size/2) then
            	table.remove(game.enemies, ei)
            	table.remove(game.player.bullets, bi)
            end
        end
        game.outline(bv)
        if bv.out == true then
        	table.remove(game.player.bullets, bi)
        end
    end

    --enemy part
    game.enemy_interval = game.enemy_interval - dt
    if game.enemy_interval < 0 then
        game.add_enemy()
        game.enemy_interval = 3
    end
    for ei, ev in ipairs(game.enemies) do
    	ev.time = ev.time - dt
    	--enemy's new direction
    	if ev.time < 0 then
    		ev.time = math.random(0.5, 3)
    		ev.direction = game.direction[math.floor(math.random(1.01, 4.99))]
    	end

    	game.move(ev, 20, dt)
    	game.outline(ev)
    	if ev.out == true then
    		game.moveback(ev, 20, dt)
    		ev.direction = game.direction[math.floor(math.random(1.01, 4.99))]
    		ev.out = false
    	elseif game.isCross(ev, game.player) then
    		game.moveback(ev, 20, dt)
    		ev.direction = game.direction[math.floor(math.random(1.01, 4.99))]
    	end
        
        --enemy's new bullet
        ev.shoot_interval = ev.shoot_interval - dt
        if ev.shoot_interval < 0 then
        	ev.shoot_interval = math.random(1, 3)
        	local _bullet = {}
			_bullet.x = ev.x
			_bullet.y = ev.y
			_bullet.size = 2
			_bullet.out = false
			_bullet.direction = ev.direction
			table.insert(ev.bullets, _bullet)
		end

        --enemy bullet move
		for _, bv in ipairs(ev.bullets) do
            bv.moving = true
            game.move(bv, 100, dt)
            --game over
            if game.dist(bv.x, bv.y, game.player.x, game.player.y) < 1 + game.player.size/2 then
                state = "menu"
    			menu.load()
    		end
            game.outline(bv)
    		if bv.out == true then
    			table.remove(ev.bullets, bi)
    		end
		end
    end
end

function game.keypressed(key)
	--发射子弹
	if key == " " then
		local bullet = {}
		bullet.x = game.player.x
		bullet.y = game.player.y
		bullet.out = false
		bullet.size = 2
		bullet.direction = game.player.direction
		table.insert(game.player.bullets, bullet)
	end
		
	--改变己方移动方向
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

    if key ~= " " then
        game.player.moving = false
    end
end

--根据方向和速度移动物体
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

function game.moveback(obj, speed, dt)
	if obj.direction == "up" then
		obj.y = obj.y + speed*dt*scale
	elseif obj.direction == "down" then
		obj.y = obj.y - speed*dt*scale
	elseif obj.direction == "right" then
		obj.x = obj.x - speed*dt*scale
	elseif obj.direction == "left" then
		obj.x = obj.x + speed*dt*scale
	end
end

--用于判断物体是否跑出画面外
function game.outline(obj)
	obj.out = true
	if obj.x < obj.size/2 then
    	obj.x = obj.size/2
    elseif obj.y<obj.size/2 then
    	obj.y=obj.size/2
    elseif obj.x>love.graphics.getWidth()-obj.size/2 then
    	obj.x = love.graphics.getWidth()-obj.size/2
    elseif obj.y>love.graphics.getHeight()-obj.size/2 then
    	obj.y = love.graphics.getHeight()-obj.size/2
    else
    	obj.out = false
    end

    for i, v in ipairs(game.map) do 
        if game.isCross(obj, v) == true then
        	obj.out = true
        end
    end
end

function game.add_enemy()
    local _enemy = {}
    _enemy.direction = "down"
    _enemy.x = game.enemy_where_x[game.enemy_where] + game.enemy_size/2
    _enemy.y = game.enemy_size/2
    _enemy.time = math.random(1,3)
    _enemy.moving = true
    _enemy.shoot_interval = math.random(1, 3)
    _enemy.out = false
    _enemy.size = imgs["enemy"]:getWidth()
    _enemy.bullets = {}
    game.enemy_where = game.enemy_where + 1
    if game.enemy_where > 3 then
    	game.enemy_where = game.enemy_where -3
    end
    table.insert(game.enemies,_enemy)
end

-- Distance formula.
function game.dist(x1,y1,x2,y2)
    return math.sqrt( (x1 - x2)^2 + (y1 - y2)^2 )
end

function game.isCross(obj1, obj2)
	local minx = math.max(obj1.x-obj1.size/2, obj2.x-obj2.size/2)
	local miny = math.max(obj1.y-obj1.size/2, obj2.y-obj2.size/2)
	local maxx = math.min(obj1.x+obj1.size/2, obj2.x+obj2.size/2)
	local maxy = math.min(obj1.y+obj1.size/2, obj2.y+obj2.size/2)
	if minx > maxx or miny > maxy then
		return false
	else 
		return true
	end
end