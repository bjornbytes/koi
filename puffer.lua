Puffer = {}

function Puffer.create()
	local puffer = {
		x = 400,
		y = 300,
		hp = 5,
		angle = 0,
		size = 60,
		displaySize = 60,
		speed = 0,
		baseSpeed = 75,
		lastBubble = 0,
		sprite = love.graphics.newImage('img/pufferFish.png'),
		lastHurt = 0,
		bandaids = {}
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
    	if self.speed < self.baseSpeed then self.speed = self.speed + 10 * delta end
    	self.angle = math.anglerp(self.angle, math.direction(self.x, self.y, bubbles[minidx].x, bubbles[minidx].y), .025)
    	if mindis < 200 then animHead:seek(4)
		elseif mindis < 300 then animHead:seek(3)
		elseif mindis < 400 then animHead:seek(2)
		else animHead:seek(1) end
    else
    	self.speed = math.max(self.speed - 10 * delta, 0)
    end

    self.lastBubble = self.lastBubble + delta
    if self.lastBubble > 6 then
    	if self.size > 60 then
    		self.size = self.size - (1 * delta)
    	end

    	self.speed = math.min(self.speed + (25 * delta), self.baseSpeed * 1.5)
    else
    	if self.speed > 0 then
    		self.speed = math.max(self.speed - (25 * delta), self.baseSpeed)
    	end
    end

    if self.x < self.size or self.x > love.graphics.getWidth() - self.size then
    	local xangle = math.cos(self.angle)
    	local yangle = math.sin(self.angle)
    	xangle = xangle * -1

    	self.angle = math.direction(0, 0, xangle, yangle)
    	self.speed = self.speed * 0.6

    	if self.x < self.size then self.x = self.size + 1
		elseif self.x > love.graphics.getWidth() - self.size then self.x = love.graphics.getWidth() - (self.size + 1) end
	end

	if self.y < self.size or self.y > love.graphics.getHeight() - self.size then
		local xangle = math.cos(self.angle)
    	local yangle = math.sin(self.angle)
    	yangle = yangle * -1

    	self.angle = math.direction(0, 0, xangle, yangle)
    	self.speed = self.speed * 0.6

    	if self.y < self.size then self.y = self.size + 1
		elseif self.y > love.graphics.getHeight() - self.size then self.y = love.graphics.getHeight() - (self.size + 1) end
	end

	self.displaySize = math.lerp(self.displaySize, self.size, .05)
	self.lastHurt = self.lastHurt + delta

	if math.random() < .2 then
		local l = LilBubby.create()
		l.x = self.x - self.size + math.random() * (2 * self.size)
		l.y = self.y - self.size + math.random() * (2 * self.size)
	end
end

function Puffer:draw()
	if self.lastBubble > 6 then
		love.graphics.setColor(HSV(0, math.min(60 - ((12 - self.lastBubble) / 6) * 60, 60), 255))
	else
		love.graphics.setColor(255, 255, 255)
	end
	
	local scale = 3.5 * self.displaySize / self.sprite:getWidth()
	local scaleSign = -1
	if self.angle % (2 * math.pi) > 1.5 * math.pi or self.angle % (2 * math.pi) < .5 * math.pi then scaleSign = 1 end
	animTail:draw(self.x, self.y, 0, scale * scaleSign, scale, 970, 920)
	animHead:draw(self.x, self.y, 0, scale * scaleSign, scale, 970, 920)
	animFins:draw(self.x, self.y, 0, scale * scaleSign, scale, 970, 920)
	for _, b in pairs(self.bandaids) do
		if b.idx == 1 then
			love.graphics.draw(sprBandaid1, self.x + (b.offsetx * scale * scaleSign), self.y + (b.offsety * scale), b.angle, scale * scaleSign * .5, scale * .5, 400, 400)
		else
			love.graphics.draw(sprBandaid2, self.x + (b.offsetx * scale * scaleSign), self.y + (b.offsety * scale), b.angle, scale * scaleSign * .5, scale * .5, 400, 400)
		end
	end

	if false and love.keyboard.isDown(' ') then
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle('line', self.x, self.y, self.size)
	end
end

function Puffer:hurt()
	local dir = math.direction(self.x, self.y, love.mouse.getPosition())

	self.angle = dir + math.pi
	self.speed = 800

	if self.lastHurt > 5 then
		bubbleRate = bubbleRate - 0.035 * (self.hp)

		self.hp = self.hp - 1
		if self.hp == 0 then
			-- win.
		end

		table.insert(self.bandaids, {
			idx = math.random(1, 2),
			offsetx = -400 + math.random() * 400,
			offsety = -400 + math.random() * 400,
			angle = math.random(2 * math.pi)
		})
		self.lastHurt = 0
		if self.size > 40 then
			self.size = self.size * 0.5
		end
		self.baseSpeed = self.baseSpeed + 50
	end
end