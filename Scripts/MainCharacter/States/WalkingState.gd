extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@export var run_state:State
@export var crouch_state:State
@export var jump_state:State

func on_enter():
	animation_player.play("Walk")

func state_process(_delta: float) -> void:
	if father.velocity.x == 0 and Input.is_action_pressed("ui_down"):
		next_state = crouch_state
		
	elif father.velocity.x == 0:
		next_state = idle_state
		
	elif father.velocity.x != 0 and  Input.is_action_pressed("Shift"):
		next_state = run_state
	
	elif Input.is_action_pressed("ui_up"):
		next_state = jump_state
	
		
## Gira el sprite de la animación
func flip_animation():
	var direction = Input.get_axis("ui_left","ui_right")

	if direction > 0:
		animation_player.flip_h = false
	else:
		animation_player.flip_h = true
		
func _physics_process(_delta: float) -> void:
	flip_animation()
