# CLAUDE.md — Truco Uruguayo
> Contexto maestro leído por TODOS los agentes en cada sesión.
> Actualizar solo el Senior Dev / PO cuando cambie arquitectura o convenciones.
> Última actualización: 2025

---

## 🎯 Proyecto

**Nombre:** Truco Uruguayo  
**App ID:** `com.truco.uruguayo`  
**Descripción:** App mobile de marcador para el juego de cartas Truco. Single-page app empaquetada como APK Android via Capacitor.  
**Repo:** https://github.com/aghcoder/truco  
**Estado:** Desarrollo activo en `develop`

---

## 👥 Actores del Sistema

### Humanos
| Actor | Rol | Responsabilidad |
|-------|-----|-----------------|
| PO | Product Owner | Define features en `docs/PRD.md`, aprueba releases, hace UAT, dice "mandá a UAT" |
| Senior Dev | Orchestrator | Revisa código generado, aprueba arquitectura, decide trade-offs |

> En este proyecto el PO y el Senior Dev son la misma persona.
> Cuando hay conflicto entre velocidad y calidad → priorizar calidad (es una app publicada).

### Agentes IA
| Agente | Archivo de configuración | Carpeta de outputs |
|--------|--------------------------|-------------------|
| Dev Agent | `.claude/agents/dev-agent.md` | `c:\truco\docs\dev-agent\` |
| QA Agent | `.claude/agents/qa-agent.md` | `c:\truco\docs\qa-agent\` |
| Review Agent | `.claude/agents/review-agent.md` | `c:\truco\docs\review-agent\` |
| Docs Agent | `.claude/agents/docs-agent.md` | `c:\truco\docs\docs-agent\` |

---

## 🏗️ Arquitectura

### Stack real
```
App:        Single HTML file (index.html) — HTML + CSS + JS embebido
Empaquetado: Capacitor → Android APK
Plataforma: Android únicamente, portrait mode
Storage:    localStorage (persistencia de estado)
Fuentes:    Google Fonts (Rye, Crimson Pro) — cargadas online
No hay:     backend, base de datos, build step, bundler, framework JS
```

### Estructura del repo
```
c:\truco\
├── index.html          ← TODO el código vive acá (HTML + CSS + JS)
├── CLAUDE.md           ← este archivo
├── package.json        ← solo Capacitor dependencies
├── capacitor.config.ts ← config de Capacitor
├── android/            ← proyecto Android generado por Capacitor
│   └── app/build/outputs/apk/debug/app-debug.apk
├── docs/               ← documentación del proyecto
│   ├── PRD.md
│   ├── DECISIONS.md
│   └── CHANGELOG.md
└── .claude/
    ├── agents/
    │   ├── dev-agent.md
    │   ├── qa-agent.md
    │   ├── review-agent.md
    │   └── docs-agent.md
    └── commands/
        ├── feature.md
        ├── review.md
        ├── test.md
        └── ship.md
```

> ⚠️ `index.html` es el único archivo de aplicación. No crear archivos `.js`, `.css` separados salvo que el Senior Dev lo autorice explícitamente.

### Estado de la app (JS global)
```js
let state = {
    teams: [
        { name: 'Nosotros', points: 0, malas: [false, false, false] },
        { name: 'Ellos',    points: 0, malas: [false, false, false] }
    ]
}
// Persistido en localStorage via saveState() / loadState()
```

### Funciones core
| Función | Qué hace |
|---------|----------|
| `addPoint(teamIdx)` | +1 punto, muta state, re-render |
| `undoPoint(teamIdx)` | -1 punto (trashcan), orden inverso Buenas→Malas |
| `renderScores(teamIdx)` | SVG de palitos: grupos 4 verticales + 1 diagonal (morcilla) |
| `editName(teamIdx)` | Edición inline del nombre del equipo |
| `toggleMala(teamIdx, dotIdx)` | Toggle de indicadores de malas (3 por equipo) |
| `showWinner(teamIdx)` | Overlay de ganador |
| `newGame()` | Reset completo |

### Constantes visuales (NO cambiar sin aprobación)
```
Verde fieltro:  #0a4028
Oro:            #d4af37
Azul tinta:     #2c5aa0   (palitos/strokes)
Rojo malas:     #c41e3a
Fuentes:        Rye (títulos), Crimson Pro (cuerpo)
SVG filter:     feTurbulence — da textura hand-drawn a los palitos
Condición win:  30 puntos
```

### Modos de juego
| Modo | Bloques Malas | Bloques Buenas | Total puntos |
|------|---------------|----------------|--------------|
| 10+10 | 2 bloques | 2 bloques | 20 |
| 20+20 | 4 bloques | 4 bloques | 40 |
| 25+25 | 5 bloques | 5 bloques | 50 |

Cada bloque = exactamente 5 puntos.

---

## 📐 Reglas de diseño UI — CRÍTICAS

> Estas reglas son restricciones absolutas. No se negocian.

1. **Portrait mode únicamente** — nunca landscape
2. **Layout 2 columnas simétricas** — izquierda: Nosotros, derecha: Ellos
3. **Zonas por columna (top→bottom):** Header → Malas → Buenas → Trashcan
4. **Espacio vacío SIEMPRE abajo** — NUNCA usar `justify-content: center/space-between`
   - Usar `flex-start` + `padding-bottom` fijo, o `position: absolute`
5. **Tamaño de bloque fijo** — NO recalcular al agregar puntos, SOLO al cambiar modo
6. **Header height** = altura de un bloque de 5 puntos (hardcodeado, no dinámico)
7. **Trashcan:** 1 por columna, height = 1 bloque, tap = -1 punto (Buenas primero, luego Malas)
8. **Tap en zona vacía inferior** → no suma puntos si la sección está completa
9. **Malas se llena ANTES que Buenas** — no se puede adelantar puntos

---

## 🔧 Comandos del proyecto

```bash
# Desarrollo
# No hay build step — abrir index.html directamente en browser

# Android
npm install                  # instalar dependencias Capacitor
npx cap sync android         # sincronizar web → Android
npx cap open android         # abrir Android Studio
npx cap run android          # correr en dispositivo conectado

# Build APK
# En Android Studio: Build → Build APK(s)
# Output: android/app/build/outputs/apk/debug/app-debug.apk
```

---

## 🌿 Git & Ramas

### Estructura
| Rama | Uso | Cómo se modifica |
|------|-----|-----------------|
| `develop` | Desarrollo activo — **RAMA DE TRABAJO** | Directo |
| `stage` | UAT / pre-producción | Merge desde develop |
| `main` | Producción | Solo cuando PO lo indique |

### Reglas absolutas de Git
- **NUNCA** push directo a `main` sin confirmación explícita
- Siempre verificar rama con `git branch` antes de cambiar código
- Push a develop **solo cuando el PO diga "subir a develop"** (o similar)
- Mantener en localhost hasta esa instrucción

### Deploy a develop y stage — SIN confirmación
Ejecutar directamente sin preguntar nada al recibir la instrucción del PO.

### Deploy a main/producción — CONFIRMACIÓN OBLIGATORIA
Antes de cualquier push a `main`, mostrar y esperar aprobación explícita:
```
⚠️  PUSH A PRODUCCIÓN
Commits que se van a mergear: [lista]
Archivos modificados: [lista]
¿Confirmás el pase a main? (escribir "confirmo" para continuar)
```

### Prefijos de commit obligatorios
```
feat:      nueva funcionalidad
fix:       corrección de bug
style:     cambios visuales sin lógica
refactor:  reestructuración sin cambio de comportamiento
docs:      solo documentación
chore:     mantenimiento (deps, config)
```

### Activación de pase a Stage/UAT
Frases que activan el flujo: *"mandá a UAT", "pasá a stage", "pase a UAT", "deployá a stage", "subí a UAT", "promové a stage", "listo para stage"*

```bash
git checkout develop && git pull origin develop
git checkout stage && git pull origin stage
git merge develop --no-ff -m "merge: develop -> stage [UAT]"
git push origin stage
git checkout develop
```
**Antes de ejecutar:** mostrar commits que se van a mergear y pedir confirmación explícita.

---

## 🔍 Análisis automático de calidad (Mejora Continua)

En cada sesión de trabajo, analizar el código silenciosamente y aplicar este protocolo:

### 🔴 Crítico → CORREGIR SIN PREGUNTAR
- Aplicar el fix directamente, **sin romper ninguna funcionalidad existente del juego**
- Hacer commit descriptivo
- Reportar en una línea:
```
✅ [index.html:línea] Problema encontrado → qué se corrigió
```

### 🟠 Alta severidad → PREGUNTAR ANTES de tocar
- NO modificar nada
- Presentar el problema con la solución propuesta y esperar aprobación:
```
🟠 [index.html:línea] Problema: [descripción]
   Solución propuesta: [qué se haría y por qué]
   ¿Aprobás que lo corrija? (s/n)
```

### 🟡 Medio y 🟢 Bajo → SOLO LISTAR, preguntar si se quiere mejorar
- NO modificar nada
- Listar todos juntos al final y preguntar una sola vez:
```
🟡 [index.html:línea] Título del problema
🟢 [index.html:línea] Título del problema

¿Querés que mejore alguno de estos? (indicar cuáles o "todos" / "ninguno")
```

### Orden de análisis
1. Lógica y casos borde (reglas de Truco, condiciones de victoria, puntuación)
2. Storage (localStorage: corrupción, pérdida de datos, migración de estado)
3. Seguridad (XSS en nombres de equipo — input del usuario)
4. Performance (renders innecesarios, SVG bloqueante)
5. Compatibilidad Android (touch events vs click, viewport, safe areas)
6. Mantenibilidad (todo en un archivo — documentar bien qué hace cada sección)

| Severidad | Criterio |
|-----------|----------|
| 🔴 Crítico | Rompe el juego, pérdida de datos, crash en Android |
| 🟠 Alta | Lógica incorrecta de puntuación, UX rota en dispositivo real |
| 🟡 Media | Deuda técnica, mala práctica acumulable |
| 🟢 Baja | Legibilidad, convenciones, comentarios |

---

## 📋 Checklist pre-merge

```
[ ] index.html abre en browser sin errores de consola
[ ] Los 3 modos de juego (10+10, 20+20, 25+25) funcionan correctamente
[ ] Los palitos se renderizan correctamente en todos los casos
[ ] El trashcan resta en orden correcto (Buenas → Malas)
[ ] Los nombres de equipo se pueden editar
[ ] El estado persiste al recargar (localStorage)
[ ] La condición de victoria (30 pts) dispara el overlay
[ ] newGame() resetea todo correctamente
[ ] No hay console.log de debug
[ ] El layout es correcto en portrait mode (no se rompe al girar)
[ ] Touch events funcionan (no solo click)
[ ] El espacio vacío queda ABAJO (no centrado)
```

---

## 📁 Sistema de archivos de agentes

Cada agente guarda sus outputs en su carpeta bajo `c:\truco\docs\`:
```
c:\truco\docs\
├── dev-agent\      ← planes, specs técnicas generadas por Dev Agent
├── qa-agent\       ← reportes de testing, casos de prueba
├── review-agent\   ← reportes de code review
└── docs-agent\     ← changelogs, PRD updates, release notes
```

**Convención de nombres (sin excepción):**
```
[tipo]_[descripción-corta]_YYYYMMDD_HHMM.md

Ejemplos:
plan_feature-match-history_20250215_1430.md
review_index-html-audit_20250215_1445.md
test_scoring-logic_20250215_1500.md
changelog_v1-2-0_20250215_1510.md
```
- **NUNCA sobreescribir** un archivo existente
- Si el archivo ya existe con ese timestamp → agregar sufijo `_v2`, `_v3`
- Los archivos en `c:\truco\docs\` son el historial de decisiones del proyecto

---

## 📋 Features planificadas (del README original)

| Feature | Prioridad | Estado |
|---------|-----------|--------|
| Match history | P2 | Pendiente |
| Sound effects al sumar punto | P2 | Pendiente |
| Win animations | P2 | Pendiente |
| Custom app icon | P3 | Pendiente |
| Splash screen | P3 | Pendiente |
| Light/dark mode | P3 | Pendiente |

---

## ⚠️ Qué NO hacer (específico para este proyecto)

- No crear archivos `.js` o `.css` separados — todo va en `index.html`
- No agregar frameworks JS (React, Vue, etc.) sin autorización explícita
- No cambiar las constantes de color sin aprobación del PO
- No modificar la lógica de palitos SVG sin entender `renderScores()`
- No usar `justify-content: center/space-between` en el layout de bloques
- No asumir que `click` funciona en Android — siempre verificar touch events
- No hacer push a `stage` o `main` sin instrucción explícita del PO
- No instalar dependencias npm sin consultar (Capacitor es suficiente)
