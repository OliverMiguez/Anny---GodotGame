extends "res://Scripts/GeneralStates/Util/State.gd"

@onready var plancha_cooldown: Timer = $"../../Plancha_cooldown"


@export var idle_state:State
@export var jump_state:State
func on_enter():
	
	plancha_cooldown.start()
	father.can_move = false
	
	father.velocity.x = (
		1 if father.main_character_animations.flip_h == false else -1
	) * father.JUMP_FORCE.x
	
	father.velocity.y = father.JUMP_FORCE.y
	
	father.start_plancha_cooldown()
	animation_player.play("Plancha")
	
func state_process(_delta: float) -> void:
	pass

func _on_main_character_animations_animation_finished():
	if animation_player.animation == "Plancha":
		father.can_move = true
		next_state = idle_state

func on_exit():
	father.can_move = true


func _on_plancha_cooldown_timeout() -> void:
	if not father.is_on_floor():
		next_state = jump_state
		return
