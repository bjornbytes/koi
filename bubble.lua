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

RainbowSex = {}

rainbowSexes = {}

function RainbowSex.create(x, y)
	local rsex = {
		id = #rainbowSexes + 1,
		x = x,
		y = y,
	}

	rsex.r, rsex.g, rsex.b = HSV((math.random() * 255), 255, 255)
	rsex.hp = math.random() * .5
	rsex.maxHp = rsex.hp
	rsex.dir = math.random() * math.pi * 2
	rsex.len = 100 + math.random() * 300

	setmetatable(rsex, {__index = RainbowSex})

	rainbowSexes[rsex.id] = rsex

	return rsex
end

function RainbowSex:update()
	self.x = math.lerp(self.x, self.x + math.cos(self.dir) * self.len, .05)
	self.y = math.lerp(self.y, self.y + math.sin(self.dir) * self.len, .05)

	self.hp = self.hp - delta
	if self.hp < 0 then
		rainbowSexes[self.id] = nil
	end
end

function RainbowSex:draw()
	love.graphics.setColor(self.r, self.g, self.b, (self.hp / self.maxHp) * 255)
	love.graphics.circle('fill', self.x, self.y, 100 * (1 - (self.hp / self.maxHp)))
end

MeanBubble = {}
setmetatable(MeanBubble, {__index = Bubble})

meanBubbles = {}

function MeanBubble.create()
	local meanBubble = {
		id = #meanBubbles + 1,
		x = math.random() * love.graphics.getWidth(),
		y = love.graphics.getHeight() + 40,
		speed = 250 + math.random() * 150
	}

	setmetatable(meanBubble, {__index = MeanBubble})

	meanBubbles[#meanBubbles + 1] = meanBubble

	return meanBubble
end

function MeanBubble:pop()
	bubbles[self.id] = nil
	love.gameover()
end

function MeanBubble:draw()
	love.graphics.setColor(120, 50, 50)
	love.graphics.circle('fill', self.x, self.y, 20)
end