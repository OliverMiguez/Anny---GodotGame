extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State

func on_enter():
	animation_player.play("Jump")

func state_process(_delta: float) -> void:
	if father.velocity.y == 0:
		next_state = idle_state
	
