function distance(node1, node2)
	return math.sqrt((node2.x - node1.x)^2 + (node2.y - node1.y)^2)
end

function draw_tiled(drawable, x, y, sx, sy, ox, oy, w, h)
	x = x or 0
	y = y or 0
	sx = sx or 1
	sy = sy or 1
	w = w or drawable:getWidth()
	h = h or drawable:getHeight()
	ox = ox or 0
	oy = oy or 0
	
	for i = 0, h, drawable:getHeight() * math.abs(sy) do
		for j = 0, w, drawable:getWidth() * math.abs(sx) do
			love.graphics.drawq(drawable, love.graphics.newQuad(0, 0, math.min(w - j, drawable:getWidth()), math.min(h - i, drawable:getHeight()), drawable:getWidth(), drawable:getHeight()), x + j, y + i, 0, sx, sy, ox, oy)
		end
	end
end

function table.removevalue(t, element)
	for i, val in ipairs(t) do
		if element == val then
			table.remove(t, i)
			return true
		end
	end
	return false
end

function table.append(t1, t2)
	for _, i in ipairs(t2) do
		table.insert(t1, i)
	end
end
