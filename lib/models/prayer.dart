class Prayer {
  final String id;
  final String titleBe;
  final String titleRu;
  final String titleEn;
  final String textBe;
  final String textRu;
  final String textEn;

  Prayer({
    required this.id,
    required this.titleBe,
    required this.titleRu,
    required this.titleEn,
    required this.textBe,
    required this.textRu,
    required this.textEn,
  });

  String getTitle(String languageCode) {
    switch (languageCode) {
      case 'be':
        return titleBe;
      case 'ru':
        return titleRu;
      case 'en':
      default:
        return titleEn;
    }
  }

  String getText(String languageCode) {
    switch (languageCode) {
      case 'be':
        return textBe;
      case 'ru':
        return textRu;
      case 'en':
      default:
        return textEn;
    }
  }
}


