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
end

function Bubble:draw()
	love.graphics.setColor(200, 200, 255)
	love.graphics.circle('line', self.x, self.y, 20)
end