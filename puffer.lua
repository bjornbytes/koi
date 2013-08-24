Puffer = {}

function Puffer.create()
	local puffer = {
		x = 400,
		y = 300,
		angle = 0,
		size = 40,
		speed = 0,
		lastBubble = 0
	}

	setmetatable(puffer, {__index = Puffer})

	return puffer
end

function Puffer:update()
	self.x = self.x + math.cos(self.angle) * self.speed * delta
	self.y = self.y + math.sin(self.angle) * self.speed * delta

	local mindis = math.huge
    local minidx = nil
    for i, bubble in pairs(bubbles) do
		local dis = math.distance(self.x, self.y, bubble.x, bubble.y)
		if dis < mindis then
			mindis = dis
			minidx = i
		end
    end

    if minidx then
    	if self.speed < 75 then self.speed = self.speed + 10 * delta end
    	self.angle = math.anglerp(self.angle, math.direction(self.x, self.y, bubbles[minidx].x, bubbles[minidx].y), .025)
    else
    	self.speed = math.max(self.speed - 10 * delta, 0)
    end

    self.lastBubble = self.lastBubble + delta
    if self.lastBubble > 10 then
    	if self.size > 40 then
    		self.size = self.size - (1 * delta)
    	end

    	self.speed = math.min(self.speed + (10 * delta), 200)
    else
    	if self.speed > 0 then
    		self.speed = math.max(self.speed - (5 * delta), 75)
    	end
    end
end

function Puffer:draw()
	love.graphics.setColor(255, 255, 0)
	love.graphics.circle('fill', self.x, self.y, self.size)
end