// Модель сегмента стилизованного текста (аналогично StyledTextSegment в Lectionary)
// В Dart используем sealed классы вместо enum с параметрами
sealed class StyledTextSegment {
  const StyledTextSegment();
}

class TitleSegment extends StyledTextSegment {
  final String text;
  const TitleSegment(this.text);
}

class LiturgicalDateSegment extends StyledTextSegment {
  final String text;
  const LiturgicalDateSegment(this.text);
}

class TextSegment extends StyledTextSegment {
  final String text;
  const TextSegment(this.text);
}

class BibleVerseSegment extends StyledTextSegment {
  final String text;
  final String? reference;
  const BibleVerseSegment(this.text, this.reference);
}

class SourceSegment extends StyledTextSegment {
  final String text;
  const SourceSegment(this.text);
}

class ResponseTitleSegment extends StyledTextSegment {
  const ResponseTitleSegment();
}

class ParagraphBreakSegment extends StyledTextSegment {
  const ParagraphBreakSegment();
}

class LineBreakSegment extends StyledTextSegment {
  const LineBreakSegment();
}
