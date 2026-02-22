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
