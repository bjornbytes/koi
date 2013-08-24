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
	self.size = math.min(self.size + 160 * delta, 50)
	self.tick = self.tick + delta 

	if self.tick - self.start > self.duration then
		bubbles[self.id] = nil
		self.tick = 0
	end

	if math.hcoca(self.x, self.y, self.size, koi1.x, koi1.y, 50) or math.hcoca(self.x, self.y, self.size, koi2.x, koi2.y, 50) then
		self:pop()
		bubbleBar = math.min(bubbleBar + 1, 100)
		print(bubbleBar .. ' sucks')
	end

	if math.hcoca(self.x, self.y, self.size, puffer.x, puffer.y, puffer.size) then
		self:pop()
		puffer.size = puffer.size + 6
		puffer.lastBubble = 0
	end
end

function Bubble:pop()
	bubbles[self.id] = nil
end

function Bubble:draw()
	love.graphics.setColor(200, 200, 255)
	love.graphics.circle('line', self.x, self.y, self.size)
end