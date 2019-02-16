# MarkovChainRBX
Markov Chain Implementation in Roblox

**Sample Usage**
------
```
local Markov = require(path.to.module)
local MarkovObject = Markov:New()
MarkovObject:Learn("Text you want to teach to the module goes here")
MarkovObject:Learn("Even more text goes here wow")
MarkovObject:Generate(MinAmountOfWords,MaxAmountOfWords,Seed) --Generates a message using the learned data
```
When adding a Seed it will continue the sentence for X many words.

The module might not always generate sensible text.
And make sure to filter anything that comes out of it if any players can see it.


**Documentation**
------
```
Markov:New()
--Creates new Markov Object (used for seperate datasets)

MarkovObject:Generate(MinLength,MaxLength,Seed)
--MinLength is the mininmum amount of words generated in the sentence
--MaxLength is the max amount of words generated in the sentence
--Seed is used to manually start the sentence, using the seed "The" 
--would make it continue a sentence starting with "The ..."

MarkovObject:Learn(String) --Makes the Chain learn those words and how they interact

MarkovObject:MapWeb() --Used to "visualize" the Web of words and how they connect, currently
--it prints something like
--[[
    >The
        >Brown weightval
        >Yellow weightval
        >Human weighval 
weightval is the weight of the word (how likely it is that this word comes after "The" in this case)
--]]
```
