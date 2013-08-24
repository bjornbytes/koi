Koi = {}

function Koi.create()
	local koi = {
		x = 0,
		y = 0,
		angle = 0,
		speed = 0,
		accel = 0,
		color = {255, 255, 255}
	}

	setmetatable(koi, {__index = Koi})

	return koi
end

function Koi:update()
	self:move()
end

function Koi:move()
	self.x = self.x + math.cos(self.angle) * self.speed * delta
	self.y = self.y + math.sin(self.angle) * self.speed * delta

	local mindis = math.huge
	local minidx = nil
	for i, bubble in pairs(bubbles) do
		if bubble.active then
			local dis = math.distance(self.x, self.y, bubble.x, bubble.y)
			if dis < mindis then
				mindis = dis
				minidx = i
			end
		end
	end

	if minidx then
		self.angle = math.direction(self.x, self.y, bubbles[minidx].x, bubbles[minidx].y)
		self.speed = 100

		if mindis < 40 + 20 then 
			bubbles[minidx]:pop()
		end
	else
		self.speed = math.lerp(self.speed, 0, .015)
	end
end

function Koi:draw()
	love.graphics.setColor(unpack(self.color))
	love.graphics.circle('fill', self.x, self.y, 40)
end