class Word {
  final int id;
  final String category;
  final String indonesia;
  final String indonesiaAudio;
  final String arabic;
  final String arabicAudio;
  final String english;
  final String englishAudio;

  Word({
    required this.id,
    required this.category,
    required this.indonesia,
    required this.indonesiaAudio,
    required this.arabic,
    required this.arabicAudio,
    required this.english,
    required this.englishAudio,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'indonesia': indonesia,
      'indonesia_audio': indonesiaAudio,
      'arabic': arabic,
      'arabic_audio': arabicAudio,
      'english': english,
      'english_audio': englishAudio,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'] ?? 0,
      category: map['category'] ?? '',
      indonesia: map['indonesia'] ?? '',
      indonesiaAudio: map['indonesia_audio'] ?? '',
      arabic: map['arabic'] ?? '',
      arabicAudio: map['arabic_audio'] ?? '',
      english: map['english'] ?? '',
      englishAudio: map['english_audio'] ?? '',
    );
  }
}
