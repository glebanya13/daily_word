import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ru', 'RU'),
    Locale('be', 'BY'),
  ];

  String get home => _localizedValues[locale.languageCode]?['home'] ?? 'Home';
  String get bible => _localizedValues[locale.languageCode]?['bible'] ?? 'Bible';
  String get prayers => _localizedValues[locale.languageCode]?['prayers'] ?? 'Prayers';
  String get more => _localizedValues[locale.languageCode]?['more'] ?? 'More';
  String get language => _localizedValues[locale.languageCode]?['language'] ?? 'Language';
  String get interfaceLanguage => _localizedValues[locale.languageCode]?['interfaceLanguage'] ?? 'Interface Language';
  String get yesterday => _localizedValues[locale.languageCode]?['yesterday'] ?? 'Yesterday';
  String get today => _localizedValues[locale.languageCode]?['today'] ?? 'Today';
  String get tomorrow => _localizedValues[locale.languageCode]?['tomorrow'] ?? 'Tomorrow';
  String get anotherDay => _localizedValues[locale.languageCode]?['anotherDay'] ?? 'Another Day';
  String get dailyReadings => _localizedValues[locale.languageCode]?['dailyReadings'] ?? 'Daily Readings';
  String get dailyReadingsUnavailable => _localizedValues[locale.languageCode]?['dailyReadingsUnavailable'] ?? 'Daily readings unavailable';
  String get shareApp => _localizedValues[locale.languageCode]?['shareApp'] ?? 'Share Daily Word app';
  String get about => _localizedValues[locale.languageCode]?['about'] ?? 'About';
  String get aboutProgram => _localizedValues[locale.languageCode]?['aboutProgram'] ?? 'About Program';
  String get donations => _localizedValues[locale.languageCode]?['donations'] ?? 'Donations';
  String get help => _localizedValues[locale.languageCode]?['help'] ?? 'Help';
  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';
  String get goodMorning => _localizedValues[locale.languageCode]?['goodMorning'] ?? 'Good Morning';
  String get goodDay => _localizedValues[locale.languageCode]?['goodDay'] ?? 'Good Day';
  String get goodEvening => _localizedValues[locale.languageCode]?['goodEvening'] ?? 'Good Evening';
  String get goodNight => _localizedValues[locale.languageCode]?['goodNight'] ?? 'Good Night';
  String get thanksToYou => _localizedValues[locale.languageCode]?['thanksToYou'] ?? 'This is thanks to you';
  String get thanksMessage => _localizedValues[locale.languageCode]?['thanksMessage'] ?? 'We would like to express our gratitude to the publishers, our partners, volunteers, and those who made donations, for helping to freely spread the Word of God through the Daily Word application.';
  String get rateApp => _localizedValues[locale.languageCode]?['rateApp'] ?? 'Rate Daily Word app';
  String get becomeVolunteer => _localizedValues[locale.languageCode]?['becomeVolunteer'] ?? 'Become a volunteer';
  String get availableLanguages => _localizedValues[locale.languageCode]?['availableLanguages'] ?? 'Available languages: 3';
  String get interfaceLanguageDescription => _localizedValues[locale.languageCode]?['interfaceLanguageDescription'] ?? 'This setting defines the language of the application interface.';
  String get english => _localizedValues[locale.languageCode]?['english'] ?? 'English';
  String get russian => _localizedValues[locale.languageCode]?['russian'] ?? 'Russian';
  String get belarusian => _localizedValues[locale.languageCode]?['belarusian'] ?? 'Belarusian';
  String get productSupport => _localizedValues[locale.languageCode]?['productSupport'] ?? 'Product Support';
  String get supportWebsite => _localizedValues[locale.languageCode]?['supportWebsite'] ?? 'Support service website';
  String get reportAppProblem => _localizedValues[locale.languageCode]?['reportAppProblem'] ?? 'Report an app problem';
  String get contentFeedback => _localizedValues[locale.languageCode]?['contentFeedback'] ?? 'Content feedback';
  String get suggestionsAndIdeas => _localizedValues[locale.languageCode]?['suggestionsAndIdeas'] ?? 'Suggestions and ideas';
  String get spiritualSupport => _localizedValues[locale.languageCode]?['spiritualSupport'] ?? 'Spiritual Support';
  String get askForPrayer => _localizedValues[locale.languageCode]?['askForPrayer'] ?? 'Ask for prayer';
  String get prayersThroughoutDay => _localizedValues[locale.languageCode]?['prayersThroughoutDay'] ?? 'Prayers throughout the day';
  String get search => _localizedValues[locale.languageCode]?['search'] ?? 'Search';
  String get noResultsFound => _localizedValues[locale.languageCode]?['noResultsFound'] ?? 'No results found';
  String get litany => _localizedValues[locale.languageCode]?['litany'] ?? 'Litany';
  String get liturgyHours => _localizedValues[locale.languageCode]?['liturgyHours'] ?? 'Liturgy of the Hours';
  String get prayersCount => _localizedValues[locale.languageCode]?['prayersCount'] ?? 'prayers';
  String get books => _localizedValues[locale.languageCode]?['books'] ?? 'Books';
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';
  String get history => _localizedValues[locale.languageCode]?['history'] ?? 'History';
  String get traditional => _localizedValues[locale.languageCode]?['traditional'] ?? 'Traditional';
  String get alphabetical => _localizedValues[locale.languageCode]?['alphabetical'] ?? 'Alphabetical';
  String get quoteOfTheDay => _localizedValues[locale.languageCode]?['quoteOfTheDay'] ?? 'Quote of the Day';
  String get daysInARow => _localizedValues[locale.languageCode]?['daysInARow'] ?? 'Days in a row';
  String get dayProgress => _localizedValues[locale.languageCode]?['dayProgress'] ?? 'Day\'s progress';
  String get firstReading => _localizedValues[locale.languageCode]?['firstReading'] ?? 'First reading';
  String get gospel => _localizedValues[locale.languageCode]?['gospel'] ?? 'Gospel';
  String get all => _localizedValues[locale.languageCode]?['all'] ?? 'All';
  String get mark => _localizedValues[locale.languageCode]?['mark'] ?? 'Mark';
  String get read => _localizedValues[locale.languageCode]?['read'] ?? 'Read';
  String get overallProgress => _localizedValues[locale.languageCode]?['overallProgress'] ?? 'Overall progress';
  String get allBooks => _localizedValues[locale.languageCode]?['allBooks'] ?? 'All books';
  String get chapters => _localizedValues[locale.languageCode]?['chapters'] ?? 'chapters';
  String get searchBook => _localizedValues[locale.languageCode]?['searchBook'] ?? 'Search book...';
  String get chapter => _localizedValues[locale.languageCode]?['chapter'] ?? 'Chapter';
  String get prayersSectionUnavailable => _localizedValues[locale.languageCode]?['prayersSectionUnavailable'] ?? 'Section temporarily unavailable';
  String get prayersSectionInDevelopment => _localizedValues[locale.languageCode]?['prayersSectionInDevelopment'] ?? 'This section is under development. Please check back later.';

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'home': 'Home',
      'bible': 'Bible',
      'prayers': 'Prayers',
      'more': 'More',
      'language': 'Language',
      'interfaceLanguage': 'Interface Language',
      'yesterday': 'Yesterday',
      'today': 'Today',
      'tomorrow': 'Tomorrow',
      'anotherDay': 'Another Day',
      'dailyReadings': 'Daily Readings',
      'dailyReadingsUnavailable': 'Daily readings unavailable',
      'shareApp': 'Share Daily Word app',
      'about': 'About',
      'aboutProgram': 'About Program',
      'donations': 'Donations',
      'help': 'Help',
      'settings': 'Settings',
      'goodMorning': 'Good Morning',
      'goodDay': 'Good Day',
      'goodEvening': 'Good Evening',
      'goodNight': 'Good Night',
      'thanksToYou': 'This is thanks to you',
      'thanksMessage': 'We would like to express our gratitude to the publishers, our partners, volunteers, and those who made donations, for helping to freely spread the Word of God through the Daily Word application.',
      'rateApp': 'Rate Daily Word app',
      'becomeVolunteer': 'Become a volunteer',
      'availableLanguages': 'Available languages: 3',
      'interfaceLanguageDescription': 'This setting defines the language of the application interface.',
      'english': 'English',
      'russian': 'Russian',
      'belarusian': 'Belarusian',
      'productSupport': 'Product Support',
      'supportWebsite': 'Support service website',
      'reportAppProblem': 'Report an app problem',
      'contentFeedback': 'Content feedback',
      'suggestionsAndIdeas': 'Suggestions and ideas',
      'spiritualSupport': 'Spiritual Support',
      'askForPrayer': 'Ask for prayer',
      'prayersThroughoutDay': 'Prayers throughout the day',
      'search': 'Search',
      'noResultsFound': 'No results found',
      'litany': 'Litany',
      'liturgyHours': 'Liturgy of the Hours',
      'prayersCount': 'prayers',
      'books': 'Books',
      'cancel': 'Cancel',
      'history': 'History',
      'traditional': 'Traditional',
      'alphabetical': 'Alphabetical',
      'quoteOfTheDay': 'Quote of the Day',
      'daysInARow': 'Days in a row',
      'dayProgress': 'Day\'s progress',
      'firstReading': 'First reading',
      'gospel': 'Gospel',
      'all': 'All',
      'mark': 'Mark',
      'read': 'Read',
      'overallProgress': 'Overall progress',
      'allBooks': 'All books',
      'chapters': 'chapters',
      'searchBook': 'Search book...',
      'chapter': 'Chapter',
      'prayersSectionUnavailable': 'Section temporarily unavailable',
      'prayersSectionInDevelopment': 'This section is under development. Please check back later.',
    },
    'ru': {
      'home': 'Главная',
      'bible': 'Библия',
      'prayers': 'Молитвы',
      'more': 'Еще',
      'language': 'Язык',
      'interfaceLanguage': 'Язык интерфейса',
      'yesterday': 'Вчера',
      'today': 'Сегодня',
      'tomorrow': 'Завтра',
      'anotherDay': 'Другой день',
      'dailyReadings': 'Чтения дня',
      'dailyReadingsUnavailable': 'Чтения дня недоступны',
      'shareApp': 'Поделиться приложением Daily Word',
      'about': 'О программе',
      'aboutProgram': 'О программе',
      'donations': 'Пожертвования',
      'help': 'Помощь',
      'settings': 'Настройки',
      'goodMorning': 'Доброе утро',
      'goodDay': 'Добрый день',
      'goodEvening': 'Добрый вечер',
      'goodNight': 'Доброй ночи',
      'thanksToYou': 'Это благодаря вам',
      'thanksMessage': 'Мы хотели бы выразить благодарность издателям, нашим партнерам, волонтерам и тем, кто делал пожертвования, за то, что вы помогаете бесплатно распространять Слово Божье через приложение Daily Word.',
      'rateApp': 'Оценить приложение Daily Word',
      'becomeVolunteer': 'Стать волонтером',
      'availableLanguages': 'Доступно языков: 3',
      'interfaceLanguageDescription': 'Эта настройка задает язык интерфейса приложения.',
      'english': 'Английский',
      'russian': 'Русский',
      'belarusian': 'Белорусский',
      'productSupport': 'Поддержка продукта',
      'supportWebsite': 'Сайт службы поддержки',
      'reportAppProblem': 'Сообщить о проблеме с приложением',
      'contentFeedback': 'Обратная связь по контенту',
      'suggestionsAndIdeas': 'Предложения и идеи',
      'spiritualSupport': 'Духовная поддержка',
      'askForPrayer': 'Попросить о молитве',
      'prayersThroughoutDay': 'Молитвы в течение дня',
      'search': 'Поиск',
      'noResultsFound': 'Ничего не найдено',
      'litany': 'Литания',
      'liturgyHours': 'Литургия часов',
      'prayersCount': 'молитв',
      'books': 'Книги',
      'cancel': 'Отмена',
      'history': 'История',
      'traditional': 'Традиционный',
      'alphabetical': 'По алфавиту',
      'quoteOfTheDay': 'Цитата дня',
      'daysInARow': 'Дней подряд',
      'dayProgress': 'Прогресс дня',
      'firstReading': 'Первое чтение',
      'gospel': 'Евангелие',
      'all': 'Все',
      'mark': 'Отметить',
      'read': 'Прочитано',
      'overallProgress': 'Общий прогресс',
      'allBooks': 'Все книги',
      'chapters': 'глав',
      'searchBook': 'Поиск книги...',
      'chapter': 'Глава',
      'prayersSectionUnavailable': 'Секция временно недоступна',
      'prayersSectionInDevelopment': 'Раздел находится в разработке. Пожалуйста, загляните позже.',
    },
    'be': {
      'home': 'Галоўная',
      'bible': 'Біблія',
      'prayers': 'Малітвы',
      'more': 'Яшчэ',
      'language': 'Мова',
      'interfaceLanguage': 'Мова інтэрфейсу',
      'yesterday': 'Учора',
      'today': 'Сёння',
      'tomorrow': 'Заўтра',
      'anotherDay': 'Іншы дзень',
      'dailyReadings': 'Чытанне дня',
      'dailyReadingsUnavailable': 'Чытанне дня недоступны',
      'shareApp': 'Падзяліцца прыкладаннем Daily Word',
      'about': 'Аб праграме',
      'aboutProgram': 'Аб праграме',
      'donations': 'Ахвяраванні',
      'help': 'Дапамога',
      'settings': 'Налады',
      'goodMorning': 'Добрага ранку',
      'goodDay': 'Добры дзень',
      'goodEvening': 'Добры вечар',
      'goodNight': 'Добрай ночы',
      'thanksToYou': 'Гэта дзякуючы вам',
      'thanksMessage': 'Мы хацелі б выказаць падзяку выдаўцам, нашым партнёрам, валанцёрам і тым, хто рабіў ахвяраванні, за тое, што вы дапамагаеце бясплатна распаўсюджваць Слова Божае праз прыкладанне Daily Word.',
      'rateApp': 'Ацаніць прыкладанне Daily Word',
      'becomeVolunteer': 'Стаць валанцёрам',
      'availableLanguages': 'Даступна моў: 3',
      'interfaceLanguageDescription': 'Гэтая налада задае мову інтэрфейсу прыкладання.',
      'english': 'Англійская',
      'russian': 'Русская',
      'belarusian': 'Беларуская',
      'productSupport': 'Падтрымка прадукту',
      'supportWebsite': 'Сайт службы падтрымкі',
      'reportAppProblem': 'Паведаміць пра праблему з прыкладаннем',
      'contentFeedback': 'Зваротная сувязь па кантэнту',
      'suggestionsAndIdeas': 'Прапановы і ідэі',
      'spiritualSupport': 'Духоўная падтрымка',
      'askForPrayer': 'Прасіць аб малітве',
      'prayersThroughoutDay': 'Малітвы на працягу дня',
      'search': 'Пошук',
      'noResultsFound': 'Нічога не знойдзена',
      'litany': 'Літанія',
      'liturgyHours': 'Літургія гадзін',
      'prayersCount': 'малітваў',
      'books': 'Кнігі',
      'cancel': 'Адмена',
      'history': 'Гісторыя',
      'traditional': 'Традыцыйны',
      'alphabetical': 'Па алфавіту',
      'quoteOfTheDay': 'Цытата дня',
      'daysInARow': 'Дзён запар',
      'dayProgress': 'Прагрэс дня',
      'firstReading': 'Першае чытанне',
      'gospel': 'Евангелле',
      'all': 'Усе',
      'mark': 'Адзначыць',
      'read': 'Прачытана',
      'overallProgress': 'Агульны прагрэс',
      'allBooks': 'Усе кнігі',
      'chapters': 'галоў',
      'searchBook': 'Пошук кнігі...',
      'chapter': 'Глава',
      'prayersSectionUnavailable': 'Секцыя часова недаступная',
      'prayersSectionInDevelopment': 'Раздзел знаходзіцца ў распрацоўцы. Калі ласка, завітайце пазней.',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'be'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

