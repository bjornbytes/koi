FormationCreator = {}

formationCreators = {}

function FormationCreator.create()
	local creator = {
		tick = 0,
		duration = 5,
		start = 0,
		formationsSize = 3,
		formations = {
			FormationCreator.line,
			FormationCreator.tile,
			FormationCreator.diagnol
		}
	}

	setmetatable(creator, {__index = FormationCreator})

	formationCreators[#formationCreators + 1] = creator

	return creator
end

function FormationCreator:update()
	self.tick = delta + self.tick

	if self.tick - self.start > self.duration then
		self.start = self.tick
		self:generate()
	else
		if self.formation then
			self.formation:update()
		end
	end
end

function FormationCreator:generate()
	local formation = self.formations[math.random(1, self.formationsSize)]
	local x = math.random(0, love.graphics.getWidth())

	self.duration = 5 + math.random(5)
	self.formation = formation:create(x, self.duration)
end

FormationCreator.line = {
	width = 10,
	bubbleRate = .35,
	create = function(self, x, duration)
		self.x = x
		self.bubbleTimer = 0
		self.duration = duration

		return self
	end,

	update = function(self)
		self.bubbleTimer = self.bubbleTimer + delta
		if self.bubbleTimer > self.bubbleRate then
			--make a bubby
			local bubble1, bubble2 = Bubble:create(), Bubble:create()
			
			bubble1.x = math.random(self.x, self.x + self.width)
			bubble2.x = love.graphics.getWidth() / 2 + (love.graphics.getWidth() / 2 - bubble1.x)

			self.bubbleTimer = 0
		end
	end
}

FormationCreator.tile = {
	width = 50,
	bubbleRate = 10,
	create = function(self, x, duration)
		self.x = x
		self.bubbleTimer = 0
		self.duration = duration

		return self
	end,

	update = function(self)
		self.bubbleTimer = self.bubbleTimer + delta

		if self.bubbleTimer > self.bubbleRate then
			--make a bubby
			for _ = 1, 10 do
				local bubble = Bubble:create()
				bubble.x = math.random(self.x, self.x + self.width)
				bubble.y = bubble.y + math.random(self.width)
				bubble.speed = math.random(200, 210)
			end

			self.bubbleTimer = 0
		end
	end
}

FormationCreator.diagnol = {
	bubbleRate = 0.05,
	width = 50,
	create = function(self, x, duration)
		self.x = x
		self.bubbleTimer = 0
		self.duration = duration

		return self
	end,

	update = function(self)
		self.bubbleTimer = self.bubbleTimer + delta
		if self.bubbleTimer > self.bubbleRate then
			--make a bubby
			local bubble = Bubble:create()

			bubble.x = self.x
			bubble.y = bubble.y + math.random(self.width)
			bubble.speed = math.random(200, 500)

			if self.x > love.graphics.getWidth() / 2 then
				self.x = self.x + 10
			else
				self.x = self.x - 10
			end

			self.bubbleTimer = 0
		end
	end
}

for i = 1, 30 do
	formationCreators[i] = FormationCreator.create()
end