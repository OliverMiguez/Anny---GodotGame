extends Node2D
@onready var prueba_musica = $MusicTest
func _ready():
	prueba_musica.play()

func _on_prueba_musica_finished():
	prueba_musica.play()
