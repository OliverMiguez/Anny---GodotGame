# Proyecto Final - Juego de Plataformas Shooter Roguelike

## Descripción General

Este proyecto es un **videojuego de plataformas tipo shooter** con un sistema de **mejoras progresivas al estilo roguelike**.  
El jugador encarna a un ex mafioso que intenta rehacer su vida... hasta que su pasado decide volver con una pistola en la mano.

El juego combina **acción rápida**, **movimiento ágil** y **una evolución constante del personaje**, permitiendo que cada partida sea distinta y que el jugador sienta que siempre puede hacerlo (un poco) mejor.

---

## Historia

No todos los que abandonan la mafia lo hacen con una carta de recomendación.  
Nuestro protagonista, antiguo miembro de una de las mayores organizaciones criminales de la ciudad, decide retirarse tras el nacimiento de su hija.  
Sin embargo, su antiguo jefe, un hombre poco dado a confiar, teme que hable más de la cuenta.  
¿Solución del jefe? Intentar eliminarlo.  
¿Resultado? Digamos que no le sale del todo bien.

Ese intento fallido sirve como tutorial del juego, y marca el inicio de la verdadera trama:  
la esposa y la recién nacida del protagonista son secuestradas, forzándolo a regresar a un mundo que creía haber dejado atrás.

A partir de ahí, la historia mezcla acción, drama, algo de redención y una buena dosis de comentarios sarcásticos del protagonista, que ya está demasiado cansado para tomarse en serio su propia desgracia.

---

## Jugabilidad

El juego apuesta por un **combate ágil y directo**, donde la movilidad y la puntería son tan importantes como elegir las mejoras adecuadas.

**Características principales:**
- Combate dinámico con armas de corto y largo alcance.  
- Sistema de progresión **roguelike**, donde las mejoras obtenidas cambian radicalmente cada partida.  
- Escenarios con rutas alternativas, secretos y elementos ocultos para los más curiosos.  
- Un estilo narrativo que mezcla acción, ironía y caos en dosis equilibradas (o casi).

Cada nivel busca ofrecer nuevos desafíos, enemigos más ingeniosos y la posibilidad de crear combinaciones de habilidades que mantengan al jugador siempre en tensión.

---

## Narrativa y tono

Aunque la trama tiene un trasfondo oscuro, el tono se mantiene **ligeramente cómico y autoparódico**.  
El protagonista comenta los sucesos con el tipo de humor que solo alguien que ha esquivado demasiadas balas puede tener.  

A lo largo de la historia, el jugador podrá encontrar **referencias, pequeños secretos y situaciones absurdas** que aportan un toque de frescura entre tanta pólvora.

Los **finales** variarán según las acciones del jugador. Algunos serán heroicos, otros trágicos... y otros simplemente extraños.  
Pero todos dejarán la sensación de que, de una forma u otra, todo esto tenía que acabar así.

---

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

---

## Objetivos del Proyecto

- Desarrollar un videojuego completo aplicando conocimientos de **programación, diseño de niveles, IA y sistemas de progresión**.  
- Diseñar una **narrativa interactiva** que combine drama y humor.  
- Implementar un sistema de **mejoras y rejugabilidad** inspirado en los roguelike clásicos.  
- Ofrecer una experiencia que mantenga al jugador entre la tensión, la risa y el "solo una partida más".

---

## Estado Actual

El proyecto se encuentra en desarrollo activo.  
Actualmente se están implementando:
- Las mecánicas principales de movimiento y combate.  
- El sistema de progresión y mejoras.  
- Los primeros niveles jugables.  
- El guion y los eventos secundarios (algunos más evidentes que otros).  

Sí, hay secretos. No, no todos deberían encontrarse en la primera partida.

---

## Créditos

Proyecto desarrollado por [Tu Nombre] como trabajo de fin de ciclo.  
Diseño, programación, narrativa y testeo intensivo de explosiones cortesía del autor.

---

## Notas Finales

El objetivo de este proyecto no es solo crear un juego funcional, sino también contar una historia con personalidad y un estilo propio.  
Un juego que se toma en serio sus mecánicas, pero no tanto a sí mismo.

