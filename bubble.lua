Bubble = {}

bubbles = {}

function Bubble.create()
	local bubble = {
		id = #bubbles + 1,
		x = math.random(love.graphics.getWidth()),
		y = math.random(love.graphics.getHeight()),
		speed = 250 + math.random() * 150,
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
	self.size = math.min(self.size + 160 * delta, 25)
	self.tick = self.tick + delta 

	if self.tick - self.start > self.duration then
		bubbles[self.id] = nil
		self.tick = 0
	end

	if math.hcoca(self.x, self.y, self.size, koi1.x, koi1.y, 30) or math.hcoca(self.x, self.y, 20, koi2.x, koi2.y, 30) then
		self:pop()
	end

	if math.hcoca(self.x, self.y, self.size, puffer.x, puffer.y, puffer.size) then
		self:pop()
		puffer.size = puffer.size + 1
		puffer.lastBubble = delta
	end
end

function Bubble:pop()
	bubbles[self.id] = nil
end

function Bubble:draw()
	love.graphics.setColor(200, 200, 255)
	love.graphics.circle('line', self.x, self.y, self.size)
end