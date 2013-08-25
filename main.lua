require 'util'
require 'pulse'
require 'starfish'
require 'koi'
require 'puffer'
require 'shark'
require 'bubble'

require 'anal'

toUpdate = {
	bubbles,
	meanBubbles,
	rainbowSexes,
	sharks
}

function love.load()
	gt = 0

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

	sandTile = love.graphics.newImage('sandTile.png')
	water = love.graphics.newImage('water.png')
	waterLight = love.graphics.newImage('waterLight.png')
	sprBubble = love.graphics.newImage('bubble.png')

	for i = 1, 6 do
		StarFish.create()
	end

	bubbleBar = 0
	bubbleBarDisplay = 0

	sharkTimer = 0
	nextShark = 10

	tangoing = 0
	kinky = false

end

function love.update(dt)
	gt = (gt + dt)
	if gt > 40 then gt = -10 end
	delta = dt

	fx.pulse:send( "time", gt )

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

	if bubbleSpeedup > 5 then
		bubbleRate = bubbleRate - .1
		bubbleSpeedup = 0
		maxBubbles = maxBubbles + 1
	end

	if tangoing > 0 then
		tangoing = math.max(tangoing - delta, 0)
	end

	sharkTimer = sharkTimer + delta
	if sharkTimer > nextShark then
		Shark.create()
		sharkTimer = 0
		nextShark = 20 - 10 + math.random(20)
	end

	bubbleBarDisplay = math.lerp(bubbleBarDisplay, bubbleBar, .05)

	fx.pulse:send('mx', love.mouse.getX())
	fx.pulse:send('my', love.mouse.getY())
end

function love.draw()
	love.graphics.reset()

	love.graphics.setPixelEffect(fx.pulse)
	love.graphics.setColor(255, 255, 255, 50)
	love.graphics.draw(sandTile, 0, 0)
	love.graphics.setPixelEffect()
	
	love.graphics.setColor(255, 255, 255, 60)
	for _, sf in pairs(starfish) do
		sf:draw()
	end


	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.draw(sandTile, 0, 0)

	
	love.graphics.setColor(0, 0, 200, 128)
	love.graphics.rectangle('fill', 60, 10, (love.graphics.getWidth() - 120) * (bubbleBarDisplay / 20), 40)
	love.graphics.setColor(0, 0, 200, 255)
	love.graphics.line(love.graphics.getWidth() / 2, 10, love.graphics.getWidth() / 2, 50)
	love.graphics.rectangle('line', 60, 10, love.graphics.getWidth() - 120, 40)

	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.draw(water, 0, 0)

	love.graphics.setColor(0, 200, 200, 128)
	love.graphics.rectangle('fill', 60, 10, (love.graphics.getWidth() - 120) * (bubbleBar / 20), 40)
	love.graphics.setColor(0, 200, 200, 255)
	love.graphics.line(love.graphics.getWidth() / 2, 10, love.graphics.getWidth() / 2, 50)
	love.graphics.rectangle('line', 60, 10, love.graphics.getWidth() - 120, 40)

	koi1:draw()
	koi2:draw()
	puffer:draw()

	for _, bubble in pairs(bubbles) do
		bubble:draw()
	end
	
	for _, shark in pairs(sharks) do
		shark:draw()
	end

	for _, sex in pairs(rainbowSexes) do
		sex:draw()
	end

	love.graphics.setColor(255, 255, 255, 160)
	love.graphics.draw(water, 0, 0)

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
	bubbleRate = 2
	bubbleBar = 0

	puffer.size = 40
end

function love.keypressed(key)
	if key == ' ' then
		if bubbleBar >= 20 then
			bubbleBar = bubbleBar - 20
			tangoing = 5
		end
	end
end