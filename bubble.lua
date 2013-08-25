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
		angle = math.random(2 * math.pi),
		speed = math.random(20),
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
		bubbleBar = math.min(bubbleBar + 1, bubbleBarMax)
	end

	if math.hcoca(self.x, self.y, self.size, puffer.x, puffer.y, puffer.size) then
		self:pop()
		puffer.size = puffer.size + puffer.hp * 2
		puffer.lastBubble = 0
	end

	self.x = self.x + math.cos(self.angle) * self.speed * delta
	self.y = self.y + math.sin(self.angle) * self.speed * delta

	if self.x < 0 - self.size or self.x > love.graphics.getWidth() + self.size or self.y < 0 - self.size or self.y > love.graphics.getHeight() + self.size then
		self:pop()
	end
end

function Bubble:pop()
	bubbles[self.id] = nil

	for _ = 1, 60 do
		local l = LilBubby.create()
		l.x = self.x - 20 + math.random() * (2 * 20)
		l.y = self.y - 20 + math.random() * (2 * 20)
		l.dir = math.random(2 * math.pi)
		l.speed = 400
	end
end

function Bubble:draw()
	if love.keyboard.isDown(' ') then
		love.graphics.setColor(200, 200, 255)
		love.graphics.circle('line', self.x, self.y, self.size)
	end

	local scale = 2.2 * self.size / sprBubble:getWidth()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(sprBubble, self.x, self.y, 0, scale, scale, sprBubble:getWidth() / 2 + 1, sprBubble:getHeight() / 2 + 1)
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

LilBubby = {}

lilbubbies = {}

function LilBubby.create(x, y)
	local bub = {
		id = #lilbubbies + 1,
		x = x,
		y = y,
		size = 0,
		maxSize = 10 + math.random() * 10
	}

	bub.hp = math.random() * .5
	bub.maxHp = bub.hp
	bub.dir = (math.pi * 1.5) - .15 + math.random() * .3
	bub.speed = 100 + math.random(50)

	setmetatable(bub, {__index = LilBubby})

	lilbubbies[bub.id] = bub

	return bub
end

function LilBubby:update()
	self.x = self.x + math.cos(self.dir) * self.speed * delta
	self.y = self.y + math.sin(self.dir) * self.speed * delta

	local d = math.anglediff(self.dir, math.pi * 1.5)
	self.dir = self.dir + (d * delta * 3)

	if self.speed > 150 then self.speed = self.speed - 20 * delta end

	self.size = math.min(self.size + 50 * delta, self.maxSize)

	self.hp = self.hp - delta
	if self.hp < 0 then
		lilbubbies[self.id] = nil
	end
end

function LilBubby:draw()
	local scale = 2.2 * self.size / sprBubble:getWidth()

	love.graphics.setColor(255, 255, 255, (self.hp / self.maxHp) * 200)
	love.graphics.draw(sprBubble, self.x, self.y, 0, scale, scale, sprBubble:getWidth() / 2 + 1, sprBubble:getHeight() / 2 + 1)
end

