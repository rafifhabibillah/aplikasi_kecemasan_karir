import '../models/question.dart';

/// Instrumen placeholder untuk prototipe.
/// Nanti diganti dengan item & dimensi final dari peneliti tesis.
const sampleInstrumentTitle = 'Skala Kecemasan Karir (Draft Prototipe)';

const sampleInstrumentNote =
    'Item di bawah ini masih contoh. Setelah instrumen tesis final, '
    'cukup diganti datanya tanpa mengubah alur aplikasi.';

const sampleQuestions = <Question>[
  Question(
    id: 'q1',
    dimension: 'Ketidakpastian Masa Depan',
    text: 'Saya sering khawatir karena belum tahu jurusan atau karier yang tepat untuk saya.',
  ),
  Question(
    id: 'q2',
    dimension: 'Ketidakpastian Masa Depan',
    text: 'Pikiran tentang masa depan membuat saya sulit tenang saat berpikir soal karier.',
  ),
  Question(
    id: 'q3',
    dimension: 'Ketidakpastian Masa Depan',
    text: 'Saya merasa bingung memulai langkah perencanaan karier.',
  ),
  Question(
    id: 'q4',
    dimension: 'Takut Gagal',
    text: 'Saya takut pilihan karier saya akan mengecewakan orang tua atau keluarga.',
  ),
  Question(
    id: 'q5',
    dimension: 'Takut Gagal',
    text: 'Saya khawatir gagal bersaing dengan teman-teman dalam meraih peluang karier.',
  ),
  Question(
    id: 'q6',
    dimension: 'Takut Gagal',
    text: 'Saya sering membayangkan skenario buruk jika keputusan karier saya salah.',
  ),
  Question(
    id: 'q7',
    dimension: 'Kurang Informasi Karier',
    text: 'Saya merasa belum punya cukup informasi tentang dunia kerja atau kuliah.',
  ),
  Question(
    id: 'q8',
    dimension: 'Kurang Informasi Karier',
    text: 'Saya tidak tahu harus bertanya ke siapa tentang pilihan karier.',
  ),
  Question(
    id: 'q9',
    dimension: 'Kurang Informasi Karier',
    text: 'Saya kesulitan memahami minat dan bakat saya sendiri.',
  ),
  Question(
    id: 'q10',
    dimension: 'Tekanan Sosial',
    text: 'Saya merasa tertekan karena banyak orang membandingkan masa depan saya dengan orang lain.',
  ),
  Question(
    id: 'q11',
    dimension: 'Tekanan Sosial',
    text: 'Ekspektasi lingkungan membuat saya cemas dalam menentukan arah karier.',
  ),
  Question(
    id: 'q12',
    dimension: 'Tekanan Sosial',
    text: 'Saya merasa harus segera punya keputusan karier meski belum siap.',
  ),
];
