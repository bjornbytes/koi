FormationCreator = {}

function FormationCreator.create()
	local creator = {
		tick = 0,
		duration = 5,
		start = 0,
		formationsSize = 4,
		formations = {
			FormationCreator.line,
			FormationCreator.square,
			FormationCreator.tile,
			FormationCreator.diagnol
		}
	}

	setmetatable(creator, {__index = FormationCreator})

	return creator
end

function FormationCreator:update()
	self.tick = delta + self.tick

	if self.tick - self.start > self.duration then
		self:generate()
	else
		if self.formation then
			self.formation:update()
		end
	end
end

function FormationCreator:generate()
	local formation = self.formations[math.random(self.formationsSize)]
	local x = math.random(0, love.graphics.getWidth())

	self.duration = math.random(5)
	self.formation = formation:create(x, duration)
end

FormationCreator.line = {
	width = 10,
	bubbleRate = .05,
	create = function(self, x, duration)
		bubbleTimer = 0
		self.duration = duration

		return self
	end,

	update = function(self)
		bubbleTimer = bubbleTimer + delta
		if bubbleTimer > bubbleRate then
			--make a bubby
			local bubble = Bubble:create()
			bubble.x = math.random(self.duration, self.duration + self.width)

			bubbleTimer = 0
		end
	end
}

FormationCreator.square = {
	create = function(self, x, duration)

		return self
	end,

	update = function(self)

	end
}

FormationCreator.tile = {
	create = function(self, x, duration)

		return self
	end,

	update = function(self)

	end
}

FormationCreator.diagnol = {
	create = function(self, x, duration)

		return self
	end,

	update = function(self)

	end
}