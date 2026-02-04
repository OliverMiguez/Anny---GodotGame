extends "res://Scripts/GeneralStates/Util/State.gd"

@export var walking_state:State

func on_enter():
	print("Actualmente en Waiting shoot")
	animation_player.play("WaitingShoot")

func state_process(_delta: float) -> void:
	var direction = Input.get_axis("IzquierdaP1","DerechaP1")
	
	if direction != 0:
		next_state = walking_state
