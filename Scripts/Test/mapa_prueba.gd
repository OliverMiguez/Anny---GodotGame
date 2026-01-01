extends Node2D
@onready var prueba_musica = $MusicTest

# Markers
@onready var marker_1_left_down: Marker2D = $Doors/Markers/Marker1LeftDown
@onready var marker_2_left_up: Marker2D = $Doors/Markers/Marker2LeftUp
@onready var marker_3_right_up: Marker2D = $Doors/Markers/Marker3RightUp
@onready var marker_4_right_down: Marker2D = $Doors/Markers/Marker4RightDown

func _ready():
	prueba_musica.play()
	print("Prueba: Entro en el mapa")

func _on_prueba_musica_finished():
	prueba_musica.play()

## Puertas de la izquierda
# Puerta de abajo

func _on_left_door_down_body_entered(body: Node2D) -> void:
	print("Prueba: Algo entro en el area")
	if body is MainCharacter:
		print("ENTRO EL MAINCHARACTER")
		if Input.is_action_just_pressed("Space"):
			MainCharacter.position = marker_2_left_up.position

func _on_left_door_down_body_exited(body: Node2D) -> void:
	print("Prueba: Algo salió del area")
	if body is MainCharacter:
		print("SALIO EL MAINCHARACTER")
