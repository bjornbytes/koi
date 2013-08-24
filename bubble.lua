Bubble = {}

bubbles = {}

function Bubble.create()
	local bubble = {
		id = #bubbles + 1,
		x = math.random() * love.graphics.getWidth(),
		y = love.graphics.getHeight() + 40,
		speed = 250 + math.random() * 150
	}

	setmetatable(bubble, {__index = Bubble})

	bubbles[#bubbles + 1] = bubble

	return bubble
end

function Bubble:update()
	self.y = self.y - self.speed * delta
	if self.y < -40 then
		bubbles[self.id] = nil
	end

	if math.hcoca(self.x, self.y, 20, koi1.x, koi1.y, 30) or math.hcoca(self.x, self.y, 20, koi2.x, koi2.y, 30) then
		self:pop()
	end
end

function Bubble:pop()
	bubbles[self.id] = nil
	for _ = 1, 30 do
		RainbowSex.create(self.x, self.y)
	end
end

function Bubble:draw()
	love.graphics.setColor(200, 200, 255)
	love.graphics.circle('line', self.x, self.y, 20)
end