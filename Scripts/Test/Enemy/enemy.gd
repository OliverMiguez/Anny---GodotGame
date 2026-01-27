extends CharacterBody2D
class_name Enemy

const GRAVITY_VALUE = 980

@export var enemy_life = 100 
@onready var label_life = $LabelLife
@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _ready():
	show_life()
	
func _physics_process(delta):
	show_life() #esto funciona bien
	if not is_on_floor():
		gravity(delta)
	
	move_and_slide()
	
func gravity(delta):
	velocity.y = velocity.y +(GRAVITY_VALUE * delta)

func receive_damage():
	enemy_life -= 10
	label_life.text = str(enemy_life)
	if enemy_life <= 0: 
		death()
		
func death():
	# OJO EN EL MAPA TENEMOS QUE IDENTIFICAR CUANTOS ENEMIGOS HAY PARA CAMBIAR DE RONDA
	print("Enemigo muerto, enviado señal de victoria")
	# Deprecada, la dejo de momento para arreglar un bug
	#RoundManager.change_round() # Envia una señal cuando los enemigos mueran para cambiar de ronda en el mapa
	RoundManager.id_enemy = self # Envia el id del enemigo
	RoundManager.enemy_death() # Señal que se activa cuando muere el enemigo
	
func show_life():
	label_life.text = str(enemy_life)


func _on_hit_box_area_entered(area):
	if area.is_in_group("Balas"):
		print("Bala recibida correctamente por el enemigo !!!")
		receive_damage()

## Área de detección del enemigo
# Cuando el player entra en el área de detección
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("MainCharacter"):
		print("El player entró en el área del enemigo")
# Cuando el player sale del area de detección
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("MainCharacter"):
		print("El player salió del área de detección del player")
