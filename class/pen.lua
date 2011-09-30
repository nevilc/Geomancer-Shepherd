PenLeftSprite = love.graphics.newImage(path_gfx .. 'pen_left' .. ext_gfx)
PenRightSprite = love.graphics.newImage(path_gfx .. 'pen_right' .. ext_gfx)
PenUpSprite = love.graphics.newImage(path_gfx .. 'pen_up' .. ext_gfx)
PenDownSprite = love.graphics.newImage(path_gfx .. 'pen_down' .. ext_gfx)
PenHorizontalSprite = love.graphics.newImage(path_gfx .. 'pen_horizontal' .. ext_gfx)
PenVerticalSprite = love.graphics.newImage(path_gfx .. 'pen_vertical' .. ext_gfx)

Pen = class('Pen')
function Pen:initialize(x, y, w, h, horiz)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.horiz = horiz
	if horiz == nil then
		self.horiz = true
	end
	
	self.phys_body = love.physics.newBody(phys_world, x, y, 0, 0)
	
	if self.horiz then
		self.phys_shape1 = love.physics.newRectangleShape(self.phys_body, 2, h / 2, 4, h)
		self.phys_shapepen = love.physics.newRectangleShape(self.phys_body, w / 2, h / 2, w - 8, h)
		self.phys_shape2 = love.physics.newRectangleShape(self.phys_body, w + 2, h / 2, 4, h)
	else
		self.phys_shape1 = love.physics.newRectangleShape(self.phys_body, w / 2, 2, w, 4)
		self.phys_shapepen = love.physics.newRectangleShape(self.phys_body, w / 2, h / 2, w, h - 8)
		self.phys_shape2 = love.physics.newRectangleShape(self.phys_body, w / 2, h - 2, w, 4)
	end
	
	self.phys_shape1:setData({self})
	self.phys_shape2:setData({self})
	
	self.phys_shapepen:setSensor(true)
	self.phys_shapepen:setData({self, 'pen'})
end

function Pen:destroy()
	self.phys_shape1:setData(nil)
	self.phys_shape2:setData(nil)
	self.phys_shapepen:setData(nil)
	self.phys_shape1:destroy()
	self.phys_shape2:destroy()
	self.phys_shapepen:destroy()
	self.phys_body:destroy()
end

function Pen:inside(target)
	if type(target) ~= 'table' then
		target = {target}
	end
	local count = 0
	for i, o in ipairs(target) do
		if o.phys_body:getX() >= self.x and o.phys_body:getX() < self.x + self.w and
			o.phys_body:getY() >= self.y and o.phys_body:getY() < self.y + self.h then
				count = count + 1
		end
	end
	return count
end

function Pen:draw()
	love.graphics.setColor(255, 255, 255)
	if self.horiz then
		draw_tiled(PenLeftSprite, self.x, self.y, 1, 1, 0, 0, 8, self.h)
		draw_tiled(PenHorizontalSprite, self.x + 8, self.y, 1, 1, 0, 0, self.w - 16, self.h)
		draw_tiled(PenRightSprite, self.x + self.w - 8, self.y, 1, 1, 0, 0, 8, self.h)
	else
		draw_tiled(PenUpSprite, self.x, self.y, 1, 1, 0, 0, self.w, 8)
		draw_tiled(PenVerticalSprite, self.x, self.y + 8, 1, 1, 0, 0, self.w, self.h - 16)
		draw_tiled(PenDownSprite, self.x, self.y + self.h - 8, 1, 1, 0, 0, self.w, 8)
	end
end
