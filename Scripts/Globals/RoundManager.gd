# Hola pepsicola
extends Node

# Variable para registrar si todos los enemigos han muerto
var player_wins_round = false

# Señal con la que enviamos al mapa un valor para revisar si tiene que cambiar de ronda
signal cambio_ronda(valor)


func change_round():
	if player_wins_round == false:
		player_wins_round = true
		cambio_ronda.emit(player_wins_round)
		player_wins_round = false
		
#PRUEBA CON GEMINICLI
#PRUEBA CON COMMITS