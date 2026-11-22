import '../models/mindfulness_practice.dart';

const mindfulnessPractices = <MindfulnessPractice>[
  MindfulnessPractice(
    id: 'breathing',
    title: 'Napas box interaktif',
    subtitle: 'Ikuti titik yang berjalan di jalur kotak. Lebih visual, bukan cuma baca instruksi.',
    durationLabel: '3–4 menit',
    kind: PracticeKind.breathing,
    iconName: 'air',
    category: 'Tenangkan tubuh',
    accent: 0xFF1F6F66,
  ),
  MindfulnessPractice(
    id: 'grounding',
    title: 'Grounding 5-4-3-2-1',
    subtitle: 'Pilih dari saran indra yang muncul. Cepat, ringan, dan tidak perlu menulis panjang.',
    durationLabel: '3–5 menit',
    kind: PracticeKind.grounding,
    iconName: 'spa',
    category: 'Tenangkan tubuh',
    accent: 0xFF2F6B4F,
  ),
  MindfulnessPractice(
    id: 'body_scan',
    title: 'Body scan singkat',
    subtitle: 'Sentuh tiap area tubuh, rasakan, lalu lanjut. Cocok saat bahu dan dada terasa kaku.',
    durationLabel: '4 menit',
    kind: PracticeKind.bodyScan,
    iconName: 'accessibility',
    category: 'Tenangkan tubuh',
    accent: 0xFF3D7A72,
  ),
  MindfulnessPractice(
    id: 'mindful_pause',
    title: 'Jeda mindful karier',
    subtitle: 'Pilih kekhawatiran, temani rasa itu, lalu pilih respons kecil yang realistis.',
    durationLabel: '5 menit',
    kind: PracticeKind.mindfulPause,
    iconName: 'self_improvement',
    category: 'Fokus pikiran',
    accent: 0xFFB7791F,
  ),
  MindfulnessPractice(
    id: 'worry_sort',
    title: 'Pilah rasa khawatir',
    subtitle: 'Sortir mana yang bisa kamu kendalikan hari ini, dan mana yang perlu dilepas dulu.',
    durationLabel: '3 menit',
    kind: PracticeKind.worrySort,
    iconName: 'filter',
    category: 'Fokus pikiran',
    accent: 0xFF8A5A2B,
  ),
  MindfulnessPractice(
    id: 'strength_pick',
    title: 'Ambil 3 kekuatanmu',
    subtitle: 'Ingatkan diri pada modal yang sudah kamu punya sebelum memikirkan masa depan.',
    durationLabel: '3 menit',
    kind: PracticeKind.strengthPick,
    iconName: 'star',
    category: 'Arah karier',
    accent: 0xFF2A6F8F,
  ),
];

const journalPrompts = <String>[
  'Apa yang paling membuatku cemas soal karier hari ini?',
  'Satu hal tentang masa depan yang masih dalam kendaliku adalah…',
  'Kalau aku berbicara lembut pada diriku sendiri, aku akan bilang…',
  'Tekanan dari siapa yang paling terasa hari ini, dan apa faktanya?',
  'Langkah kecil apa yang bisa kulakukan dalam 15 menit ke depan?',
];

const suggestedCareerSteps = <String>[
  'Catat 3 minat yang sering muncul minggu ini',
  'Baca 1 artikel tentang jurusan yang sedang kupertimbangkan',
  'Tanya 1 pertanyaan ke guru BK / orang yang lebih berpengalaman',
  'Buat daftar pro-kontra singkat untuk 2 pilihan karier',
  'Luangkan 10 menit latihan napas saat cemas muncul',
];
