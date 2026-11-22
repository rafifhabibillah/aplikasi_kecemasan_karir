class Question {
  const Question({
    required this.id,
    required this.dimension,
    required this.text,
    this.isReversed = false,
  });

  final String id;
  final String dimension;
  final String text;
  final bool isReversed;
}

class LikertOption {
  const LikertOption({required this.value, required this.label});

  final int value;
  final String label;
}

const likertOptions = [
  LikertOption(value: 1, label: 'Sangat Tidak Sesuai'),
  LikertOption(value: 2, label: 'Tidak Sesuai'),
  LikertOption(value: 3, label: 'Sesuai'),
  LikertOption(value: 4, label: 'Sangat Sesuai'),
];
