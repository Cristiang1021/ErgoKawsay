<p align="center">
  <img src="assets/illustrations/splash_hero.png" alt="ErgoKawsay" width="120" />
</p>

<h1 align="center">ErgoKawsay</h1>

<p align="center">
  <strong>Bienestar y salud intercultural para docentes</strong><br/>
  Aplicación móvil en Flutter · Español &amp; Kichwa
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.2+-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.2+-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Platform-Android-green?logo=android" alt="Android" />
  <img src="https://img.shields.io/badge/Idiomas-ES%20%7C%20Kichwa-blueviolet" alt="Idiomas" />
  <img src="https://img.shields.io/badge/Versión-1.0.0-informational" alt="Versión" />
</p>

---

## Descripción

**ErgoKawsay** (*alli kawsay, allí kana*) es una app orientada a docentes que integra ergonomía, prevención de trastornos musculoesqueléticos, pausas activas, ejercicios guiados, salud mental y recursos multimedia. El contenido está disponible en **español** y **kichwa**, con traducciones centralizadas y revisables.

Desarrollada en el marco de un proyecto académico con identidad institucional de la **ESPOCH** (Escuela Superior Politécnica de Chimborazo).

---

## Tabla de contenidos

- [Características](#características)
- [Capturas de pantalla](#capturas-de-pantalla)
- [Stack tecnológico](#stack-tecnológico)
- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Ejecución](#ejecución)
- [Generar APK](#generar-apk)
- [Traducciones](#traducciones)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Arquitectura](#arquitectura)
- [Assets](#assets)
- [Créditos](#créditos)
- [Licencia](#licencia)

---

## Características

| Área | Módulos |
|------|---------|
| **Cuerpo** | Ergonomía docente · Enfermedades · Pausas activas · Ejercicios por zona corporal |
| **Mente** | Salud mental y emociones · Consejos preventivos · Música · Videos educativos |
| **Hábitos** | Recordatorios locales · Progreso de uso · Perfil docente |
| **Accesibilidad** | Modo claro/oscuro · Tamaño de texto · Filtro para daltonismo |

### Detalle de módulos

- **Ergonomía** — Contenido en tarjetas interactivas (story deck), ilustraciones docentes y cuestionario de repaso.
- **Enfermedades** — Síndrome del túnel carpiano, tendinitis, lumbalgia, cervicalgia; cuándo consultar al médico.
- **Pausas activas** — Secuencia guiada de 5 minutos (cuello, hombros, muñecas, lumbar, respiración).
- **Ejercicios** — 8 categorías: cuello, hombros, manos, espalda, cadera, piernas, vista (regla 20-20-20), respiración 4-7-8.
- **Emociones** — Enojo, tristeza, alegría, miedo y ansiedad con personajes (Inti, Yaku, Rumirumi, Tutam, Chaskym).
- **Consejos** — Tips preventivos rotativos para el día a día en el aula.
- **Música** — Ambientes: bosque, lluvia suave, música energizante.
- **Videos** — Ergonomía postural y yoga de 10 minutos (reproductor integrado).
- **Recordatorios** — Notificaciones de pausas activas y ejercicio diario; modo silencio nocturno.
- **Configuración** — Idioma, tema, accesibilidad, información de la app e identidad ESPOCH.

---

## Capturas de pantalla

> Añade aquí capturas del emulador o dispositivo. Sugerencia: crea la carpeta `docs/screenshots/` y referencia las imágenes.

| Inicio | Ergonomía | Emociones |
|:------:|:---------:|:---------:|
| *pendiente* | *pendiente* | *pendiente* |

---

## Stack tecnológico

| Tecnología | Uso |
|------------|-----|
| [Flutter](https://flutter.dev) | UI multiplataforma |
| [Provider](https://pub.dev/packages/provider) | Estado (idioma, tema, accesibilidad) |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Persistencia local |
| [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) | Recordatorios |
| [just_audio](https://pub.dev/packages/just_audio) | Reproducción de audio |
| [video_player](https://pub.dev/packages/video_player) | Videos educativos |
| [google_fonts](https://pub.dev/packages/google_fonts) | Tipografía |
| Python + PyYAML | Generación de traducciones |

---

## Requisitos

- **Flutter SDK** ≥ 3.2.0 ([instalación](https://docs.flutter.dev/get-started/install))
- **Dart** ≥ 3.2.0 (incluido con Flutter)
- **Android SDK** — API 21+ (Android 5.0)
- **Python 3** + `pip install pyyaml` — solo si vas a regenerar traducciones
- Editor recomendado: VS Code o Android Studio con extensión Flutter

Verifica tu entorno:

```bash
flutter doctor
```

---

## Instalación

```bash
git clone https://github.com/TU_USUARIO/ErgoKawsay.git
cd ErgoKawsay
flutter pub get
```

---

## Ejecución

### Dispositivo o emulador conectado

```bash
flutter devices
flutter run
```

### Emulador Android (ejemplo)

```bash
flutter emulators --launch Medium_Phone_API_36.1
flutter run -d android
```

### Análisis estático

```bash
flutter analyze
```

---

## Generar APK

APK de release (sin debug):

```bash
flutter build apk --release
```

El archivo se genera en:

```
build/app/outputs/flutter-apk/app-release.apk
```

Para un bundle de Play Store:

```bash
flutter build appbundle --release
```

---

## Traducciones

La fuente oficial de textos ES / Kichwa es [`translations.yaml`](translations.yaml).

Para regenerar el archivo Dart generado:

```bash
pip install pyyaml
python tools/gen_translations.py
```

Esto actualiza `lib/core/localization/tr.dart`. Los strings de UI en `app_localizations.dart` consumen esas traducciones.

| Código | Idioma |
|--------|--------|
| `es` | Español |
| `qu` | Kichwa |

---

## Estructura del proyecto

```
ErgoKawsay/
├── lib/
│   ├── main.dart                 # Entrada de la app
│   ├── app.dart                  # Rutas, tema, localización
│   ├── core/
│   │   ├── constants/            # AppConstants, AppAssets
│   │   ├── localization/         # tr.dart, AppLocalizations, controllers
│   │   ├── services/             # Notificaciones
│   │   ├── storage/              # SharedPreferences
│   │   └── theme/                # Tema claro/oscuro, paleta
│   ├── data/
│   │   ├── local/                # Repositorio de datos y quizzes
│   │   └── models/               # Exercise, Disease, Emotion, Tip…
│   ├── features/                 # Pantallas por módulo
│   └── shared/widgets/           # Componentes reutilizables
├── assets/
│   ├── branding/                 # Logos ErgoKawsay y ESPOCH
│   ├── emotions/                 # Personajes emocionales
│   ├── illustrations/            # Splash e identidad visual
│   ├── Extra/                    # Ilustraciones docente / ergonomía
│   ├── images/                   # Thumbnails e ilustraciones UI
│   ├── audio/                    # Pistas de ambiente
│   └── videos/                   # Videos educativos
├── translations.yaml             # Traducciones oficiales
├── tools/gen_translations.py     # Generador i18n
└── info app/                     # Documentación de referencia del contenido
```

---

## Arquitectura

- **Patrón por features** — Cada módulo tiene su pantalla en `lib/features/`.
- **Datos locales** — `LocalDataRepository` centraliza módulos, ejercicios, enfermedades, emociones, tips, audio y video (sin backend).
- **Estado global** — `LocaleController`, `ThemeController` y `AccessibilityController` con `Provider`.
- **Persistencia** — `StorageService` (idioma, progreso, recordatorios, perfil docente).
- **Rutas nombradas** — Definidas en `app.dart` (`/home`, `/ergonomics`, `/emotions`, etc.).

---

## Assets

| Carpeta | Contenido |
|---------|-----------|
| `assets/branding/` | Logos institucionales ESPOCH y marca ErgoKawsay |
| `assets/emotions/` | Inti, Yaku, Rumirumi, Tutam, Chaskym |
| `assets/Extra/ergonomia/` | Infografía ergonomía docente |
| `assets/Extra/posturas/` | Poses del personaje docente (pizarra, PC, tablet, etc.) |
| `assets/audio/` | Sonido del bosque, lluvia, música energizante |
| `assets/videos/` | Ergonomía postural, yoga 5 min |

Tras añadir archivos nuevos en `assets/`, decláralos en [`pubspec.yaml`](pubspec.yaml) y en [`lib/core/constants/app_assets.dart`](lib/core/constants/app_assets.dart).

---

## Créditos

- **Proyecto:** ErgoKawsay — Bienestar y Salud Intercultural
- **Institución:** [ESPOCH](https://www.espoch.edu.ec/) — Escuela Superior Politécnica de Chimborazo
- **Contenido:** Material ergonómico y de bienestar docente; traducciones kichwa en `translations.yaml`
- **Ilustraciones:** Personaje docente, infografías de ergonomía y personajes emocionales (assets propios del proyecto)
- **Audio y video:** Recursos incluidos en `assets/audio/` y `assets/videos/`

---

## Licencia

Proyecto académico. Los logos institucionales, ilustraciones y contenido multimedia pueden estar sujetos a derechos de la ESPOCH o de sus autores. Consulta antes de redistribuir o usar con fines comerciales.

---

<p align="center">
  <sub>ErgoKawsay · Alli kawsay, allí kana · Hecho con Flutter</sub>
</p>
