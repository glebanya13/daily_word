class BibleBook {
  final String id;
  final String name;
  final String url;

  BibleBook({
    required this.id,
    required this.name,
    required this.url,
  });

  factory BibleBook.fromJson(Map<String, dynamic> json) {
    return BibleBook(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}

class BibleChapter {
  final String bookId;
  final String book;
  final int chapter;
  final String url;

  BibleChapter({
    required this.bookId,
    required this.book,
    required this.chapter,
    required this.url,
  });

  factory BibleChapter.fromJson(Map<String, dynamic> json) {
    return BibleChapter(
      bookId: json['book_id'] as String,
      book: json['book'] as String,
      chapter: json['chapter'] as int,
      url: json['url'] as String,
    );
  }
}

class BibleVerse {
  final int verse;
  final String text;

  BibleVerse({
    required this.verse,
    required this.text,
  });

  factory BibleVerse.fromJson(Map<String, dynamic> json) {
    return BibleVerse(
      verse: json['verse'] is int ? json['verse'] as int : 0,
      text: json['text'] is String ? json['text'] as String : '',
    );
  }
}

class BibleChapterData {
  final String translation;
  final String translationName;
  final String book;
  final int chapter;
  final List<BibleVerse> verses;

  BibleChapterData({
    required this.translation,
    required this.translationName,
    required this.book,
    required this.chapter,
    required this.verses,
  });

  factory BibleChapterData.fromJson(Map<String, dynamic> json) {
    final versesJson = json['verses'] as List<dynamic>? ?? [];
    return BibleChapterData(
      translation: json['translation'] is String ? json['translation'] as String : '',
      translationName: json['translation_name'] is String ? json['translation_name'] as String : '',
      book: json['book'] is String ? json['book'] as String : '',
      chapter: json['chapter'] is int ? json['chapter'] as int : 0,
      verses: versesJson.map((v) {
        if (v is Map<String, dynamic>) {
          return BibleVerse.fromJson(v);
        }
        return BibleVerse(verse: 0, text: '');
      }).toList(),
    );
  }
}

