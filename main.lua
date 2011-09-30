require 'MiddleClass'

require 'path'
require 'misc'

require 'class.surface'
require 'class.player'
require 'class.boulder'
require 'class.sheep'
require 'class.pen'
require 'class.star'
require 'class.magma'
require 'class.exit'

require 'forces'



function changelevel(doscore)
	
	
	if doscore == true then
		score = score + 50 * pensheep
		totaltime = totaltime + love.timer.getMicroTime() - starttime
		currentlevel = currentlevel + 1
		totalscore = totalscore + score
	end
	
	pensheep = 0
	
	if player then
		table.insert(garbage, player)
		player = nil
	end
	
	if xit then
		table.insert(garbage, xit)
		xit = nil
	end
	
	if surfaces then
		table.append(garbage, surfaces)
	end
	surfaces = {}
	
	if boulders then
		table.append(garbage, boulders)
	end
	boulders = {}
	
	if sheeps then
		table.append(garbage, sheeps)
	end
	sheeps = {}
	
	if stars then
		table.append(garbage, stars)
	end
	stars = {}
	
	if magmas then
		table.append(garbage, magmas)
	end
	magmas = {}
	
	if phys_world then
		--phys_world:destroy()
	end
	
	
	
	if currentlevel > #levels then
		return
	end
	
	local buffer = 64
	local height = 540
	local width = 960
	local meter = 16

	phys_world = love.physics.newWorld(-width, -height, width * 2, height * 2)
	phys_world:setMeter(16)
	phys_world:setGravity(0, 400)
	phys_world:setCallbacks(addCallback, persistCallback, nil, nil)
	
	--print(levels[currentlevel])
	local chunk = love.filesystem.load(levels[currentlevel])
	chunk()
	
	starttime = love.timer.getMicroTime()
	score = 0
	magmadelta = 10
	magmatime = 0
end
	
function addCallback(a, b, contact)
	if a == nil or b == nil then
		return
	end

	if a[1].class.name == 'Player' and a[2] == nil then
		if b[1].class.name == 'Star' then
			score = score + 10
			table.removevalue(stars, b[1])
			table.insert(garbage, b[1])
			return
		end
		if b[1].class.name == 'Magma' then
			changelevel(false)
		end
		if b[1].class.name == 'Exit' then
			changelevel(true)
		end
	end
	if b[1].class.name == 'Player' and b[2] == nil then
		if a[1].class.name == 'Star' then
			score = score + 10
			table.removevalue(stars, a[1])
			table.insert(garbage, a[1])
			return
		end
		if a[1].class.name == 'Magma' then
			changelevel(false)
		end
		if a[1].class.name == 'Exit' then
			changelevel(true)
		end
	end
	
end

function persistCallback(a, b, contact)
	if a == nil or b == nil then
		return
	end
	if a[2] == 'jump' then
		if b[2] == nil then
			canjump = true
		end
	elseif b[2] == 'jump' then
		if a[2] == nil then
			canjump = true
		end
	end
	
	if a[1].class.name == 'Sheep' then
		if b[2] == 'pen' then
			psbuf = psbuf + 1
		end
	end
	if b[1].class.name == 'Sheep' then
		if a[2] == 'pen' then
			psbuf = psbuf + 1
		end
	end
	
end

function love.load()
	garbage = {}

	currentlevel = 1
	--levels = {'export/3.lua'}
	levels = {'export/14.lua', 'export/11.lua'}
	totaltime = 0
	totalscore = 0

	--font = love.graphics.newFont(path_font .. 'DaysOne-Regular' .. ext_font, 32)
	font = love.graphics.newFont(path_font .. 'DroidSansMono' .. ext_font, 32)
	love.graphics.setFont(font)
	
	editmode = false

	score = 0
	
	
	
	--stupid physics crash, stupid workaround
	--[[dummy = {	Star:new(9999, 9999),
				Magma:new(9999, 9999),
				Boulder:new(9999, 9999)}]]
	
	pensheep = 0
	canjump = false
	
	--starttime = love.timer.getMicroTime()
	
	hack = true
	
	changelevel(false)
end

function love.update(dt)
	

	if currentlevel <= #levels then

		magmatime = magmatime + love.timer.getDelta()
		if magmatime >= magmadelta then
			local x, y = math.random(32, 960 - 32), math.random(32, 540 - 32)
			local ok = true
			for _, s in ipairs(surfaces) do
				for _, t in ipairs(s.phys_shapes) do
					if t:testPoint(x, y) then
						ok = false
						break
					end
				end
				if ok == false then
					break
				end
			end
			
			if ok and not editmode then
				table.insert(magmas, Magma:new(x, y))
			end
			
			magmatime = magmatime - magmadelta
			magmadelta = math.max(1, magmadelta - 0.5)
		end
	
		if love.keyboard.isDown('a') then
			
			if canjump then 
				player.phys_body:applyForce(-400, -200)
			else
				player.phys_body:applyForce(-150, 0)
			end
		end
		if love.keyboard.isDown('d') then
			
			if canjump then 
				player.phys_body:applyForce(400, -200)
			else
				player.phys_body:applyForce(150, 0)
			end
		end
		if love.keyboard.isDown('w') then
			if canjump then
				--player.phys_body:applyImpulse(0, -400, player.phys_body:getX(), player.phys_body:getY())
				player.phys_body:setLinearVelocity((player.phys_body:getLinearVelocity()), -200)
			else
				local _, y = player.phys_body:getLinearVelocity()
				if (y < 0) then
					player.phys_body:applyForce(0, y * .2)
				end
			end
		end
		
		local dist = distance(Node:new(love.mouse.getPosition()), Node:new(player.phys_body:getPosition()))
		local power = math.max(0, 512 - dist) / 512
		local radius = 64 * power
		
		if love.mouse.isDown('l') then
			for i, s in ipairs(surfaces) do
				--s:applyforce(directed, Node:new(player.phys_body:getPosition()), 96, 32*dt, math.pi * 1.5)
				s:applyforce(invr, Node:new(love.mouse.getPosition()), radius, 64 * power * dt)
			end
		end
		
		if love.mouse.isDown('r') then
			for i, s in ipairs(surfaces) do
				--s:applyforce(directed, Node:new(player.phys_body:getPosition()), 96, 32*dt, math.pi * 0.5)
				s:applyforce(invr, Node:new(love.mouse.getPosition()), radius, -64 * power * dt)
			end
		end
		
		player:step()
		
		canjump = false
		psbuf = 0
		phys_world:update(dt)
		pensheep = psbuf
		if player then
			player:step()
		end
	end
	
	for _, g in ipairs(garbage) do
		g:destroy()
	end
	garbage = {}
	
	if hack then
		hack = nil
		changelevel(false)
	end
end

function love.draw()
	love.graphics.setBackgroundColor(50, 100, 255)
	
	if currentlevel <= #levels then
		for i, o in ipairs(surfaces) do
			o:draw()
		end
		for i, o in ipairs(boulders) do
			o:draw()
		end
		for i, o in ipairs(sheeps) do
			o:draw()
		end
		
		for i, o in ipairs(stars) do
			o:draw()
		end
		
		for i, o in ipairs(magmas) do
			o:draw()
		end
		
		xit:draw()
		
		player:draw()
		
		for i, o in ipairs(pens) do
			o:draw()
		end
		
		local dist = distance(Node:new(love.mouse.getPosition()), Node:new(player.phys_body:getPosition()))
		local power = math.max(0, 512 - dist) / 512
		local radius = 64 * power
		
		love.graphics.setColor(0, 255, 0)
		local mx, my = love.mouse.getPosition()
		love.graphics.circle('line', mx, my, 2, 4)
		love.graphics.circle('line', mx, my, radius, 16)
	else
		love.graphics.setColor(0,0,0)
		love.graphics.printf('Final Time: ' .. math.floor(totaltime) .. ' seconds\nFinal Score: ' .. totalscore .. '\nThanks for playing! (Close and reopen to restart)', 0, 64, 960, 'center')
	end
end

function love.keypressed(key, unicode)
	if key == 'f12' then
		table.insert(surfaces, Surface:new())
		editmode = not editmode
	elseif key == 'f11' then
		if editmode then
			--export to file
			local num = 0
			local str = "local fixies, surf\n"
			for i, surf in ipairs(surfaces) do
				local fixies = {}
				str = str .. 'surf = Surface:new('
				for j, node in ipairs(surf.nodes) do
					str = str .. node.x .. ', ' .. node.y .. ', '
					if node.fixed then
						table.insert(fixies, j)
					end
				end
				-- chop last comma
				str = str:sub(1, str:len() - 2) .. ')\n'
					.. 'table.insert(surfaces, surf)\n'
				
				if #fixies > 0 then
					str = str .. 'fixies = {'
					for j, num in ipairs(fixies) do
						str = str .. num .. ', '
					end
					str = str:sub(1, str:len() - 2) .. '}\n'
					str = str .. 'for i, num in ipairs(fixies) do\n'
					str = str .. '\tsurf.nodes[num].fixed = true\n'
					str = str .. 'end\n'
				end
			end
			
			
			
			if not love.filesystem.exists('export') then
				love.filesystem.mkdir('export')
			end
			while love.filesystem.exists('export/' .. num .. '.lua') do
				num = num + 1
			end
			love.filesystem.write('export/' .. num .. '.lua', str)
		end
	end
end

function love.mousepressed(x, y, button)
	if button == 'l' then
		if editmode then
			if #surfaces == 0 then
				table.insert(surfaces, Surface:new())
			end
			surfaces[#surfaces]:insert(x, y)
			if love.keyboard.isDown('lshift') then
				surfaces[#surfaces].nodes[#surfaces[#surfaces].nodes].fixed = true
			end
		end
	elseif button == 'r' then
		if editmode then
			table.insert(surfaces, Surface:new())
		end
	elseif button == 'm' then
		if editmode then
			table.insert(sheeps, Sheep:new(x, y))
		end
	elseif button == 'wu' then
		if editmode then
			player.phys_body:wakeUp()
			for i, s in ipairs(surfaces) do
				s:applyforce(inv, Node:new(x, y), 900, 1.3)
			end
		end
	elseif button == 'wd' then
		if editmode then
			print(x .. ', ' .. y)
		end
	elseif button == 'x1' then
		if editmode then
			surfaces = {Surface:new()}
		end
	elseif button == 'x2' then
		if editmode then
			player.phys_body:wakeUp()
			player.phys_body:setPosition(x, y)
		end
	end
end
