extends Node2D
class_name Ammo

@export var ammo_movement_speed = 900 # Velocidad a la que se desplazará
var direction = Vector2.RIGHT # Por defecto, se sobrescribe al disparar

func _ready():
	add_to_group("Balas")

func _physics_process(delta):
	position += direction * ammo_movement_speed * delta # Mueve la bala dependiendo del movimiento

func ammo():
	pass

## Elimina la bala cuando colisiona con el enemigo
func _on_body_entered(body):
	if body.is_in_group("Enemigos"):
		self.queue_free()
