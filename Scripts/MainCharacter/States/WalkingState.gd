extends "res://Scripts/GeneralStates/Util/State.gd"

var can_roll = true
@onready var roll_timer_cooldown = $"../../RollTimerCooldown"

@export var idle_state:State
@export var run_state:State
@export var crouch_state:State
@export var jump_state:State
@export var roll_state:State

func on_enter():
	if can_roll:
		print("Actualmente en Walk")
		animation_player.play("Walk")
		can_roll = false
		roll_timer_cooldown.start()
		

func state_process(_delta: float) -> void:
	var is_running = Input.is_action_pressed("CorrerP1")
	var is_crouching = Input.is_action_just_pressed("AbajoP1")
	#var is_rolling = Input.is_action_just_pressed("AbajoP1")

	if not father.is_on_floor():
		next_state = jump_state
		print("[WALK]: Cambiando a jumping")
		return
	
	if is_zero_approx(father.velocity.x):
		if is_crouching:
			print("[WALK]: Cambiando a Croching")
			next_state = crouch_state
			return
		else:
			next_state = idle_state
			print("[WALK]: Cambiando a Idle")
			return
	
	if is_running:
		next_state = run_state
		print("[WALK]: Cambiando a Running")
		return
	else:
		if is_crouching and can_roll:
			next_state = roll_state
			print("[WALK]: Cambiando a Rolling")
			return

func _on_roll_timer_cooldown_timeout():
	if can_roll == false:
		can_roll = true
