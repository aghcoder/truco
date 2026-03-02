# Slash Commands — Truco Uruguayo
> Estos comandos orquestan el pipeline completo de agentes.
> Escribirlos en Claude Code para activar el flujo correspondiente.

---

## /feature [nombre]

**Activa el pipeline completo de implementación.**

```
Uso:
  /feature "match history"
  /feature "sound effects al sumar punto"
  /feature "win animations"
```

### Flujo que se ejecuta:

```
1. [Dev Agent]    Lee PRD.md → encuentra la sección de la feature
2. [Dev Agent]    Analiza index.html → entiende el estado actual
3. [Dev Agent]    Presenta plan con cambios CSS/JS/HTML → espera OK
4. [Dev Agent]    Implementa en index.html
5. [Dev Agent]    Verifica en browser (sin errores de consola)
6. [Dev Agent]    Guarda plan en c:\truco\docs\dev-agent\plan_[nombre]_YYYYMMDD_HHMM.md
7. [QA Agent]     Genera casos de prueba
8. [QA Agent]     Genera script de consola para testing automatizable
9. [QA Agent]     Ejecuta tests manuales de layout (DevTools mobile)
10. [QA Agent]    Guarda reporte en c:\truco\docs\qa-agent\test_[nombre]_YYYYMMDD_HHMM.md
11. [Review Agent] Lee plan + reporte + código
12. [Review Agent] Ejecuta checklist completa de restricciones
13. [Review Agent] Guarda reporte en c:\truco\docs\review-agent\review_[nombre]_YYYYMMDD_HHMM.md
14. [Docs Agent]  Actualiza CHANGELOG.md, PRD.md, DECISIONS.md si aplica
15. [Docs Agent]  Guarda en c:\truco\docs\docs-agent\doc-update_[nombre]_YYYYMMDD_HHMM.md
16. → Presenta resumen final al Senior Dev para aprobación de merge
```

### Output final que ve el Senior Dev:
```
🚀 Pipeline completado: [nombre feature]

Dev Agent:    ✅ Implementado (c:\truco\docs\dev-agent\...)
QA Agent:     ✅ X/Y tests pasaron (c:\truco\docs\qa-agent\...)
Review Agent: ✅ Aprobado / ⚠️ N issues (c:\truco\docs\review-agent\...)
Docs Agent:   ✅ Actualizado (c:\truco\docs\docs-agent\...)

¿Aprobás el merge a develop? (s/n)
```

---

## /fix [descripción del bug]

**Investiga y corrige un bug.**

```
Uso:
  /fix "el trashcan resta de Malas aunque haya puntos en Buenas"
  /fix "al recargar la app los puntos se pierden"
  /fix "en modo 25+25 el bloque se achica al sumar puntos"
```

### Flujo:

```
1. [Dev Agent]    Reproduce el bug → escribe un test que falla
2. [Dev Agent]    Identifica la causa raíz en index.html
3. [Dev Agent]    Propone el fix con explicación del por qué
4. → Senior Dev aprueba el approach
5. [Dev Agent]    Implementa el fix
6. [Dev Agent]    Verifica que el test ahora pasa
7. [Dev Agent]    Busca si el mismo bug existe en otros lugares
8. [QA Agent]     Corre regresión en las funciones relacionadas
9. [Review Agent] Revisa el fix puntualmente
10. [Docs Agent]  Actualiza CHANGELOG.md con el fix
```

---

## /review [opcional: sección específica]

**Code review del código actual o de una sección.**

```
Uso:
  /review                        → review de todo lo cambiado recientemente
  /review renderScores           → review de la función específica
  /review localStorage           → review del sistema de persistencia
  /review layout                 → review específico de reglas de layout
```

### Flujo:

```
1. [Review Agent] Lee los últimos archivos en c:\truco\docs\dev-agent\
2. [Review Agent] Ejecuta checklist completa
3. [Review Agent] Genera reporte en c:\truco\docs\review-agent\review_[scope]_YYYYMMDD_HHMM.md
4. → Presenta veredicto al Senior Dev
```

---

## /test [opcional: función o feature específica]

**Genera y ejecuta tests.**

```
Uso:
  /test                          → test completo de la app
  /test puntuación               → tests del sistema de puntos
  /test localStorage             → tests de persistencia
  /test renderScores             → tests de los palitos SVG
  /test trashcan                 → tests del sistema de deshacer
```

### Flujo:

```
1. [QA Agent]    Identifica las funciones a testear
2. [QA Agent]    Genera casos de prueba en formato tabla
3. [QA Agent]    Genera script ejecutable en consola del browser
4. [QA Agent]    Lista tests manuales necesarios (layout, touch)
5. [QA Agent]    Guarda en c:\truco\docs\qa-agent\test_[scope]_YYYYMMDD_HHMM.md
6. → Presenta reporte al Senior Dev
```

---

## /ship [versión opcional]

**Prepara un release completo para pase a stage.**

```
Uso:
  /ship           → prepara release con versión auto-calculada
  /ship v1.2.0    → prepara release con versión específica
```

### Flujo:

```
1. [QA Agent]     Corre suite completa de tests (todos los críticos)
2. [QA Agent]     Guarda reporte en c:\truco\docs\qa-agent\test_release-[v]_YYYYMMDD_HHMM.md
3. [Review Agent] Revisa que no haya deuda técnica bloqueante pendiente
4. [Review Agent] Guarda en c:\truco\docs\review-agent\review_release-[v]_YYYYMMDD_HHMM.md
5. [Docs Agent]   Organiza CHANGELOG.md → mueve [Unreleased] a [vX.Y.Z]
6. [Docs Agent]   Genera Release Notes para el PO
7. [Docs Agent]   Guarda en c:\truco\docs\docs-agent\release-notes_[v]_YYYYMMDD_HHMM.md
8. → Presenta checklist final al Senior Dev
```

### Checklist de release que presenta:
```
🚀 RELEASE CHECKLIST — v[X.Y.Z]

CALIDAD
[ ] Suite completa de tests: X/Y pasaron ✅/❌
[ ] Sin bloqueantes en review ✅/❌
[ ] Sin console.log de debug ✅/❌

FUNCIONALIDAD CORE (verificación manual requerida)
[ ] Modo 10+10 funciona end-to-end ✅/❌
[ ] Modo 20+20 funciona end-to-end ✅/❌
[ ] Modo 25+25 funciona end-to-end ✅/❌
[ ] Victoria a 30 puntos ✅/❌
[ ] localStorage persiste entre recargas ✅/❌
[ ] Touch events en Android (dispositivo real o emulador) ✅/❌

DOCUMENTACIÓN
[ ] CHANGELOG.md con versión [X.Y.Z] ✅/❌
[ ] Release Notes generadas para el PO ✅/❌
[ ] PRD.md con features marcadas como implementadas ✅/❌

APK
[ ] npx cap sync android ejecutado ✅/❌
[ ] APK generado desde Android Studio ✅/❌
[ ] APK instalado y probado en dispositivo real ✅/❌

APROBACIÓN
[ ] Senior Dev aprueba el código ⬜
[ ] PO lee las Release Notes y da Go ⬜

¿Ejecuto el pase a stage? (necesita confirmación explícita)
```

---

## /doc [tema]

**Genera o actualiza documentación específica.**

```
Uso:
  /doc renderScores         → documenta la función de palitos SVG
  /doc localStorage         → documenta el sistema de persistencia
  /doc arquitectura         → actualiza ARCHITECTURE.md
  /doc adr "decisión X"     → crea un nuevo ADR en DECISIONS.md
  /doc changelog            → revisa y organiza el CHANGELOG
```

### Flujo:

```
1. [Docs Agent]   Analiza el tema a documentar
2. [Docs Agent]   Genera la documentación (en el archivo del proyecto + en c:\truco\docs\)
3. [Docs Agent]   Guarda en c:\truco\docs\docs-agent\doc_[tema]_YYYYMMDD_HHMM.md
4. → Presenta al Senior Dev para revisión
```
