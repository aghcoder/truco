# 🃏 Truco Uruguayo - Contador de Puntos

App para anotar puntos del Truco Uruguayo. Estilo cuadernola con trazos de lapicera.

## 📱 Requisitos previos

Antes de empezar necesitás tener instalado:
- **Node.js** (v18+): https://nodejs.org
- **Android Studio**: https://developer.android.com/studio
- **JDK 17**: incluido con Android Studio

## 🚀 Pasos para generar el APK

### 1. Instalar dependencias
```bash
npm install
```

### 2. Agregar plataforma Android
```bash
npx cap add android
```

### 3. Sincronizar archivos
```bash
npx cap sync android
```

### 4. Abrir en Android Studio
```bash
npx cap open android
```

### 5. En Android Studio:
- Menú: **Build → Build Bundle(s) / APK(s) → Build APK(s)**
- El APK se genera en: `android/app/build/outputs/apk/debug/app-debug.apk`

### 6. Para instalar en tu celular:
- Copiar el APK al celular por USB o email
- En el celular: Ajustes → Seguridad → Permitir fuentes desconocidas
- Instalar el APK

---

## 📦 Para subir a Google Play Store

### Paso 1: Generar APK firmado (Release)
En Android Studio:
- **Build → Generate Signed Bundle / APK**
- Elegir **APK**
- Crear un nuevo keystore (guardarlo en lugar seguro!)
- Elegir **Release**
- Build

### Paso 2: Crear cuenta de desarrollador Google Play
- Ir a: https://play.google.com/console
- Pagar el fee único de U$D 25
- Completar el perfil de desarrollador

### Paso 3: Crear la app en Play Console
- "Crear app"
- Nombre: "Truco Uruguayo"
- Idioma: Español
- Tipo: App / Gratis

### Paso 4: Subir el APK
- En Play Console: **Producción → Crear nueva versión**
- Subir el archivo `.aab` (Android App Bundle, preferido) o `.apk`
- Completar descripción, screenshots, íconos

### Paso 5: Información requerida por Google
- **Descripción corta** (80 chars): "Contador de puntos para jugar al Truco Uruguayo"
- **Descripción larga**: descripción completa de la app
- **Screenshots**: mínimo 2 capturas de pantalla del celular
- **Ícono**: 512x512px PNG
- **Categoría**: Juegos de cartas / Herramientas

---

## 🎮 Características de la app

- ✅ Marcador para 2 equipos (nombres editables)
- ✅ Trazos estilo cuadernola (palitos de lapicera azul)
- ✅ Grupos de 5 con diagonal (la "morcilla")
- ✅ Sistema de malas (3 por equipo)
- ✅ Pantalla de ganador al llegar a 30 puntos
- ✅ Vibración haptica en celulares
- ✅ Guarda el estado (no se pierde si cerrás la app)
- ✅ Diseño responsivo (funciona en cualquier pantalla)
- ✅ Deshacer último punto

## 🛠️ Próximas mejoras (para Claude Code)

- [ ] Ícono personalizado de la app
- [ ] Pantalla de splash
- [ ] Historial de partidas
- [ ] Modo oscuro / claro
- [ ] Sonidos al sumar puntos
- [ ] Animaciones al ganar

---

> 💡 **Tip para Claude Code**: Abrí esta carpeta con `claude` en la terminal y podés pedirle mejoras directamente al proyecto.
