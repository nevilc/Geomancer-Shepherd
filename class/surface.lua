Node = class('Node')
function Node:initialize(x, y, fixed)
	self.x = x or 0
	self.y = y or 0
	self.fixed = fixed or false
end

Surface = class('Surface')
function Surface:initialize(...)
	self.phys_body = love.physics.newBody(phys_world, 0, 0, 0, 0)
	self.phys_shapes = {}

	self.resistance = 0
	self.nodes = {}
	local temp = nil
	for i, coord in ipairs({...}) do
		if (temp == nil) then
			temp = coord
		else
			table.insert(self.nodes, Node:new(temp, coord))
			temp = nil
		end
	end
	self._polycache = nil
end

function Surface:destroy()
	for i, shape in ipairs(self.phys_shapes) do
		shape:setData(nil)
		shape:destroy()
	end
	self.phys_body:destroy()
	
end

function Surface:applyforce(func, ...)
	local changed = false
	for i, node in ipairs(self.nodes) do
		if not node.fixed and func(node, ...) then
			changed = true
		end
	end
	if changed then
		self._polycache = nil
	end
end

function Surface:insert(x, y)
	table.insert(self.nodes, Node:new(x, y))
	self._polycache = nil
end

function Surface:divide(pos)
	local avg_x = (self.nodes[pos].x + self.nodes[pos + 1].x) / 2
	local avg_y = (self.nodes[pos].y + self.nodes[pos + 1].y) / 2
	table.insert(self.nodes, pos, Node:new(avg_x, avg_y))
	
	self._polycache = nil
end

function Surface:_triangulate(anodes)
	local nodes = {}
	for i, n in ipairs(anodes) do
		table.insert(nodes, n)
	end
	
	local critpoints = {nodes[1]}
	local triangles = {}
	
	local a = nil
	local b = nil
	
	for i, c in ipairs(nodes) do
		if (a == nil) then
			a = c
		elseif (b == nil) then
			b = c
		else
			local deltay = c.y - ((b.y - a.y)/(b.x - a.x)*(c.x - a.x) + a.y)
			if deltay == 0 then
				b = c
			elseif ((b.x - a.x > 0) and (deltay < 0)) or ((b.x - a.x < 0) and (deltay > 0)) then
				table.insert(critpoints, b)
				
				a = b
				b = c
			else
				table.insert(triangles, {a.x, a.y, b.x, b.y, c.x, c.y})
				b = c
			end
		end
	end
	table.insert(critpoints, nodes[#nodes])
	
	--test
	if #critpoints == #nodes then 
		critpoints = {}
	end
	
	return triangles, critpoints
end

function Surface:_divide()
	self._polycache = {}
	for i, shape in ipairs(self.phys_shapes) do
		shape:destroy()
	end
	self.phys_shapes = {}
	
	local nodes = self.nodes
	while #nodes >= 3 do
		local tris
		tris, nodes = self:_triangulate(nodes)
		for i, tri in ipairs(tris) do
			table.insert(self._polycache, tri)
			local t = love.physics.newPolygonShape(self.phys_body, unpack(tri))
			t:setData({self})
			table.insert(self.phys_shapes, t)
		end
	end
end

function Surface:clear()
	self.nodes = {}
	self._polycache = nil
	for i, shape in ipairs(self.phys_shapes) do
		shape:destroy()
	end
	self.phys_shapes = {}
end

function Surface:draw()
	if (self._polycache == nil) then
		self:_divide()
	end
	
	--[[
	love.graphics.setColor(0, 0, 255)
	for i, node in ipairs(self.nodes) do
		if not node.fixed then
			love.graphics.circle('fill', node.x, node.y, 8, 10)
		end
	end
	--]]
	
	for i, poly in ipairs(self._polycache) do
		love.graphics.setColor(0,0,0)
		love.graphics.polygon('fill', poly)
		love.graphics.setColor(255,255,0)
		--love.graphics.polygon('line', poly)
	end
	
	--[[
	love.graphics.setColor(255, 0, 0)
	for i, polysh in ipairs(self.phys_shapes) do
		love.graphics.polygon('line', polysh:getPoints())
	end
	]]
	
	---[[
	love.graphics.setColor(0, 0, 255)
	for i, node in ipairs(self.nodes) do
		if not node.fixed then
			love.graphics.circle('line', node.x, node.y, 8, 10)
		end
	end
	--]]
end
