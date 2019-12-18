Fall 2019 IPhone Application Development

Kristi Werry 823386935
William Ritchie 815829203

Labyrinth of Mythhaven
We created a game where the user has woken up in a strange place and must 
escape by fighting monsters and traversing through a maze. The user fights the monsters by tapping the screen
to attack, pushing the shield button to block (reducing the damage dealt by the monster),
and swiping left or right to move the player to the left, middle, 
or right side of the screen. The user gains attack, defense, and health as more 
monsters are defeated. After defeating a monster, the user will be prompted with an 
option to go down the left or the right path. After doing this and beating
monsters along the way for a pseudo random number of times, you win!

Our app is restricted to portrait mode.

Our game does not need any third party libraries to run. 

Comments:
- Currently we fight the same monster everytime.
- We ran out of time to design and create other monsters.
- We also don't persistently save the player's stats so if they restart the app, the stats are lost.
- Also could not afford too much time making the UI look nice.

Known bugs:
- We might be not be handling the transition from the GameViewController back to the MainViewController appropriately, we noticed under certain circumstances the GameScene in the GameViewController still runs and prints the console, even though we have already transitioned to the MainViewController. Subsequently we noticed the game on the emulator gets slower under these circumstances. We ran out of time to truly fix this bug but we suspect it has to do with possibly not removing the views appropriatly and we might just be adding them on top of each other
- Ran out of time to fix bug where on certain IPhones the pause modal is off-center

Here is the github repo:
https://github.com/Writchie19/Labyrinth_of_Mythhaven.git
