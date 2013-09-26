menu = {}
function menu.load()
    menu.dt_temp = 0
end

function menu.draw() 
    love.graphics.draw(imgs["tank_title"], 180, (menu.dt_temp-1)*20*scale, 0, 1, 1)
    love.graphics.setColor(fontcolor.r, fontcolor.g, fontcolor.b)
    if menu.dt_temp == 2.0 then
	    love.graphics.printf("Press Start",
	        0,80*scale,love.graphics.getWidth(),"center")
	end
end

function menu.update(dt)
	menu.dt_temp = menu.dt_temp + dt
	if menu.dt_temp > 2.0 then
		menu.dt_temp = 2.0
    end
end