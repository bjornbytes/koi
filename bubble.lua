Bubble = {}

bubbles = {}

function Bubble.create()
	local x, y
	repeat
		x = math.random(love.graphics.getWidth())
		y = math.random(love.graphics.getHeight())
	until not math.hcoca(x, y, 50, puffer.x, puffer.y, puffer.size + 40)

	local bubble = {
		id = #bubbles + 1,
		x = x,
		y = y,
		angle = 0,
		speed = 0,
		duration = 10,
		start = delta,
		size = 0,
		tick = 0
	}

	setmetatable(bubble, {__index = Bubble})

	bubbles[#bubbles + 1] = bubble

	return bubble
end

function Bubble:update()
	self.size = math.min(self.size + 160 * delta, 50)
	self.tick = self.tick + delta 

	if self.tick - self.start > self.duration then
		bubbles[self.id] = nil
		self.tick = 0
	end

	if math.hcoca(self.x, self.y, self.size, koi1.x, koi1.y, 50) or math.hcoca(self.x, self.y, self.size, koi2.x, koi2.y, 50) then
		self:pop()
		bubbleBar = math.min(bubbleBar + 1, 20)
	end

	if math.hcoca(self.x, self.y, self.size, puffer.x, puffer.y, puffer.size) then
		self:pop()
		puffer.size = puffer.size + 6
		puffer.lastBubble = 0
	end

	if sucking > 0 then
		local closest = koi1
		if math.distance(self.x, self.y, koi2.x, koi2.y) < math.distance(self.x, self.y, koi1.x, koi1.y) then
			closest = koi2
		end

		local dir = math.direction(self.x, self.y, closest.x, closest.y)
		local dis = math.distance(self.x, self.y, closest.x, closest.y)
		self.speed = (100000 / dis)
		self.angle = dir
	elseif blowing > 0 then
		local closest = koi1
		if math.distance(self.x, self.y, koi2.x, koi2.y) < math.distance(self.x, self.y, koi1.x, koi1.y) then
			closest = koi2
		end

		local dir = math.direction(self.x, self.y, closest.x, closest.y) + math.pi
		local dis = math.distance(self.x, self.y, closest.x, closest.y)
		self.speed = (100000 / dis)
		self.angle = dir
	else
		self.speed = math.max(self.speed - 100 * delta, 0)
	end

	self.x = self.x + math.cos(self.angle) * self.speed * delta
	self.y = self.y + math.sin(self.angle) * self.speed * delta

	if self.x < 0 - self.size or self.x > love.graphics.getWidth() + self.size or self.y < 0 - self.size or self.y > love.graphics.getHeight() + self.size then
		self:pop()
	end
end

function Bubble:pop()
	bubbles[self.id] = nil
end

function Bubble:draw()
	love.graphics.setColor(200, 200, 255)
	love.graphics.circle('line', self.x, self.y, self.size)
end