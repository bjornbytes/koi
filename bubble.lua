Bubble = {}

maxBubbles = 16

function Bubble.create()

	local bubble = {
		x = 0,
		y = 0,
		hp = 3,
		maxHp = 3,
		active = false
	}

	setmetatable(bubble, {__index = Bubble})

	return bubble
end

function Bubble.activate()
	bubbles[nextbubble].active = true
	bubbles[nextbubble].hp = bubbles[nextbubble].maxHp
	local ret = nextbubble
	nextbubble = (nextbubble + 1)
	if nextbubble > maxBubbles then nextbubble = 1 end
	return bubbles[ret]
end

function Bubble:update()
	if not self.active then return end
	self.hp = self.hp - delta
	if self.hp < 0 then self.active = false end
end

function Bubble:draw()
	if not self.active then return end
	love.graphics.setColor(128, 128, 255, 255 * (self.hp / self.maxHp))
	love.graphics.circle('line', self.x, self.y, 20)
end

function Bubble:pop()
	print('pop paaaap!')
	self.active = false
	self.hp = self.maxHp
	self.x = 0
	self.y = 0
end

nextbubble = 1
bubbles = {}
for i = 1, maxBubbles do
	bubbles[i] = Bubble.create()
end