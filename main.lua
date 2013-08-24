require 'util'
require 'koi'
require 'bubble'
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
end

function love.update(dt)
	delta = dt

	for _, bubble in pairs(bubbles) do
		bubble:update()
	end

	if math.hcoca(koi1.x, koi1.y, 40, koi2.x, koi2.y, 40) then
		--love.win('<3')
	end

	koi1:update()
	koi2:update()

	if love.mouse.isDown('l') then
		koi1.sexy = true
		koi2.sexy = true
	else
		koi1.sexy = false
		koi2.sexy = false
	end

	bubbleTimer = bubbleTimer + delta
	if bubbleTimer > .2 then
		local b = Bubble.create()
		bubbleTimer = 0
	end
end

function love.draw()
	koi1:draw()
	koi2:draw()

	for _, bubble in pairs(bubbles) do
		bubble:draw()
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
end