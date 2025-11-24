import 'styled_text_segment.dart';

// Модель дневных чтений (аналогично ReadingsModel в Lectionary)
class DailyReading {
  final String id;
  final DateTime date;
  final String title;
  
  // Массив стилизованных сегментов текста (как в Lectionary)
  final List<StyledTextSegment> readings;
  
  final String language;
  final String? source;
  final String? link;

  DailyReading({
    required this.id,
    required this.date,
    required this.title,
    required this.readings,
    required this.language,
    this.source,
    this.link,
  });

  factory DailyReading.fromJson(Map<String, dynamic> json) {
    return DailyReading(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      title: json['title'] ?? '',
      readings: (json['readings'] as List<dynamic>?)
          ?.map((r) => _segmentFromJson(r as Map<String, dynamic>))
          .toList() ?? [],
      language: json['language'] ?? 'be',
      source: json['source'],
      link: json['link'],
    );
  }

  static StyledTextSegment _segmentFromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'title':
        return TitleSegment(json['text'] as String);
      case 'liturgicalDate':
        return LiturgicalDateSegment(json['text'] as String);
      case 'text':
        return TextSegment(json['text'] as String);
      case 'bibleVerse':
        return BibleVerseSegment(
          json['text'] as String,
          json['reference'] as String?,
        );
      case 'source':
        return SourceSegment(json['text'] as String);
      case 'responseTitle':
        return const ResponseTitleSegment();
      case 'paragraphBreak':
        return const ParagraphBreakSegment();
      case 'lineBreak':
        return const LineBreakSegment();
      default:
        return TextSegment('');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'readings': readings.map((r) => _segmentToJson(r)).toList(),
      'language': language,
      'source': source,
      'link': link,
    };
  }

  Map<String, dynamic> _segmentToJson(StyledTextSegment segment) {
    switch (segment) {
      case TitleSegment(:final text):
        return {'type': 'title', 'text': text};
      case LiturgicalDateSegment(:final text):
        return {'type': 'liturgicalDate', 'text': text};
      case TextSegment(:final text):
        return {'type': 'text', 'text': text};
      case BibleVerseSegment(:final text, :final reference):
        return {'type': 'bibleVerse', 'text': text, 'reference': reference};
      case SourceSegment(:final text):
        return {'type': 'source', 'text': text};
      case ResponseTitleSegment():
        return {'type': 'responseTitle'};
      case ParagraphBreakSegment():
        return {'type': 'paragraphBreak'};
      case LineBreakSegment():
        return {'type': 'lineBreak'};
    }
  }

  String get formattedDate {
    return '${date.day}.${date.month}.${date.year}';
  }
}
