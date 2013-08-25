Puffer = {}

function Puffer.create()
	local puffer = {
		x = 400,
		y = 300,
		angle = 0,
		size = 40,
		displaySize = 40,
		speed = 0,
		lastBubble = 0,
		sprite = love.graphics.newImage('pufferFish.png')
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
    	if self.speed < 75 then self.speed = self.speed + 10 * delta end
    	self.angle = math.anglerp(self.angle, math.direction(self.x, self.y, bubbles[minidx].x, bubbles[minidx].y), .025)
    	if mindis < 200 then animHead:seek(4)
		elseif mindis < 300 then animHead:seek(3)
		elseif mindis < 400 then animHead:seek(2)
		else animHead:seek(1) end
    else
    	self.speed = math.max(self.speed - 10 * delta, 0)
    end

    self.lastBubble = self.lastBubble + delta
    if self.lastBubble > 10 then
    	if self.size > 40 then
    		self.size = self.size - (1 * delta)
    	end

    	self.speed = math.min(self.speed + (10 * delta), 200)
    else
    	if self.speed > 0 then
    		self.speed = math.max(self.speed - (5 * delta), 75)
    	end
    end

    if self.x < self.size or self.x > love.graphics.getWidth() - self.size then
    	local xangle = math.cos(self.angle)
    	local yangle = math.sin(self.angle)
    	xangle = xangle * -1

    	self.angle = math.direction(0, 0, xangle, yangle)

    	if self.x < self.size then self.x = self.size + 1
		elseif self.x > love.graphics.getWidth() - self.size then self.x = love.graphics.getWidth() - (self.size + 1) end
	end

	if self.y < self.size or self.y > love.graphics.getHeight() - self.size then
		local xangle = math.cos(self.angle)
    	local yangle = math.sin(self.angle)
    	yangle = yangle * -1

    	self.angle = math.direction(0, 0, xangle, yangle)
    	if self.y < self.size then self.y = self.size + 1
		elseif self.y > love.graphics.getHeight() - self.size then self.y = love.graphics.getHeight() - (self.size + 1) end
	end

	self.displaySize = math.lerp(self.displaySize, self.size, .05)
end

function Puffer:draw()
	love.graphics.setColor(255, 255, 255)
	
	local scale = 3.5 * self.displaySize / self.sprite:getWidth()
	local scaleSign = -1
	if self.angle % (2 * math.pi) > 1.5 * math.pi or self.angle % (2 * math.pi) < .5 * math.pi then scaleSign = 1 end
	--love.graphics.draw(sprHead, self.x, self.y, 0, scale * scaleSign, scale, 970, 920)
	animHead:draw(self.x, self.y, 0, scale * scaleSign, scale, 970, 920)
	animFins:draw(self.x, self.y, 0, scale * scaleSign, scale, 970, 920)

	if love.keyboard.isDown(' ') then
		love.graphics.setColor(255, 0, 0)
		love.graphics.circle('line', self.x, self.y, self.size)
	end
end