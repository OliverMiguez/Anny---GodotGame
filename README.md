# Anny - Juego de Godot

Este es un juego de plataformas en 2D creado con el motor Godot.

## Estructura del Proyecto

### Escenas

*   **`Scenes/Enemys/Test/enemy.tscn`**: La escena principal para el personaje enemigo. Incluye las animaciones del enemigo, la forma de colisión y un hitbox para detectar el daño.
*   **`Scenes/IU/InitialMenu/initial_menu.tscn`**: El menú inicial del juego. Tiene botones para jugar, opciones y salir. También tiene un menú emergente para seleccionar modos de juego.
*   **`Scenes/MainCharacter/main_character.tscn`**: La escena principal para el personaje del jugador. Incluye las animaciones del personaje, la forma de colisión y una máquina de estados para gestionar los estados del personaje.
*   **`Scenes/MainCharacter/Ammo/ammo.tscn`**: La escena para la munición que dispara el personaje principal. Tiene un sprite y una forma de colisión para detectar cuándo golpea a un enemigo.
*   **`Scenes/Objects/Box/box.tscn`**: Un objeto de caja que se puede colocar en el mundo del juego. Es un cuerpo rígido con un sprite y una forma de colisión.
*   **`Scenes/Test/mapa_prueba.tscn`**: Un mapa de prueba para el juego. Incluye el personaje principal, enemigos y algunos objetos. También tiene un script para gestionar las rondas del juego.

### Scripts

*   **`Scripts/GeneralStates/Util/State.gd`**: Un estado genérico para la máquina de estados. Tiene funciones `on_enter` y `on_exit` que se llaman cuando se entra y se sale del estado.
*   **`Scripts/GeneralStates/Util/State_Machine.gd`**: La máquina de estados que gestiona los estados de los personajes. Tiene una variable `current_state` y una función `change_state` para hacer la transición entre estados.
*   **`Scripts/Globals/RoundManager.gd`**: Gestiona las rondas del juego. Tiene una variable `player_wins_round` y una señal `cambio_ronda` que se emite cuando la ronda cambia.
*   **`Scripts/MainCharacter/main_character.gd`**: El script principal para el personaje del jugador. Maneja el movimiento, el salto y el disparo del personaje.
*   **`Scripts/MainCharacter/Ammo/ammo.gd`**: El script para la munición. Maneja el movimiento de la munición.
*   **`Scripts/MainCharacter/Ammo/ammo2.gd`**: Otro script para la munición. Maneja el movimiento de la munición y la elimina cuando colisiona con un enemigo.
*   **`Scripts/MainCharacter/States/CrouchingState.gd`**: El estado de agacharse para el personaje principal.
*   **`Scripts/MainCharacter/States/IdleState.gd`**: El estado de inactividad para el personaje principal.
*   **`Scripts/MainCharacter/States/JumpingState.gd`**: El estado de salto para el personaje principal.
*   **`Scripts/MainCharacter/States/PlanchaState.gd`**: El estado de "plancha" para el personaje principal.
*   **`Scripts/MainCharacter/States/RollingState.gd`**: El estado de rodar para el personaje principal.
*   **`Scripts/MainCharacter/States/RunningState.gd`**: El estado de correr para el personaje principal.
*   **`Scripts/MainCharacter/States/ShootingState.gd`**: El estado de disparo para el personaje principal.
*   **`Scripts/MainCharacter/States/WalkingState.gd`**: El estado de caminar para el personaje principal.
*   **`Scripts/Test/mapa_prueba.gd`**: El script para el mapa de prueba. Maneja la aparición de enemigos y objetos, y gestiona las rondas del juego.
*   **`Scripts/Test/Enemy/enemy.gd`**: El script para el personaje enemigo. Maneja la vida y el daño del enemigo.
*   **`Scripts/Test/Enemy/hit_box.gd`**: El script para el hitbox del enemigo. Detecta cuando el enemigo es golpeado por la munición.
*   **`Scripts/UI/initial_menu/initial_menu.gd`**: El script para el menú inicial. Maneja los clics de los botones y el menú emergente.
