extends Node

# Variable para registrar si todos los enemigos han muerto (deprecado, de momento no usar)
var player_wins_round = false # 

# Cuenta los enemigos que hay (debug)
var total_enemy = 0 

var id_enemy #Guada el id del enemigo

# Señal que se envia cuando muere un enemigo
signal enemigo_murio(id_enemy)

# Señal con la que enviamos al mapa un valor para revisar si tiene que cambiar de ronda(en desuso de momento)
signal cambio_ronda(valor)

## Permitir el cambio de ronda (posiblemente se deje de usar)
func change_round():
	if player_wins_round == false:
		player_wins_round = true
		cambio_ronda.emit(player_wins_round)
		player_wins_round = false
		
## Envia una señal de que un enemigo en especifico a muerto
func enemy_death():
	enemigo_murio.emit(id_enemy)
	
