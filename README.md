# MarkovChainRBX
Markov Chain Implementation in Roblox

**Sample Usage**
------
```
local Markov = require(path.to.module)
local MarkovObject = Markov:New()
MarkovObject:Learn("Text you want to teach to the module goes here")
MarkovObject:Learn("Even more text goes here wow")
MarkovObject:Generate(MinAmountOfWords, MaxAmountOfWords, Seed) --Generates a message using the learned data
```
The module might not always generate sensible text.
And make sure to filter anything that comes out of it if any players can see it.


**Documentation**
---
```
Markov:New()
--Creates new Markov Object (used for seperate datasets)

MarkovObject:Generate(MinLength, MaxLength, Seed)
--MinLength is the mininmum amount of words generated in the sentence
--MaxLength is the maximum amount of words generated in the sentence
--Seed is used to choose the first word from which to use to generate

MarkovObject:Learn(String) 
--Makes the Chain learn those words and how they interact
```
