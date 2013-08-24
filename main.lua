require 'util'
require 'koi'
require 'bubble'
require 'bubbleformations'
require 'wall'

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

	bubbleTimer = 0
	meanBubbleTimer = 0

	formation = FormationCreator.create()
end

function love.update(dt)
	delta = dt

	for _, bubble in pairs(bubbles) do
		bubble:update()
	end

	for _, mbubble in pairs(meanBubbles) do
		mbubble:update()
	end

	for _, rsex in pairs(rainbowSexes) do
		rsex:update()
	end

	if math.hcoca(koi1.x, koi1.y, 40, koi2.x, koi2.y, 40) then
		--love.win('<3')
	end

	koi1:update()
	koi2:update()

	formation:update()

	if love.mouse.isDown('l') then
		koi1.sexy = true
		koi2.sexy = true
	else
		koi1.sexy = false
		koi2.sexy = false
	end

	bubbleTimer = bubbleTimer + delta
	if bubbleTimer > .05 then
		local b = Bubble.create()
		bubbleTimer = 0
	end

	meanBubbleTimer = meanBubbleTimer + delta
	if meanBubbleTimer > 1 then
		local b = MeanBubble.create()
		meanBubbleTimer = 0
	end
end

function love.draw()
	koi1:draw()
	koi2:draw()

	for _, rsex in pairs(rainbowSexes) do
		rsex:draw()
	end

	for _, bubble in pairs(bubbles) do
		bubble:draw()
	end

	for _, mbubble in pairs(meanBubbles) do
		mbubble:draw()
	end

	for _, wall in pairs(walls) do
		wall:draw()
	end
end

function love.win(heart)
	print(heart)
	love.restart()
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

	bubbleTimer = 0
	meanBubbleTimer = 0

	bubbles = {}
	meanBubbles = {}
end