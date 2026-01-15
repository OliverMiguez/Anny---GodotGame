extends "res://Scripts/GeneralStates/Util/State.gd"


func on_enter():
	animation_player.play("Idle")
	
func state_process(_delta: float) -> void:
	pass
	
