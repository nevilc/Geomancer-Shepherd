ExitSprite = love.graphics.newImage(path_gfx .. 'exit' .. ext_gfx)

Exit = class('Exit')
function Exit:initialize(x, y)
	self.x = x
	self.y = y
	
	self.phys_body = love.physics.newBody(phys_world, x, y, 0, 0)
	
	self.phys_shape = love.physics.newRectangleShape(self.phys_body, 0, 0, 32, 32)
	
	self.phys_shape:setSensor(true)
	self.phys_shape:setData({self, 'exit'})
end

function Exit:destroy()
	self.phys_shape:setData(nil)
	self.phys_shape:destroy()
	self.phys_body:destroy()
end

function Exit:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(ExitSprite, self.phys_body:getX(), self.phys_body:getY(), math.random(0, math.pi * 2), 1, 1, 16, 16)
end
