local Markov = {}
Markov.__index = Markov

function ChooseWeighted(tbl) --i is string, v is number, has to be exactly that
	local total = 0
	for i,v in pairs(tbl) do
		total = total + v
	end
	if total == 0 then return "" end
	local rand = math.random(total)
	for i,v in pairs(tbl) do
		if rand <= v then
			return i
		end
		rand = rand - v
	end
end

function Markov:ChooseFirst()
	local tabl = {}
	for i,v in pairs(self.MarkovWeb) do
		if v.StartChance then
			tabl[i] = v.StartChance
		end
	end
	return ChooseWeighted(tabl)
end

function ProcessTable(tbl)
	if next(tbl) == nil then return nil end
	
	local newtbl = {}
	for i,v in pairs(tbl) do
		if i ~= "nam" and i ~= "StartChance" then
			newtbl[i] = v
		end
	end
	return newtbl
end

function Markov:Generate(minlength, maxlength, seed)
	if self.Learned < 1 then
		print("Cannot Generate with no learned data")		
		return
	end
	minlength = minlength or 1
	maxlength = maxlength or 100
	
	local WordLength = math.random(minlength,maxlength)
	local currentWord = seed or self:ChooseFirst()
	local Sentence = currentWord

	for i = 1, WordLength-1 do
		local Processed = ProcessTable(self.MarkovWeb[currentWord])
		
		if not Processed then
			break; --Sentence has no word to keep going so it has to stop :p
		end
		
		local Word = ChooseWeighted(Processed)
		Sentence = Sentence .. " " .. Word
		currentWord = Word
	end
	
	return Sentence
end

function Markov:Learn(text)
	if not text or string.len(text) == 0 then return end
	local words = {}
	
	for word in text:gmatch("%w+") do
		table.insert(words, word) 
	end
	
	self.Learned = self.Learned + 1
	
	local Root = words[1]
	
	self.MarkovWeb[Root] = self.MarkovWeb[Root] or {}
	self.MarkovWeb[Root].StartChance = self.MarkovWeb[Root].StartChance or 1
	
	for i = 1, #words do
		local current = words[i]
		local nxt = words[i+1]
		
		self.MarkovWeb[current] = self.MarkovWeb[current] or {}
		
		if nxt then
			self.MarkovWeb[current][nxt] = self.MarkovWeb[current][nxt] == nil and 1 or self.MarkovWeb[current][nxt] + 1
		end
	end
end

local module = {}

function module:New()
	return setmetatable({MarkovWeb = {}, Learned = 0}, Markov)
end

return module
