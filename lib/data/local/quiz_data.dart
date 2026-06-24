import '../models/quiz_question.dart';

const AppQuiz ergonomicsQuiz = AppQuiz(
  id: 'ergonomics',
  title: 'Quiz de Ergonomía',
  subtitle: 'Pon a prueba lo que aprendiste',
  questions: [
    // Correcta: C (index 2)
    QuizQuestion(
      question:
          '¿Cuál es el ángulo correcto de los codos al trabajar en el escritorio?',
      options: ['45°', '120°', '90°', '60°'],
      correctIndex: 2,
      feedback:
          'Los codos deben estar a 90° para evitar tensión en muñecas y hombros. Esta posición distribuye el peso de forma equilibrada.',
    ),
    // Correcta: D (index 3)
    QuizQuestion(
      question: '¿Qué es la ergonomía?',
      options: [
        'Ciencia que estudia las enfermedades infecciosas.',
        'Ciencia que fabrica equipos de oficina.',
        'Ciencia que analiza únicamente la postura corporal.',
        'Ciencia que adapta el trabajo a las personas para proteger su salud y bienestar.',
      ],
      correctIndex: 3,
      feedback:
          'La ergonomía busca adaptar el trabajo a las necesidades de las personas para proteger su salud, prevenir lesiones y mejorar su bienestar.',
    ),
    // Correcta: A (index 0)
    QuizQuestion(
      question:
          '¿Cuál de las siguientes actividades puede generar sobrecarga en manos y muñecas?',
      options: [
        'Utilizar repetidamente el teclado y el ratón.',
        'Caminar por el aula.',
        'Leer un libro.',
        'Conversar con los estudiantes.',
      ],
      correctIndex: 0,
      feedback:
          'El uso continuo del teclado y el ratón puede generar movimientos repetitivos que afectan las manos y muñecas con el tiempo.',
    ),
    // Correcta: A (index 0) — V/F siempre Verdadero primero
    QuizQuestion(
      question:
          'Permanecer de pie durante largas horas puede afectar la zona lumbar.',
      options: ['Verdadero', 'Falso'],
      correctIndex: 0,
      feedback:
          'Las posturas estáticas prolongadas pueden provocar molestias y dolor lumbar.',
    ),
    // Correcta: C (index 2) — orden numérico ascendente
    QuizQuestion(
      question:
          '¿Cuántas personas padecen alguna condición musculoesquelética según la OMS?',
      options: ['500 millones', '980 millones', '1.710 millones', '2.500 millones'],
      correctIndex: 2,
      feedback:
          'Según la OMS 2022, aproximadamente 1.710 millones de personas padecen condiciones musculoesqueléticas en el mundo.',
    ),
    // Correcta: D (index 3)
    QuizQuestion(
      question:
          '¿Dónde debe ubicarse la pantalla del laptop para una postura ergonómica correcta?',
      options: [
        'Por encima de la cabeza',
        'Por debajo del nivel de los ojos',
        'No importa la altura',
        'A la altura de los ojos',
      ],
      correctIndex: 3,
      feedback:
          'La pantalla debe estar a la altura de los ojos para evitar la flexión del cuello que causa cervicalgia.',
    ),
  ],
);

const AppQuiz diseasesQuiz = AppQuiz(
  id: 'diseases',
  title: 'Quiz: Trastornos Musculares',
  subtitle: '¿Reconoces las señales?',
  questions: [
    // Correcta: C (index 2) — sin cambio
    QuizQuestion(
      question:
          '¿Qué enfermedad se caracteriza por hormigueo, dolor y debilidad en la mano debido a la compresión de un nervio en la muñeca?',
      options: [
        'Cervicalgia',
        'Tendinitis de hombro',
        'Síndrome del túnel carpiano',
        'Lumbalgia crónica',
      ],
      correctIndex: 2,
      feedback:
          'El síndrome del túnel carpiano ocurre cuando se comprime un nervio en la muñeca. Puede causar hormigueo, dolor y dificultad para sujetar objetos.',
    ),
    // Correcta: D (index 3)
    QuizQuestion(
      question:
          '¿Cuál es la principal causa de la tendinitis de hombro en los docentes?',
      options: [
        'Permanecer sentado muchas horas.',
        'Caminar durante la jornada laboral.',
        'Leer documentos.',
        'Elevar repetidamente los brazos al escribir en la pizarra.',
      ],
      correctIndex: 3,
      feedback:
          'La elevación frecuente de los brazos puede inflamar los tendones del hombro, generando dolor y limitación de movimiento.',
    ),
    // Correcta: A (index 0) — V/F
    QuizQuestion(
      question:
          'La lumbalgia crónica puede aparecer por permanecer mucho tiempo de pie o sentado.',
      options: ['Verdadero', 'Falso'],
      correctIndex: 0,
      feedback:
          'Permanecer mucho tiempo de pie o sentado puede provocar dolor persistente en la zona lumbar.',
    ),
    // Correcta: A (index 0)
    QuizQuestion(
      question: '¿Cuál de las siguientes es una señal de alerta de la cervicalgia?',
      options: [
        'Rigidez matutina y dolor de cabeza.',
        'Dolor de estómago.',
        'Dolor de oído.',
        'Tos persistente.',
      ],
      correctIndex: 0,
      feedback:
          'La cervicalgia suele manifestarse con dolor y rigidez en el cuello, además de dolor de cabeza e incluso mareos.',
    ),
    // Correcta: C (index 2) — sin cambio
    QuizQuestion(
      question:
          '¿Cuál de las siguientes situaciones requiere consultar al médico?',
      options: [
        'Dolor ocasional después de una jornada de trabajo.',
        'Cansancio al final del día.',
        'Dolor que dura más de 2 semanas o pérdida de fuerza en brazos o manos.',
        'Molestias leves que desaparecen al descansar.',
      ],
      correctIndex: 2,
      feedback:
          'El dolor persistente, el hormigueo, el entumecimiento o la pérdida de fuerza pueden indicar un problema musculoesquelético que requiere evaluación médica.',
    ),
  ],
);
