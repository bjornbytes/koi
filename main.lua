require 'util'
require 'koi'
require 'puffer'
require 'bubble'

require 'anal'

toUpdate = {
	bubbles,
	meanBubbles,
	rainbowSexes
}

function love.load()
	koi1 = Koi.create()
	koi2 = Koi.create()

	koi1.color = {255, 0, 0}
	koi2.color = {0, 0, 255}

	koi1.x, koi1.y = 64, 64
	koi2.x, koi2.y = love.graphics.getWidth() - 64, love.graphics.getHeight() - 64

	koi1.id, koi2.id = 1, 2

	koi1.angle = 0
	koi2.angle = math.pi

	puffer = Puffer.create()

	bubbleTimer = 0
	bubbleRate = 1.5
	nextBubble = .25
	maxBubbles = 2
	bubbleSpeedup = 0

	sprKoi = {}
	sprKoi[1] = love.graphics.newImage('blackKoi.png')
	sprKoi[2] = love.graphics.newImage('blackKoi.png')

	animKoi = {}
	animKoi[1] = newAnimation(sprKoi[1], 128, 128, 0.1, 0)
	animKoi[2] = newAnimation(sprKoi[2], 128, 128, 0.1, 0)

	bubbleBar = 0
end

function love.update(dt)
	delta = dt

	for _, table in pairs(toUpdate) do
		for _, inst in pairs(table) do
			inst:update()
		end
	end

	koi1:update()
	koi2:update()
	puffer:update()

	if bubbleTimer > nextBubble then
		if table.count(bubbles) < maxBubbles then
			Bubble.create()
		end
		bubbleTimer = 0
		nextBubble = math.max(bubbleRate - .5 + math.random() * 1, 0)
	end

	animKoi[1].update(animKoi[1], dt)
	animKoi[2].update(animKoi[2], dt)

	bubbleTimer = bubbleTimer + delta
	bubbleSpeedup = bubbleSpeedup + delta

	if bubbleSpeedup > 10 then
		bubbleRate = bubbleRate - .05
		bubbleSpeedup = 0
		maxBubbles = maxBubbles + 1
	end
end

function love.draw()
	love.graphics.setColor(50, 50, 100)
	love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	love.graphics.setColor(0, 200, 200, 128)
	love.graphics.rectangle('fill', 60, 10, (love.graphics.getWidth() - 120) * (bubbleBar / 100), 40)
	love.graphics.setColor(0, 200, 200, 255)
	love.graphics.rectangle('line', 60, 10, love.graphics.getWidth() - 120, 40)

	koi1:draw()
	koi2:draw()
	puffer:draw()

	for _, bubble in pairs(bubbles) do
		bubble:draw()
	end
end

function love.gameover()
	love.restart()
end

function love.restart()
	koi1.color = {255, 0, 0}
	koi2.color = {0, 0, 255}

	koi1.x, koi1.y = 64, 64
	koi2.x, koi2.y = love.graphics.getWidth() - 64, love.graphics.getHeight() - 64

	koi1.speed, koi2.speed = 0, 0

	for _, bubble in pairs(bubbles) do
		bubble:pop()
	end
	table.print(bubbles)
	bubbleTimer = 0
	bubbleRate = 2
end