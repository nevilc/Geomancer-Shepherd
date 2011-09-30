Player = class('Player')
function Player:initialize(x, y)
	self.phys_mass = 10
	
	self.phys_body = love.physics.newBody(phys_world, x, y, self.phys_mass, 0)
	self.phys_body:setAllowSleeping(false)
	self.phys_shape = love.physics.newRectangleShape(self.phys_body, 0, 0, 16, 32, 0)
	self.phys_shape:setData({self})
	self.phys_shape_jump = love.physics.newRectangleShape(self.phys_body, 0, 16 + 3, 16, 6, 0)
	self.phys_shape_jump:setSensor(true)
	self.phys_shape_jump:setData({self, 'jump'})
	
	self.phys_shape:setDensity(10)
	self.phys_body:setMassFromShapes()
	
	self._sprite = love.graphics.newImage(path_gfx .. 'player_idle' .. ext_gfx)
end

function Player:destroy()
	self.phys_shape:setData(nil)
	self.phys_shape_jump:setData(nil)
	self.phys_shape:destroy()
	self.phys_shape_jump:destroy()
	self.phys_body:destroy()
end

function Player:step(dt)
	if self.phys_body:getAngle() > math.pi * 0.07 and self.phys_body:getAngle() < math.pi * 1.0 then
		self.phys_body:setAngle(math.pi * 0.07)
		self.phys_body:setAngularVelocity(0)
	elseif self.phys_body:getAngle() < math.pi * -0.07 then
		self.phys_body:setAngle(math.pi * -0.07)
		self.phys_body:setAngularVelocity(0)
	end
	if self.phys_body:getX() < 0 then
		self.phys_body:setX(0)
	elseif self.phys_body:getX() >= 960 then
		self.phys_body:setX(959)
	end
	if self.phys_body:getY() < 0 then
		self.phys_body:setY(0)
	elseif self.phys_body:getY() > 540 then
		self.phys_body:setY(539)
	end
end

function Player:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self._sprite, self.phys_body:getX(), self.phys_body:getY(), self.phys_body:getAngle(), 1, 1, 16, 16)
	
	--love.graphics.setColor(255,0,0)
	--local x1, y1, x2, y2, x3, y3, x4, y4 = self.phys_shape:getBoundingBox()
	--love.graphics.rectangle('line', x2, y2, x4 - x2, y4 - y2)
	
	love.graphics.setColor(0,255,0)
	--love.graphics.point(self.phys_body:getPosition())
	
	--local x1, y1, x2, y2, x3, y3, x4, y4 = self.phys_shape_jump:getPoints()
	--love.graphics.line(x1, y1, x2, y2, x3, y3, x4, y4, x1, y1)
	
	--local bx, by, sx, sy = player.phys_body:getX() + 17*math.cos(math.pi/2 + player.phys_body:getAngle()), player.phys_body:getY() + 17*math.sin(math.pi/2 + player.phys_body:getAngle()), 8*math.cos(math.pi + player.phys_body:getAngle()), 8*math.sin(math.pi + player.phys_body:getAngle())
	--love.graphics.line(bx + sx, by + sy, bx - sx, by - sy)
	
	--local width = Font:getWidth(math.floor(love.timer.getMicroTime() - starttime))
	love.graphics.setColor(255,0,0)
	love.graphics.printf(math.floor((love.timer.getMicroTime() - starttime)/60) .. ':' .. math.floor((love.timer.getMicroTime() - starttime)/10)%6 .. math.floor(love.timer.getMicroTime() - starttime)%10, 960 + 8, -40, 0, 'right')
	love.graphics.printf(score, 0, -40, 0, 'left')
end
	