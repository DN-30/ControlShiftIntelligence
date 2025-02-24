This is an attempt by 5 dudes with no prior knowledge about anything related to AI to create a working game in which the boss adapts to the user's playstyle after each game and plays accordingly.

Imagine playing a game where the boss is like Maharoga and it levels up just like in Solo Levelling. It is a topdown type game which engages the user to fight the boss.

AI Adaptation System

After each fight, a Python script runs through Mira Flows to analyze the player's behavior and adjust the Boss's action probabilities accordingly.
The AI updates the probabilities to make the boss better suited for the player's playstyle.

Example Working of Project:
First Fight:
Initially, the boss probabilities were as follows:
	var actions = { State.MELEE : 25, State.RANGED : 25, State.BLOCKED : 25, State.TACKLE : 25 }
	
The player is aggressive and stays close to the boss, frequently using melee attacks.
After the fight, the AI increases the probability of the Boss using melee to counter the player's style and reduces probability of ranged attacks due to proximity.

After the fight boss probabilities were updated as follows:
    var actions = { State.MELEE : 50, State.RANGED : 10, State.BLOCKED : 20, State.TACKLE : 20 }


Future Improvements

	More complex AI learning algorithms.

    Different boss types with unique fighting styles.

	Enhanced difficulty scaling based on multiple fight history.

This project showcases adaptive AI in game design, making each fight unique based on the player's approach.

The 5 dudes who worked on this:

 Mr-excaliver, BruhGamer05, d1vy3, theb1gf00t,  K-1809

