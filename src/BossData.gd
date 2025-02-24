extends Node

enum State{
	CHASE,
	MELEE,
	RANGED,
	TACKLE,
	BLOCKED,
}

var actions = { State.MELEE : 70, State.RANGED : 15, State.BLOCKED : 5, State.TACKLE : 10 }
