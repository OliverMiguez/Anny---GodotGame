extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@onready var main_character_collision: CollisionShape2D = $"../../MainCharacterCollision"


func on_enter():
	animation_player.play("Jump")

func state_process(_delta: float) -> void:
	if father.is_on_floor():
		next_state = idle_state

func on_exit():
	print("State Exit: ", self.name)
	
