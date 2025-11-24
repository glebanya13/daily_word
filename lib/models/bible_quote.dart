class BibleQuote {
  final String bookname;
  final String chapter;
  final String verse;
  final String text;

  BibleQuote({
    required this.bookname,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  factory BibleQuote.fromJson(Map<String, dynamic> json) {
    return BibleQuote(
      bookname: json['bookname'] as String? ?? '',
      chapter: json['chapter'] as String? ?? '',
      verse: json['verse'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }

  String get reference => '$bookname $chapter:$verse';
}

