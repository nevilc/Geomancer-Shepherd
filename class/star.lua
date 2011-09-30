StarSprite = love.graphics.newImage(path_gfx .. 'star' .. ext_gfx)

Star = class('Star')
function Star:initialize(x, y)
	self.phys_body = love.physics.newBody(phys_world, x, y, 0, 0)
	self.phys_shape = love.physics.newCircleShape(self.phys_body, 0, 0, 7)
	self.phys_shape:setData({self, 'star'})
	self.phys_shape:setSensor(true)
end

function Star:destroy()
	self.phys_shape:setData(nil)
	self.phys_shape:destroy()
	self.phys_body:destroy()
end

function Star:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(StarSprite, self.phys_body:getX(), self.phys_body:getY(), 0, 1, 1, 8, 8)
end