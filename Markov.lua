local m = {}
m.__index = m

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

function ChooseFirst(self)
	local tabl = {}
	for i,v in pairs(self.MarkovWeb) do
		if v["StartChance"] then
			tabl[i] = v["StartChance"]
		end
	end
	return ChooseWeighted(tabl)
end

function ProcessTable(tbl)
	if next(tbl) == nil then return nil end
	
	local newtbl = {}
	local iteration = 0
	for i,v in pairs(tbl) do
		if i ~= "nam" and i ~= "StartChance" then
			newtbl[i] = v
			iteration = iteration + 1
		end
	end
	return newtbl
end

function m:Generate(minlength,maxlength,seed)
	if self.Learned < 1 then
		print("Cannot Generate with no learned data")		
		return
	end
	local WordLength = math.random(minlength,maxlength)
	local currentWord = seed or ChooseFirst(self)
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

function m:Learn(text)
	local words = {}
	
	for word in text:gmatch("%w+") do
		table.insert(words, word) 
	end
	
	if #words == 0 then return end
	self.Learned = self.Learned + 1
	
	self.MarkovWeb[words[1]] = self.MarkovWeb[words[1]] or {}

	self.MarkovWeb[words[1]]["StartChance"] = self.MarkovWeb[words[1]]["StartChance"] == nil and 1 or self.MarkovWeb[words[1]]["StartChance"] + 1
	
	for i = 1, #words do
		local current = words[i]
		local nxt = words[i+1]
		
		self.MarkovWeb[current] = self.MarkovWeb[current] or {}
		
		if nxt then
			self.MarkovWeb[current][nxt] = self.MarkovWeb[current][nxt] == nil and 1 or self.MarkovWeb[current][nxt] + 1
		end
	end
end

function m:MapWeb() --Not recommended with a lot of data, might print thousands of lines of text
	for i,v in pairs(self.MarkovWeb) do
		print(i,v," >")
		for a,b in pairs(v) do
			print("    >",a,b)
		end
	end
end

local module = {}
function module:New()
	return setmetatable({MarkovWeb = {}, Learned = 0},{__index = m})
end

return module