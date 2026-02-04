extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State


func on_enter():
	print("Actualmente en Shoot")
	animation_player.play("Shoot")
		
func state_process(_delta: float) -> void:
	pass
