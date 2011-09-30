
function invr(node1, node2, r, f)
	if node2.y - node1.y == 0 and node2.x - node1.x == 0 then
		return false
	end
	
	if distance(node1, node2) >= r then
		return false
	end
	
	local mag = f*distance(node1, node2)/r
	
	print(mag .. ', ' .. f .. ', ' .. r .. ', ' .. distance(node1, node2) )
	
	local dir = math.atan2(node2.y - node1.y, node2.x - node1.x)
	
	if mag > 0 and math.abs(node2.x - node1.x) <= math.abs(mag*math.cos(dir)) then
		node1.x = node2.x
	else
		node1.x = node1.x + mag*math.cos(dir)
	end
	
	if mag > 0 and math.abs(node2.y - node1.y) <= math.abs(mag*math.sin(dir)) then
		node1.y = node2.y
	else	
		node1.y = node1.y + mag*math.sin(dir)
	end
	
	print('Force x = ' .. mag*math.cos(dir) .. ' y = ' .. mag*math.sin(dir))
	
	-- Disregard any changes less than 1 pixel
	--return math.abs(mag) >= 1
	return true
end

function inv(node1, node2, f, pow, cap)
	pow = pow or 1

	if node2.y - node1.y == 0 and node2.x - node1.x == 0 then
		return false
	end
	
	local mag = f/distance(node1, node2)^pow
	if cap  ~= nil and math.abs(mag) > math.abs(cap) then
		mag = cap * mag/math.abs(mag)
	end
	local dir = math.atan2(node2.y - node1.y, node2.x - node1.x)
	
	if mag > 0 and math.abs(node2.x - node1.x) <= math.abs(mag*math.cos(dir)) then
		node1.x = node2.x
	else
		node1.x = node1.x + mag*math.cos(dir)
	end
	
	if mag > 0 and math.abs(node2.y - node1.y) <= math.abs(mag*math.sin(dir)) then
		node1.y = node2.y
	else	
		node1.y = node1.y + mag*math.sin(dir)
	end
	
	print('Force x = ' .. mag*math.cos(dir) .. ' y = ' .. mag*math.sin(dir))
	
	-- Disregard any changes less than 1 pixel
	--return math.abs(mag) >= 1
	return true
end

function directed(node1, node2, r, f, dir)
	local dist = distance(node1, node2)
	if dist > r then
		return false
	end
	node1.x = node1.x + f*math.cos(dir)*(1 - dist/r)
	node1.y = node1.y + f*math.sin(dir)*(1 - dist/r)
	
	print(f*dist/r)
	
	return true
end
