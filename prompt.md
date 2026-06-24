Actúa como Senior Flutter UI Engineer y Senior Product Designer.

Estás dentro del proyecto Flutter de ErgoKawsay. Claude Code está instalado en la carpeta del proyecto. Tu tarea NO es analizar, NO es hacer resumen, NO es explicar, NO es auditar. Tu tarea es modificar directamente el código para reconstruir radicalmente todo el diseño visual de la aplicación.

La app se llama:

ERGOKAWSAY
Bienestar y Salud Intercultural

Debe seguir los requisitos ya definidos del proyecto:

* App móvil Android.
* Sin login.
* Sin registro.
* Sin backend.
* Sin API.
* Todo local.
* Selección de idioma Español/Kichwa.
* Contenido ergonómico.
* Enfermedades ocupacionales.
* Pausas activas.
* Ejercicios con temporizador.
* Recordatorios.
* Consejos.
* Salud mental y emociones.
* Música.
* Videos.
* Progreso.
* Configuración.

NO elimines funcionalidades requeridas.
NO cambies el alcance funcional.
NO conviertas esto en otra app.
SÍ puedes rehacer navegación, layouts, componentes, tema, pantallas y estructura visual si eso mejora radicalmente el resultado.

El diseño actual es malo. Parece IA, Flutter básico, MVP académico y sin criterio UI/UX. Quiero un rediseño radical, profesional y premium.

El objetivo es que al terminar yo pueda ejecutar:

flutter run

y ver una aplicación visualmente mucho mejor, coherente, seria y con calidad de producto real.

---

# DIRECCIÓN VISUAL OBLIGATORIA

Usa este sistema como base visual. No como inspiración vaga. Como dirección de diseño.

El diseño debe parecer una app móvil creada con una filosofía visual tipo Figma Marketing:

* Core monocromático: negro, blanco y superficies limpias.
* Tipografía protagonista.
* Headlines grandes.
* Composición editorial.
* Mucho espacio en blanco.
* Color blocks pastel grandes.
* Secciones visuales amplias.
* Botones pill.
* Icon buttons circulares.
* Muy pocas sombras.
* Nada de gradientes genéricos.
* Nada de Material Design por defecto.
* Nada de cards repetidas sin intención.
* Nada de placeholders feos.
* Nada de diseño típico generado por IA.

No copies Figma literalmente.
No hagas un clon de Figma.
Pero sí aplica su sistema visual: composición, jerarquía, ritmo, color blocks, tipografía grande, botones pill, espacios amplios y consistencia.

---

# DESIGN SYSTEM A IMPLEMENTAR

## Colores

Usa una base monocromática:

* primary: #111111
* onPrimary: #FFFFFF
* canvas: #FFFFFF
* inverseCanvas: #111111
* ink: #111111
* inverseInk: #FFFFFF
* surfaceSoft: #F5F5F0
* hairline: #E6E3DC
* hairlineSoft: #F1EFEA

Color blocks pastel:

* blockLime: #D8F266
* blockLilac: #DCC7FF
* blockCream: #F7F2E8
* blockMint: #B8F0D8
* blockPink: #FFD6E8
* blockCoral: #FFB7A3
* blockNavy: #1F2A44

Usar los colores como superficies grandes, no como pequeños adornos.
Cada pantalla debe tener al menos una sección fuerte tipo color-block si aplica.

No usar gradientes.

---

## Tipografía

Usar Google Fonts.

Preferencia:

* Geist o Inter para sans.
* JetBrains Mono o Geist Mono para labels/eyebrows.

Si ya existe google_fonts, úsalo. Si no, agrégalo.

Escala tipográfica móvil adaptada:

* displayXL: 48px, weight 340/400, lineHeight 1.0, letterSpacing -1.2
* displayLG: 40px, weight 340/400, lineHeight 1.05, letterSpacing -1.0
* headline: 28px, weight 540/600, lineHeight 1.18, letterSpacing -0.4
* subhead: 24px, weight 340/400, lineHeight 1.25, letterSpacing -0.3
* cardTitle: 22px, weight 700, lineHeight 1.25
* bodyLG: 19px, weight 330/400, lineHeight 1.42
* body: 17px, weight 320/400, lineHeight 1.45
* bodySM: 15px, weight 330/400, lineHeight 1.45
* button: 17px, weight 480/600, lineHeight 1.2
* eyebrow: 12px, mono, uppercase, letterSpacing 0.8

Regla:

* Los títulos deben tener presencia.
* El texto debe respirar.
* No usar textos microscópicos.
* La jerarquía debe ser evidente en 1 segundo.

---

## Spacing

Sistema base 8px:

* hair: 1
* xxs: 4
* xs: 8
* sm: 12
* md: 16
* lg: 24
* xl: 32
* xxl: 48
* section: 72 en móvil
* screen: 20 horizontal

Reglas:

* Nada toca los bordes.
* Usar 20px de padding horizontal fijo en pantallas.
* Separar secciones con 32px o 48px.
* No apilar widgets pegados.
* No abusar de espacios muertos sin intención.

---

## Radius

* xs: 2
* sm: 6
* md: 8
* lg: 24
* xl: 32
* pill: 50
* full: 9999

Reglas:

* Todos los botones deben ser pill.
* Icon buttons circulares.
* Color-block sections con radius 24 o 32.
* Cards internas con radius 16–24.

---

## Elevation

Usar poca sombra.

* Color-block sections: sin sombra.
* Cards normales: border hairline o sombra mínima.
* Bottom navigation: sombra suave si hace falta.
* No sombras exageradas.
* No sombras de color.

---

# COMPONENTES A CREAR O REHACER

Crea o refactoriza componentes reutilizables:

* AppScaffold
* AppText
* AppButton
* AppIconButton
* ColorBlockSection
* SectionEyebrow
* EditorialHeader
* PillButton
* ModuleBlock
* DailyActionBlock
* MoodSelector
* TimerBlock
* ProgressBlock
* ContentBlock
* SettingsRow
* MediaBlock
* BottomNavigation

Todo debe compartir el mismo lenguaje visual.

Si existen componentes viejos que producen UI fea, reemplázalos.

---

# PANTALLAS A REHACER

## Splash

Debe ser limpio y fuerte.

* Fondo negro o color block.
* Texto grande: ErgoKawsay.
* Subtítulo: Bienestar y Salud Intercultural.
* Nada de ilustraciones genéricas.
* Nada de loaders feos.
* Transición limpia.

---

## Selección de idioma

Debe sentirse como onboarding premium.

* Título grande.
* Texto breve.
* Dos opciones grandes: Español / Kichwa.
* Cards tipo color block.
* Botón pill para continuar.
* Estado seleccionado claro.

---

## Home

REHACER COMPLETAMENTE.

No debe parecer dashboard corporativo ni catálogo infinito.

Estructura recomendada:

1. Header editorial:

   * Saludo según hora.
   * Frase principal: “Tu bienestar empieza hoy”.
   * Texto corto de apoyo.

2. Color-block principal:

   * Acción recomendada del día.
   * Ejemplo: Pausa activa de 5 minutos / ejercicio de cuello.
   * Botón pill: Comenzar.
   * Duración visible.
   * Diseño amplio, fuerte, limpio.

3. Estado emocional:

   * “¿Cómo te sientes ahora?”
   * Opciones visuales claras.
   * No hacerlo como chips feos.

4. Accesos principales:

   * Ergonomía
   * Pausas activas
   * Ejercicios
   * Consejos
   * Emociones
   * Progreso

   Usar bloques visuales, no cards genéricas.

5. Progreso breve:

   * Pausas realizadas.
   * Ejercicios completados.
   * Emociones registradas.

No mostrar todos los módulos como lista infinita sin jerarquía.

---

## Ergonomía

Debe ser lectura editorial.

Contenido requerido:

* ¿Qué es ergonomía?
* Movimientos repetitivos.
* Causas físicas.
* Zonas afectadas.
* Puesto de corrección.
* Dato clave OMS.

Diseño:

* Header editorial.
* Color blocks por tema.
* Texto bien separado.
* Evitar párrafos gigantes.
* Usar bullets elegantes.

---

## Enfermedades

Debe verse serio, no alarmista.

Contenido:

* Síndrome del túnel carpiano.
* Tendinitis de hombro.
* Lumbalgia crónica.
* Cervicalgia.

Cada enfermedad debe tener:

* Qué es.
* Causa.
* Señal de alerta.
* Cuándo consultar al médico.

Diseño:

* Cards limpias.
* Jerarquía clara.
* Nada saturado.
* Iconografía mínima.

---

## Pausas activas

Debe sentirse como una experiencia guiada.

Contenido:

* Qué son.
* Secuencia de 5 minutos:

  1. Rotación de cuello.
  2. Elevación de hombros.
  3. Estiramiento de muñecas.
  4. Arco lumbar.
  5. Respiración profunda.

Debe incluir:

* Botón iniciar.
* Temporizador.
* Progreso visual.
* Pantalla de sesión guiada.

Diseño:

* Color block principal.
* Timer grande.
* Controles pill.
* Instrucciones claras.

---

## Ejercicios

Categorías:

* Cuello.
* Hombros.
* Manos.
* Espalda.
* Cadera.
* Piernas.
* Vista.
* Respiración consciente.

Cada categoría debe tener ejercicios con:

* Nombre.
* Descripción.
* Duración.
* Botón iniciar.

La pantalla de ejercicio activo debe tener:

* Timer grande.
* Instrucción principal.
* Botones pausar/finalizar.
* Progreso.
* Diseño limpio.

---

## Recordatorios

Debe ser visualmente limpio y configurable.

Contenido:

* Notificaciones activas.
* Frecuencia: 30 min, 1 hora, 2 horas, 3 horas.
* Ejercicio diario: 06:00, 07:00, 08:00.
* Modo silencio: 20:00–06:00.

Diseño:

* Toggles bonitos.
* Selectores pill.
* Secciones claras.
* Guardar localmente si ya existe lógica.

---

## Consejos

Debe verse editorial.

Contenido:

* Ajusta tu silla y escritorio.
* Escritura en pizarra.
* Uso correcto de laptop.
* Varía tus tareas.
* Alterna posturas.
* Cuida tu calzado.

Diseño:

* Bloques pastel.
* Tipografía fuerte.
* Nada de lista aburrida.

---

## Salud mental y emociones

Debe ser de las pantallas más cuidadas.

Contenido:

* Enojo / Soy RumiRumi.
* Tristeza / Soy Yaku.
* Alegría / Soy Inti.
* Miedo / Soy tutam.
* Ansiedad / Soy Chaskym.

Cada emoción debe mostrar:

* Qué es.
* Causas/señales.
* Qué puedo hacer.
* Frase motivacional.

Diseño:

* Emociones como bloques visuales.
* No usar emojis gigantes baratos.
* Usar composición limpia y cálida.
* Guardar emoción si ya existe progreso local.

---

## Música

Contenido:

* Sonidos del Bosque.
* Lluvia suave.
* Música energizante.

Diseño:

* Player visual premium.
* Si no hay audio real, mostrar estado elegante, no placeholder feo.
* Botones circulares/pill.

---

## Videos

Contenido:

* Ergonomía para docentes: postura correcta.
* Yoga de 10 minutos: relajación docente.

Diseño:

* Bloques de video elegantes.
* Thumbnail visual simple.
* Botón reproducir.
* Si no hay video real, placeholder elegante.

---

## Progreso

Debe parecer una pantalla real de seguimiento.

Contenido:

* Ejercicios completados.
* Pausas activas completadas.
* Emociones registradas.
* Días de uso.
* Estadísticas.

Diseño:

* Números grandes.
* Secciones limpias.
* Color blocks.
* No hacer tabla fea.
* No mostrar puro cero sin intención.

---

## Configuración

Contenido:

* Cambiar idioma.
* Notificaciones.
* Información de la app.
* Versión.
* Créditos.

Diseño:

* Filas limpias.
* Botones pill.
* Iconografía circular.
* Nada de settings Flutter genérico.

---

# REGLAS DE IMPLEMENTACIÓN

No hagas otro informe.

No expliques el proyecto.

No expliques el diseño.

No hagas resumen.

No pidas confirmación.

Modifica el código directamente.

Orden de trabajo:

1. Rehacer theme/design system.
2. Rehacer componentes compartidos.
3. Rehacer Home.
4. Rehacer navegación si es necesario.
5. Rehacer pantallas principales.
6. Corregir overflows.
7. Ejecutar análisis si puedes.
8. Dejar el proyecto compilable.

Si algo rompe visualmente la app, cámbialo.

Si algo parece IA, cámbialo.

Si algo parece Flutter por defecto, cámbialo.

Si algo no se alinea con los requisitos de ErgoKawsay, corrígelo.

El resultado esperado es código modificado, no una respuesta larga.
