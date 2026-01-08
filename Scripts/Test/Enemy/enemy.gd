extends CharacterBody2D
class_name Enemy

const GRAVITY_VALUE = 980

@export var enemy_life = 100 
@onready var label_life = $LabelLife


func _ready():
	print("Enemigo presente")
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
	queue_free()
	# enviar señal al mapa para cambiar de rondas
	RoundManager.player_wins_round = true # Como el enemigo perdió se envia un valor true
	RoundManager.emit_signal("cambio_ronda",true) # 1º nombre de la señal del singelton 2º el valor a enviar
	print("Señal emitida")
func show_life():
	label_life.text = str(enemy_life)


func _on_hit_box_area_entered(area):
	if area.is_in_group("Balas"):
		print("Bala recibida correctamente por el enemigo !!!")
		print("Modificando la vida del enemigo tras recibir el disparo...")
		receive_damage()
