---
goal: Explicar el uso de los nodos Selector y Sequence en LimboAI con ejemplos de juego y consejos de implementación.
version: 1
date_created: 2026-01-27
owner: Gemini CLI
status: 'Planned'
tags: [LimboAI, BehaviorTree, Selector, Sequence, Godot, IA]
---

# Introducción

Este plan tiene como objetivo clarificar el uso de los nodos de control `Selector` y `Sequence` en los árboles de comportamiento (BT) de LimboAI, proporcionando ejemplos concretos aplicables a la lógica de tu enemigo en el juego. También ofrecerá consejos y alternativas para situaciones comunes, como la gestión de animaciones y movimiento concurrentes.

![Estado: Planned](https://img.shields.io/badge/status-Planned-orange)

## 1. Requisitos y Restricciones
- **REQ-001**: El usuario debe comprender los principios fundamentales de los árboles de comportamiento.
- **REQ-002**: Las explicaciones deben ser relevantes para el contexto de un juego de Godot usando LimboAI.
- **REQ-003**: Se proporcionarán ejemplos útiles para el juego del usuario (ej. lógica de enemigo).
- **CON-001**: No podemos modificar directamente el código fuente de LimboAI para añadir funcionalidades.
- **CON-002**: Las soluciones deben ser implementables con las herramientas y nodos existentes en LimboAI (o mediante la creación de tareas personalizadas en GDScript).

## 2. Pasos de Implementación
### Fase 1: Conceptos Fundamentales de Selector y Sequence
- GOAL-001: Entender la diferencia y el uso básico de `Selector` y `Sequence`.

| Tarea | Descripción | Completado | Data |
|---|---|---|---|
| TASK-001 | Explicación detallada del nodo `Selector`. | ✅ | 2026-01-27 |
| TASK-002 | Ejemplo de uso de `Selector` para el enemigo. | ✅ | 2026-01-27 |
| TASK-003 | Explicación detallada del nodo `Sequence`. | ✅ | 2026-01-27 |
| TASK-004 | Ejemplo de uso de `Sequence` para el enemigo. | ✅ | 2026-01-27 |

#### 2.1. El Nodo `Selector` ( `?` o "OR" )
El `Selector` busca el primer hijo que tenga éxito. Ejecuta sus hijos de izquierda a derecha.
-   **Devuelve `SUCCESS`**: Tan pronto como uno de sus hijos devuelve `SUCCESS`. Detiene la ejecución de los demás hijos.
-   **Devuelve `FAILURE`**: Solo si *todos* sus hijos devuelven `FAILURE`.
-   **Devuelve `RUNNING`**: Si alguno de sus hijos devuelve `RUNNING`.

**Ejemplo Relevante para tu Juego (Enemigo):**
Imagina que tu enemigo necesita decidir su comportamiento principal.
```
- Selector (Decidir Acción Principal del Enemigo)
	- Sequence (Atacar al Jugador)
		- Condition (¿Jugador en rango de ataque?)
		- Action (Realizar ataque)
	- Sequence (Perseguir al Jugador)
		- Condition (¿Jugador visible pero fuera de rango?)
		- Action (Moverse hacia el Jugador)
	- Sequence (Patrullar Área)
		- Action (Moverse a punto de patrulla 1)
		- Action (Esperar un tiempo)
		- Action (Moverse a punto de patrulla 2)
	- Action (Reproducir Animación Idle)
```
En este ejemplo:
1.  El enemigo intentará primero "Atacar al Jugador". Si el jugador está en rango y el ataque se realiza con éxito, el `Selector` termina con éxito.
2.  Si "Atacar al Jugador" falla (ej. el jugador no está en rango), el `Selector` intentará "Perseguir al Jugador". Si lo logra, el `Selector` termina con éxito.
3.  Si ambos anteriores fallan, el enemigo pasará a "Patrullar Área".
4.  Si incluso patrullar falla o no tiene puntos de patrulla definidos, por último, simplemente reproducirá una animación de "Idle".

#### 2.2. El Nodo `Sequence` ( `->` o "AND" )
El `Sequence` busca que *todos* sus hijos tengan éxito en orden. Ejecuta sus hijos de izquierda a derecha.
-   **Devuelve `SUCCESS`**: Solo si *todos* sus hijos devuelven `SUCCESS`.
-   **Devuelve `FAILURE`**: Tan pronto como uno de sus hijos devuelve `FAILURE`. Detiene la ejecución de los demás hijos.
-   **Devuelve `RUNNING`**: Si alguno de sus hijos devuelve `RUNNING`.

**Ejemplo Relevante para tu Juego (Enemigo):**
Imagina que tu enemigo necesita preparar un ataque especial.
```
- Sequence (Preparar y Lanzar Ataque Especial)
	- Condition (¿Cooldown de ataque especial listo?)
	- Action (Reproducir Animación de Carga)
	- Action (Esperar Carga - Task customizada para esperar la duración de la animación)
	- Action (Lanzar Proyectil/Habilidad)
	- Action (Poner Cooldown de ataque especial)
```
En este ejemplo:
1.  Si el cooldown no está listo, toda la `Sequence` falla y el enemigo no intenta el ataque.
2.  Si el cooldown está listo, se reproduce la animación de carga. Si esa tarea falla o no termina, la `Sequence` falla.
3.  Una vez cargado, se lanza la habilidad.
4.  Finalmente, se activa el cooldown. Si cualquiera de estos pasos falla, el ataque especial no se completa y la `Sequence` falla.

### Fase 2: Escenario "Animación y Movimiento Concurrente"
- GOAL-002: Comprender cómo gestionar animación y movimiento al mismo tiempo.

| Tarea | Descripción | Completado | Data |
|---|---|---|---|
| TASK-005 | Explicar por qué `Sequence` no es ideal para concurrentes. | ✅ | 2026-01-27 |
| TASK-006 | Solución 1: Gestión de animación dentro de tarea de movimiento. | ✅ | 2026-01-27 |
| TASK-007 | Solución 2: Uso de nodo `Parallel` (si disponible en LimboAI). | ✅ | 2026-01-27 |

#### 2.3. ¿Por qué `Sequence` no es ideal para "Animación y Movimiento Concurrente"?
Como se explicó anteriormente, un `Sequence` ejecuta tareas secuencialmente. Si quieres que tu enemigo "reproduzca la animación de caminar" Y "se mueva hacia el jugador" AL MISMO TIEMPO, una `Sequence` no lo logrará porque ejecutaría una acción *después* de la otra.

#### 2.4. Solución 1: Gestión de Animación dentro de la Tarea de Movimiento (Recomendado)
La forma más común y robusta es que la tarea que maneja el movimiento (ej. `BTMoverHaciaJugador`, una tarea personalizada) también se encargue de gestionar la animación del `AnimatedSprite2D` del enemigo.

**Implementación Sugerida:**
1.  **Crea una Tarea Personalizada (GDScript):** Define una nueva tarea de LimboAI en GDScript, por ejemplo, `Task_MoveAndAnimate.gd`.
2.  **Lógica de la Tarea:**
	*   En el método `_enter()`: Establece la animación a "Walk" en el `AnimatedSprite2D` del enemigo.
	*   En el método `_tick()`: Implementa la lógica de movimiento (hacia el jugador o un punto). Mientras el enemigo se mueve, devuelve `RUNNING`.
	*   Cuando el enemigo llega a su destino o deja de moverse: Devuelve `SUCCESS` o `FAILURE` y, opcionalmente, cambia la animación a "Idle" o notifica al nodo padre para que lo haga.
3.  **Uso en el Árbol de Comportamiento:**
	```
	- Selector (Comportamiento General del Enemigo)
		- Sequence (Perseguir y Atacar)
			- Condition (¿Jugador Visible?)
			- Task_MoveAndAnimate (Moverse hacia el Jugador) // Esta tarea ya anima y mueve
			- Action (Atacar)
		- Action (Reproducir Animación Idle)
	```

#### 2.5. Solución 2: Uso de Nodo `Parallel` (si disponible en LimboAI)
Si LimboAI ofrece un nodo `Parallel`, este es explícitamente diseñado para ejecutar múltiples tareas simultáneamente.

**Implementación (Conceptual si `Parallel` existe):**
```
- Parallel (Perseguir con Animación)
	- Task (Moverse Hacia el Jugador) // Solo la lógica de movimiento
	- Task (Reproducir Animación Caminar Continuamente) // Una tarea que asegura que la animación "Walk" se mantenga
```
Deberías consultar la documentación de LimboAI para ver si existe un nodo `Parallel` y cómo configurarlo (especialmente sus políticas de éxito y fallo).

### Fase 3: Consejos Generales de Implementación para LimboAI
- GOAL-003: Proporcionar consejos para un buen diseño de árboles de comportamiento.

| Tarea | Descripción | Completado | Data |
|---|---|---|---|
| TASK-008 | Consejos sobre diseño de tareas atómicas. | ✅ | 2026-01-27 |
| TASK-009 | Consejos sobre el uso del `Blackboard`. | ✅ | 2026-01-27 |
| TASK-010 | Consejos sobre debugging. | ✅ | 2026-01-27 |
| TASK-011 | Consejos sobre la estructura general del BT. | ✅ | 2026-01-27 |

#### 2.6. Diseño de Tareas Atómicas y Reutilizables
-   **Atómicas:** Cada tarea debe hacer una única cosa bien definida (ej. "Mover a X", "Comprobar línea de visión", "Atacar"). Esto facilita la depuración y la reutilización.
-   **Reutilizables:** Siempre que sea posible, diseña tareas personalizadas que puedan ser usadas en diferentes árboles de comportamiento o para diferentes enemigos, quizás con parámetros configurables.

#### 2.7. Uso del `Blackboard`
-   El `Blackboard` es esencial para que las tareas compartan información (ej. posición del jugador, estado de salud, objetivo actual).
-   Define un `BlackboardPlan` claro para cada tipo de enemigo o comportamiento para asegurar que las variables estén bien definidas y tipadas.

#### 2.8. Consejos de Depuración (Debugging)
-   **Visualizador de LimboAI:** Si existe, utilízalo. Es la herramienta más potente para ver el flujo del BT en tiempo real.
-   **`print()` Statements:** Añade `print()` en los métodos `_enter()`, `_tick()`, `_success()` y `_failure()` de tus tareas personalizadas para seguir el flujo en la consola de Godot.
-   **Inspección del `BTPlayer`:** Durante la ejecución, inspecciona el nodo `BTPlayer` en el Árbol de Escena Remota de Godot para ver el estado actual del árbol y el `blackboard`.

#### 2.9. Estructura General del Árbol de Comportamiento
-   **Modularidad:** Divide comportamientos complejos en sub-árboles (sub-BTs) que pueden ser incluidos en otros árboles. Esto mejora la legibilidad y la gestión.
-   **Claridad:** Mantén el árbol lo más legible posible. Usa nombres descriptivos para las tareas y las ramas. Evita árboles demasiado anidados si puedes simplificarlos.
-   **Jerarquía:** Los nodos más arriba en el árbol deben representar decisiones de alto nivel (ej. "Qué hacer"), y los nodos más abajo, los detalles de implementación (ej. "Cómo hacerlo").

## 3. Alternativas
- **ALT-001**: **Creación de Tareas Personalizadas (GDScript)**: Si LimboAI no tiene una tarea específica para una funcionalidad que necesitas, puedes crear la tuya propia en GDScript. Esto requiere extender la clase base de tarea de LimboAI y definir su lógica. Esto te da control total sobre cómo interactuar con los nodos de Godot, como `AnimatedSprite2D`.

## 4. Dependencias
- **DEP-001**: Plugin LimboAI para Godot.
- **DEP-002**: Conocimiento básico de GDScript para tareas personalizadas.

## 5. Ficheiros
- **FILE-001**: `design-bt-control-nodes-1.md` (este plan).
- **FILE-002**: `enemy.tscn` (escena del enemigo para aplicar los ejemplos).
- **FILE-003**: `01_Enemy_Simple_Animations.tres` (árbol de comportamiento del enemigo).
- **FILE-004**: Archivos de tareas personalizadas en GDScript (ej. `Task_MoveAndAnimate.gd`, si se implementan).

## 6. Probas (Testing)
- **TEST-001**: Implementar los ejemplos sugeridos en el árbol de comportamiento del enemigo.
- **TEST-002**: Ejecutar el juego y observar el comportamiento del enemigo para verificar que se ajusta a lo esperado.
- **TEST-003**: Usar `print()` statements y/o el visualizador de LimboAI (si existe) para seguir el flujo de ejecución del árbol.

## 7. Riscos e Asuncións
- **RISK-001**: La curva de aprendizaje de los árboles de comportamiento puede ser inicialmente empinada.
- **ASSUMPTION-001**: El usuario tiene acceso y puede modificar los archivos de la escena (`.tscn`), scripts (`.gd`) y árboles de comportamiento (`.tres`).
- **ASSUMPTION-002**: LimboAI sigue las convenciones estándar de los árboles de comportamiento en cuanto a `Selector` y `Sequence`.

## 8. Especificacións Relacionadas / Lecturas Adicionais
- Documentación oficial de LimboAI (URL específica, si se conoce, o general del plugin).
- Tutoriales sobre árboles de comportamiento en Godot.
