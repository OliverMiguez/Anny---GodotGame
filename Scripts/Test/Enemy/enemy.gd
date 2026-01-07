extends CharacterBody2D
class_name Enemy

const GRAVITY_VALUE = 980

@export var enemy_life = 100 
@onready var label_life = $LabelLife

func _ready():
	show_life()
	
func _physics_process(delta):
	show_life()
	
	if not is_on_floor():
		gravity(delta)
	
	move_and_slide()
	
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)

	# Cuando recibe daño o una bala colisiona
func _on_damage_area_body_entered(body):
	if body.is_in_group("Balas"):
		receive_damage()

func receive_damage():
	enemy_life -= 10
	label_life.text = str(enemy_life)
	if enemy_life <= 0:
		death()
		
func death():
	# OJO EN EL MAPA TENEMOS QUE IDENTIFICAR CUANTOS ENEMIGOS HAY PARA CAMBIAR DE RONDA
	print("Enemigo muerto, enviado señal de victoria")
	queue_free()
	
func show_life():
	label_life.text = str(enemy_life)
