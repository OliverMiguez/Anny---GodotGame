# Plan de Desarrollo: IA Enemiga estilo "Superfighters"

## Introducción

El objetivo es desarrollar una inteligencia artificial (IA) para un enemigo 2D que emule el comportamiento ágil y reactivo de los personajes en el juego "Superfighters". La IA deberá ser capaz de navegar dinámicamente por un escenario con plataformas, perseguir al jugador de forma efectiva y utilizar un repertorio de movimientos avanzados como correr, saltar obstáculos y realizar un salto en plancha.

Este plan está diseñado para ser implementado en Godot, utilizando el complemento **LimboAI** para la lógica de árbol de comportamiento (Behavior Tree), ya que está presente en el proyecto.

---

## Paso 1: Configuración de la Escena del Enemigo y Sensores

Antes de escribir la lógica, el nodo del enemigo necesita "sentir" su entorno. Usaremos una combinación de `Area2D` y `RayCast2D` para esto.

**Estructura de Nodos Sugerida:**
```
- Enemy (KinematicBody2D)
  |- CollisionShape2D
  |- Sprite / AnimationPlayer
  |- VisionRange (Area2D)
  |  └- VisionShape (CollisionShape2D)
  |- LineOfSight (RayCast2D)
  |- WallDetector (RayCast2D)
  |- LedgeDetector (RayCast2D)
  |- ObstacleJumpDetector (RayCast2D)
  |- BTPlayer (LimboAI's BTPlayer)
```

**Acciones Concretas:**

1.  **Nodo Principal:** Usa un `KinematicBody2D` como base para el enemigo para poder usar `move_and_slide`.
2.  **Rango de Visión (`VisionRange`):**
    *   Añade un `Area2D` con un `CollisionShape2D` (un círculo o rectángulo grande).
    *   Este nodo detectará cuándo el jugador (u otro cuerpo) entra en el "rango de aggro" del enemigo. Conecta sus señales `body_entered` y `body_exited` para saber si el jugador está cerca.
3.  **Línea de Visión (`LineOfSight`):**
    *   Añade un `RayCast2D`. Configúralo para que apunte hacia la dirección en la que mira el enemigo.
    *   En el `_physics_process`, haz que este RayCast apunte constantemente hacia la posición del jugador (`look_at(player.global_position)`).
    *   Actívalo (`force_raycast_update()`) y comprueba si colisiona con algo (`get_collider()`). Si el primer objeto que golpea no es el jugador, significa que hay una pared en medio.
4.  **Detectores de Entorno (RayCasts):**
    *   **`WallDetector`:** Un `RayCast2D` corto apuntando hacia adelante. Se usará para detectar paredes y obstáculos a la altura del enemigo.
    *   **`ObstacleJumpDetector`:** Similar al `WallDetector`, pero colocado más arriba. Si `WallDetector` choca pero este no, significa que el obstáculo es bajo y se puede saltar.
    *   **`LedgeDetector`:** Un `RayCast2D` apuntando hacia abajo y ligeramente hacia adelante. Si este rayo no detecta suelo, significa que hay un precipicio o el final de una plataforma.

---

## Paso 2: Creación de Tareas de Comportamiento en LimboAI

Con LimboAI, en lugar de una máquina de estados monolítica, crearemos pequeñas "Tareas" (scripts de GDScript que heredan de `BTTask`) que el árbol de comportamiento podrá ejecutar.

**Ubicación:** Crea una carpeta `AI/tasks` para guardar estos scripts.

**Tareas a Crear:**

1.  **`CheckPlayerInVisionRange.gd`:**
    *   **Función:** Devuelve `SUCCESS` si el jugador está dentro del `Area2D` de visión, `FAILURE` si no.
    *   **Lógica:** Guardará una referencia al jugador en la "pizarra" (el `blackboard` de LimboAI) si lo encuentra.

2.  **`CheckPlayerInLineOfSight.gd`:**
    *   **Función:** Devuelve `SUCCESS` si el `RayCast2D` (`LineOfSight`) golpea directamente al jugador.
    *   **Lógica:** Usa la información del Paso 1.3.

3.  **`ChasePlayer.gd`:**
    *   **Función:** Mueve al enemigo hacia la posición del jugador.
    *   **Lógica:**
        *   Obtiene la posición del jugador desde la pizarra.
        *   Calcula el vector de dirección: `direction = (player_pos - enemy.global_position).normalized()`.
        *   Aplica movimiento: `enemy.move_and_slide(direction * enemy_speed)`.
        *   Siempre debe devolver `RUNNING`, ya que la persecución es una acción continua.

4.  **`IsObstacleAhead.gd`:**
    *   **Función:** Devuelve `SUCCESS` si `WallDetector` colisiona y `ObstacleJumpDetector` no.
    *   **Lógica:** Simple `is_colliding()` en los RayCasts correspondientes.

5.  **`Jump.gd`:**
    *   **Función:** Realiza un salto.
    *   **Lógica:** Aplica una velocidad vertical al enemigo (p.ej., `velocity.y = JUMP_FORCE`). Debe devolver `SUCCESS` tras ejecutarse una vez.

6.  **`IsLedgeAhead.gd`:**
    *   **Función:** Devuelve `SUCCESS` si `LedgeDetector` *no* está colisionando con el suelo.

7.  **`Stop.gd`:**
    *   **Función:** Detiene el movimiento del enemigo.
    *   **Lógica:** Pone la velocidad horizontal a cero.

8.  **`Dive.gd`:**
    *   **Función:** Ejecuta un salto en plancha.
    *   **Lógica:** Esta es más compleja.
        *   Cambia la `CollisionShape2D` del enemigo por una más corta y ancha (para el estado de plancha).
        *   Aplica una fuerza horizontal fuerte y una pequeña fuerza vertical.
        *   Usa un `Timer` o el propio `delta` en la función `_execute` para controlar la duración de la plancha.
        *   Cuando termine, restaura la `CollisionShape2D` original y devuelve `SUCCESS`. Mientras dure, debe devolver `RUNNING`.

---

## Paso 3: Diseño del Árbol de Comportamiento (Behavior Tree)

Ahora, en el editor de LimboAI, ensambla las tareas que creaste para definir la lógica del enemigo.

**Ubicación:** `AI/trees/SuperfighterEnemy.tres`

**Estructura del Árbol:**

```
- (Selector) ROOT
  |- (Sequence) Engage Player
  |  |- (CheckPlayerInVisionRange) ¿Veo al jugador?
  |  |- (CheckPlayerInLineOfSight) ¿Tengo línea de visión directa?
  |  |- (Selector) React and Move
  |     |- (Sequence) Handle Ledge
  |     |  |- (IsLedgeAhead) ¿Hay un precipicio?
  |     |  |- (Stop) ¡Frena!
  |     |- (Sequence) Jump Over Obstacle
  |     |  |- (IsObstacleAhead) ¿Hay un obstáculo bajo?
  |     |  |- (Jump) ¡Salta!
  |     |- (Sequence) Attack with Dive (Ejemplo)
  |     |  |- (CheckDistanceToPlayer) ¿Está a distancia de plancha?
  |     |  |- (Dive) ¡Al ataque!
  |     |- (ChasePlayer) Persecución normal
  |
  |- (Sequence) Patrol / Idle (Comportamiento por defecto)
     |- (Wait) Espera un poco
     |- (TurnAround) Gira
     |- (Walk) Camina un poco
```

**Explicación de la Lógica:**

*   El `Selector` raíz intenta ejecutar a sus hijos de izquierda a derecha.
*   **`Engage Player` (Sequence):** Solo se ejecuta si *todas* sus condiciones son ciertas.
    *   Primero comprueba si el jugador está en el rango de visión y si hay línea directa.
    *   Si es así, pasa al `Selector` `React and Move`. Este selector elegirá la *primera* acción que tenga éxito.
    *   **Prioridad 1: Precipicios.** Lo más importante es no caerse. Si hay un borde, se detiene.
    *   **Prioridad 2: Obstáculos.** Si no hay un precipicio pero sí un obstáculo, intenta saltarlo.
    *   **Prioridad 3: Ataque.** Si las condiciones son adecuadas (ej. distancia), realiza un ataque especial como la plancha.
    *   **Acción por defecto:** Si nada de lo anterior se cumple, simplemente persigue al jugador (`ChasePlayer`).
*   **`Patrol / Idle` (Sequence):** Si la secuencia `Engage Player` falla (porque no ve al jugador), la IA ejecutará este comportamiento por defecto, que podría ser patrullar una zona o simplemente esperar.

---

## Paso 4: Refinamiento y "Jugo"

Una IA predecible es una IA aburrida. Añade pequeños detalles para hacerla más creíble.

1.  **Tiempos de Reacción:** En las tareas `Check`, no devuelvas `SUCCESS` inmediatamente. Usa un `Timer` corto y aleatorio (`rand_range`) para simular que la IA "piensa" por un instante.
2.  **Cooldowns:** Usa la pizarra (`blackboard`) de LimboAI para guardar marcas de tiempo. Antes de ejecutar la tarea `Dive` o `Jump`, comprueba si ha pasado suficiente tiempo desde la última vez.
3.  **Animaciones:** Usa el nodo `AnimationPlayer`. Desde tus tareas (`Jump.gd`, `Dive.gd`, etc.), llama a `enemy.animation_player.play("jump_animation")`. La tarea no debería devolver `SUCCESS` hasta que la animación termine (`yield(enemy.animation_player, "animation_finished")`).
4.  **Incertidumbre:** En lugar de perseguir siempre la posición exacta del jugador, añade un pequeño `Vector2` aleatorio al objetivo. Esto puede crear un movimiento de evasión o persecución menos directo y más interesante.

Siguiendo estos pasos, tendrás una base sólida para una IA compleja y entretenida, sobre la cual podrás seguir construyendo comportamientos aún más avanzados.
