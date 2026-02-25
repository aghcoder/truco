# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Truco Uruguayo** - A mobile score-tracking app for the traditional South American card game Truco. Built as a single-page app packaged as an Android APK via Capacitor.

- App ID: `com.truco.uruguayo`
- All app code lives in a single file: `index.html` (HTML + embedded CSS + embedded JS)
- No build step required to run in a browser — just open `index.html`

## Commands

```bash
npm install                  # Install Capacitor dependencies
npx cap add android          # Add Android platform (first time only)
npx cap sync android         # Sync web files to native Android project
npx cap open android         # Open in Android Studio to build APK
npx cap run android          # Run on connected Android device
```

To build the APK: after `npx cap open android`, use **Build → Build APK(s)** in Android Studio. Output: `android/app/build/outputs/apk/debug/app-debug.apk`.

## Architecture

The entire application is in `index.html` with three sections:

**State (JS global object):**
```js
let state = {
    teams: [
        { name: 'Nosotros', points: 0, malas: [false, false, false] },
        { name: 'Ellos', points: 0, malas: [false, false, false] }
    ]
}
```
State is persisted to `localStorage` on every change via `saveState()` / `loadState()`.

**Core functions:**
- `addPoint(teamIdx)` / `undoPoint(teamIdx)` — mutate state and re-render
- `renderScores(teamIdx)` — generates SVG stroke marks (palitos): groups of 4 verticals + 1 diagonal at point 5 (the "morcilla")
- `editName(teamIdx)` — inline team name editing
- `toggleMala(teamIdx, dotIdx)` — toggle malas indicators (3 per team)
- `showWinner(teamIdx)` / `newGame()` — winner overlay and game reset

**Visual design constants:**
- Green felt: `#0a4028`, gold: `#d4af37`, blue ink (strokes): `#2c5aa0`, red malas: `#c41e3a`
- Fonts: Rye (headings), Crimson Pro (body) — loaded from Google Fonts
- SVG `feTurbulence` filter gives strokes a hand-drawn texture
- Win condition: 30 points

## Planned Features (from README)

- [ ] Custom app icon
- [ ] Splash screen customization
- [ ] Match history
- [ ] Light/dark mode
- [ ] Sound effects on point addition
- [ ] Win animations




-------------------------------------------------------------
# Instrucciones de Git y Gestión de Ramas

## Flujo de trabajo Git

### Repositorio
- **Remote:** https://github.com/aghcoder/unami

### Estructura de ramas

| Rama      | Uso                              | Se modifica desde |
|-----------|----------------------------------|-------------------|
| `develop` | Desarrollo activo ← RAMA DE TRABAJO | Directo       |
| `stage`   | UAT / pre-producción             | Merge de develop  |
| `main`    | Producción (no tocar sin avisar) | Solo cuando se indique |


## Reglas generales
- Todos los cambios de código se gestionan en el repositorio de GitHub ya configurado
- NUNCA hacer cambios directamente en `main` o `stage`
- Antes de cualquier cambio, verificar que estás en la rama correcta con `git branch`

## Flujo de trabajo estándar

### UNICAMENTE cuando diga subir a develop o similar mandar el codigo nuevo y los cambios sino mantener en localhost
1. Posicionarse en `develop`: `git checkout develop`
2. Hacer pull para tener la última versión: `git pull origin develop`
3. Aplicar los cambios solicitados
4. Hacer commit con mensaje descriptivo: `git commit -m "descripción del cambio"`
5. Hacer push a develop: `git push origin develop`

## Activación de pase a Stage / UAT
Cuando el usuario diga alguna de estas frases (o similares):
- "mandá a UAT"
- "pasá a stage"  
- "pase a UAT"
- "deployá a stage"
- "subí a UAT"
- "promové a stage"
- "listo para stage"

### Ejecutar este flujo:
```bash
# 1. Asegurarse que develop está actualizado
git checkout develop
git pull origin develop

# 2. Cambiar a stage
git checkout stage

# 3. Pull de stage por si hay cambios
git pull origin stage

# 4. Mergear develop en stage
git merge develop --no-ff -m "merge: develop -> stage [UAT]"

# 5. Push a stage
git push origin stage

# 6. Volver a develop para seguir trabajando
git checkout develop
```

## Estructura de ramas
| Rama      | Uso                              | Se modifica desde |
|-----------|----------------------------------|-------------------|
| `develop` | Desarrollo activo                | Directo           |
| `stage`   | UAT / pre-producción             | Merge de develop  |
| `main`    | Producción (no tocar sin avisar) | Solo cuando se indique |

## Mensajes de commit
Usar prefijos descriptivos:
- `feat:` para funcionalidades nuevas
- `fix:` para correcciones
- `style:` para cambios visuales
- `refactor:` para refactorizaciones
- `docs:` para documentación
- `chore:` para tareas de mantenimiento

## Confirmación obligatoria
Antes de ejecutar el pase a stage, mostrar al usuario:
- Qué commits van a ser mergeados
- Qué archivos cambiaron
- Pedir confirmación explícita antes de hacer el push a `stage`
```
# Análisis y Corrección Automática de la Solución

Actuás como un arquitecto de software senior. Tu misión NO es hacer reportes 
ni diagramas. Tu misión es CORREGIR y EJECUTAR.

---
-------------------------------------------------------------
## MEJORA CONTINUA

Analizá toda la solución en silencio y seguí exactamente estas reglas:

### 🔴 CRÍTICOS y 🟠 SEVERIDAD ALTA → EJECUTAR SIN PREGUNTAR
- Identificalos, corregilos y aplicá los cambios directamente en el código
- Hacé commit de cada corrección con un mensaje descriptivo
- Después de corregir cada uno, informá en UNA línea qué fue y qué hiciste:
  `✅ [archivo:línea] Descripción del problema → qué se corrigió`

### 🟡 RIESGO MEDIO y 🟢 RIESGO BAJO → SOLO UN TITULAR
- No corrijas nada
- Listá cada uno en una sola línea con este formato:
  `🟡 [archivo:línea] Título del problema`
  `🟢 [archivo:línea] Título del problema`

---

## QUÉ ANALIZAR

Revisá en este orden de prioridad:

1. **Lógica y contradicciones** — condiciones imposibles, race conditions, 
   casos borde sin manejar, reglas de negocio rotas

2. **Base de datos** — queries N+1, transacciones ausentes, 
   falta de índices críticos, riesgo de pérdida de datos

3. **Seguridad** — credenciales expuestas, inputs sin sanitizar, 
   endpoints sin protección, SQL injection, XSS

4. **Performance** — loops costosos, llamadas bloqueantes, 
   operaciones síncronas que rompen la experiencia

5. **Arquitectura** — dependencias circulares, acoplamiento que 
   impide que el sistema escale o se mantenga

6. **Mantenibilidad** — código que activamente dificulta 
   entender o modificar el sistema

---

## CRITERIO DE CLASIFICACIÓN

| Severidad | Criterio |
|-----------|----------|
| 🔴 Crítico | Puede romper el sistema, pérdida de datos o vulnerabilidad de seguridad explotable |
| 🟠 Alta | Degrada seriamente la performance, lógica incorrecta que afecta el negocio |
| 🟡 Media | Deuda técnica que acumula riesgo, mala práctica con impacto futuro |
| 🟢 Baja | Mejora de código, legibilidad, convenciones |

---

## FORMATO DE SALIDA ESPERADO
```
Analizando la solución...

— CORRECCIONES APLICADAS ——————————————————————
✅ [auth.js:47] Token JWT sin expiración → agregado exp de 24hs
✅ [userService.js:103] Query N+1 en listado de usuarios → reemplazado por JOIN
✅ [db.js:12] Password de BD hardcodeada → movida a variable de entorno
✅ [api.js:88] Endpoint /admin sin autenticación → agregado middleware auth
...

— PENDIENTE (riesgo medio/bajo) ————————————————
🟡 [userController.js:34] Falta paginación en endpoint GET /users
🟡 [helpers.js:78] Función de 200 líneas que debería dividirse
🟢 [index.js:5] Variable llamada 'data' sin nombre descriptivo
🟢 [styles.css:120] Reglas CSS duplicadas
...
```

---
Estás construyendo la UI de un marcador de Truco Uruguayo para Android (portrait mode únicamente).
NO es una web app. Todo el diseño debe estar optimizado para pantalla de celular Android.

═══════════════════════════════════════
ESTRUCTURA GENERAL
═══════════════════════════════════════

- Layout de 2 columnas simétricas: izquierda = "Nosotros", derecha = "Ellos"
- Ambas columnas son idénticas en estructura y comportamiento
- Cada columna tiene 4 zonas de arriba hacia abajo:
  1. Header
  2. Sección Malas
  3. Sección Buenas
  4. Trashcan

═══════════════════════════════════════
UNIDAD BASE: BLOQUE DE 5 PUNTOS
═══════════════════════════════════════

Todo el layout se dimensiona en función de UNA unidad base: el tamaño de un bloque de 5 puntos.
- Header height = 1 bloque de 5 puntos
- Trashcan height = 1 bloque de 5 puntos
- Gap entre bloques = mínimo
- El tamaño del bloque NUNCA cambia al agregar o quitar puntos.
  Solo cambia al cambiar el modo de juego.

═══════════════════════════════════════
MODOS DE JUEGO
═══════════════════════════════════════

Modo 10+10 → 2 bloques en Malas + 2 bloques en Buenas por columna
Modo 20+20 → 4 bloques en Malas + 4 bloques en Buenas por columna
Modo 25+25 → 5 bloques en Malas + 5 bloques en Buenas por columna

Cada bloque siempre representa exactamente 5 puntos.

═══════════════════════════════════════
HEADER
═══════════════════════════════════════

- Muestra: nombre del equipo (Nosotros / Ellos) y puntuación en formato "actual/total" (ej: 7/25)
- Sin ningún comportamiento interactivo. Ningún tap, ningún click, ninguna acción.
- Height = altura de un bloque de 5 puntos (hardcodeado, no dinámico)

═══════════════════════════════════════
LAYOUT DE BLOQUES — REGLA ABSOLUTA
═══════════════════════════════════════

⚠️ NUNCA usar justify-content, align-items center/space-between, o cualquier
   distribución vertical. El espacio vacío SIEMPRE queda abajo. SIEMPRE.

- Los bloques arrancan desde el borde superior de su sección (top: 0)
- Se apilan hacia abajo con gap mínimo
- El espacio vacío es un espacio muerto en la parte inferior
- Los bloques están centrados horizontalmente dentro de su columna
- La distancia del último bloque al borde inferior de la sección
  es como máximo la altura de un bloque de 5 puntos

Sección Malas:
  → Primer bloque pegado al borde superior, debajo del header
  → Los siguientes apilados hacia abajo con gap mínimo

Sección Buenas:
  → Primer bloque pegado al borde superior, debajo de la línea divisoria Malas/Buenas
  → Los siguientes apilados hacia abajo con gap mínimo

═══════════════════════════════════════
COMPORTAMIENTO DE PUNTOS
═══════════════════════════════════════

- Cada tap DENTRO de la sección Malas o Buenas = +1 punto exacto
- Tap fuera de estas secciones = ninguna acción
- Los puntos se registran siempre de arriba hacia abajo dentro del bloque,
  y de bloque superior a inferior dentro de la sección
- Todos los puntos son del mismo color, sin distinción visual
- Se llenan primero todos los puntos de Malas, luego los de Buenas
- No se puede saltar de sección ni adelantar puntos en Buenas si Malas no está completa
- Un tap en la zona vacía inferior de una sección no suma puntos
  si esa sección ya está completa

═══════════════════════════════════════
TRASHCAN
═══════════════════════════════════════

- Uno por columna, debajo de la sección Buenas
- Height = altura de un bloque de 5 puntos (misma unidad base)
- Width = mismo ancho que los bloques de 5 puntos, centrado horizontalmente
- Cada tap = -1 punto del último punto anotado en esa columna
- Orden inverso: si el último punto fue en Buenas, se resta de Buenas.
  Si Buenas está vacía, se resta de Malas.

═══════════════════════════════════════
RESTRICCIONES CRÍTICAS — NO ROMPER
═══════════════════════════════════════

1. El tamaño del bloque NO se recalcula en cada render al agregar puntos.
   Solo se recalcula cuando cambia el modo de juego.

2. El espacio vacío al final de la sección NUNCA empuja bloques hacia el centro.
   Implementar con position absolute o flex-start + padding-bottom fijo,
   NUNCA con justify-content que distribuya el espacio.

3. La altura del header está hardcodeada al valor de la unidad base (bloque de 5 puntos).
   No depende del tamaño del texto ni es dinámica.

4. Las secciones Malas y Buenas son táctiles solo cuando corresponde:
   Malas acepta taps hasta completarse. Buenas solo acepta taps cuando Malas está completa.