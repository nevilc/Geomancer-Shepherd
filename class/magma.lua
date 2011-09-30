MagmaSprite = love.graphics.newImage(path_gfx .. 'magma' .. ext_gfx)

Magma = class('Magma')
function Magma:initialize(x, y)
	self.phys_body = love.physics.newBody(phys_world, x, y, 0, 0)
	self.phys_shape = love.physics.newCircleShape(self.phys_body, 0, 0, 16)
	self.phys_shape:setData({self})
	
	self.phys_shape:setDensity(20)
	self.phys_body:setMassFromShapes()
end

function Magma:destroy()
	self.phys_shape:setData(nil)
	self.phys_shape:destroy()
	self.phys_body:destroy()
end

function Magma:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(MagmaSprite, self.phys_body:getX(), self.phys_body:getY(), self.phys_body:getAngle(), 1, 1, 16, 16)
end