import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/bible_book.dart';

class BibleService {
  static const String _baseUrl = 'https://cdn.jsdelivr.net/gh/wldeh/bible-api/bibles';
  final http.Client _client = http.Client();
  
  // Маппинг языков интерфейса на версии Библии
  static const Map<String, String> _versionMap = {
    'en': 'en-kjv', // King James Version для английского
    'ru': 'en-kjv', // Временно используем английский текст
    'be': 'en-kjv', // Временно используем английский текст
  };
  
  // Список стандартных книг Библии
  static const List<Map<String, dynamic>> _standardBooks = [
    {'id': 'genesis', 'name': 'Genesis', 'nameRu': 'Бытие', 'nameBe': 'Быццё', 'chapters': 50},
    {'id': 'exodus', 'name': 'Exodus', 'nameRu': 'Исход', 'nameBe': 'Выхад', 'chapters': 40},
    {'id': 'leviticus', 'name': 'Leviticus', 'nameRu': 'Левит', 'nameBe': 'Лявіт', 'chapters': 27},
    {'id': 'numbers', 'name': 'Numbers', 'nameRu': 'Числа', 'nameBe': 'Лікі', 'chapters': 36},
    {'id': 'deuteronomy', 'name': 'Deuteronomy', 'nameRu': 'Второзаконие', 'nameBe': 'Другі закон', 'chapters': 34},
    {'id': 'joshua', 'name': 'Joshua', 'nameRu': 'Иисус Навин', 'nameBe': 'Ісус Навін', 'chapters': 24},
    {'id': 'judges', 'name': 'Judges', 'nameRu': 'Судьи', 'nameBe': 'Судзі', 'chapters': 21},
    {'id': 'ruth', 'name': 'Ruth', 'nameRu': 'Руфь', 'nameBe': 'Рут', 'chapters': 4},
    {'id': '1-samuel', 'name': '1 Samuel', 'nameRu': '1 Царств', 'nameBe': '1 Царстваў', 'chapters': 31},
    {'id': '2-samuel', 'name': '2 Samuel', 'nameRu': '2 Царств', 'nameBe': '2 Царстваў', 'chapters': 24},
    {'id': '1-kings', 'name': '1 Kings', 'nameRu': '3 Царств', 'nameBe': '3 Царстваў', 'chapters': 22},
    {'id': '2-kings', 'name': '2 Kings', 'nameRu': '4 Царств', 'nameBe': '4 Царстваў', 'chapters': 25},
    {'id': '1-chronicles', 'name': '1 Chronicles', 'nameRu': '1 Паралипоменон', 'nameBe': '1 Параліпамён', 'chapters': 29},
    {'id': '2-chronicles', 'name': '2 Chronicles', 'nameRu': '2 Паралипоменон', 'nameBe': '2 Параліпамён', 'chapters': 36},
    {'id': 'ezra', 'name': 'Ezra', 'nameRu': 'Ездра', 'nameBe': 'Эздра', 'chapters': 10},
    {'id': 'nehemiah', 'name': 'Nehemiah', 'nameRu': 'Неемия', 'nameBe': 'Неэмія', 'chapters': 13},
    {'id': 'esther', 'name': 'Esther', 'nameRu': 'Есфирь', 'nameBe': 'Эсфір', 'chapters': 10},
    {'id': 'job', 'name': 'Job', 'nameRu': 'Иов', 'nameBe': 'Ёў', 'chapters': 42},
    {'id': 'psalms', 'name': 'Psalms', 'nameRu': 'Псалтирь', 'nameBe': 'Псалтыр', 'chapters': 150},
    {'id': 'proverbs', 'name': 'Proverbs', 'nameRu': 'Притчи', 'nameBe': 'Прыповесці', 'chapters': 31},
    {'id': 'ecclesiastes', 'name': 'Ecclesiastes', 'nameRu': 'Екклесиаст', 'nameBe': 'Эклезіяст', 'chapters': 12},
    {'id': 'song-of-solomon', 'name': 'Song of Solomon', 'nameRu': 'Песнь Песней', 'nameBe': 'Песня Песняў', 'chapters': 8},
    {'id': 'isaiah', 'name': 'Isaiah', 'nameRu': 'Исаия', 'nameBe': 'Ісая', 'chapters': 66},
    {'id': 'jeremiah', 'name': 'Jeremiah', 'nameRu': 'Иеремия', 'nameBe': 'Ерамія', 'chapters': 52},
    {'id': 'lamentations', 'name': 'Lamentations', 'nameRu': 'Плач Иеремии', 'nameBe': 'Плач Ераміі', 'chapters': 5},
    {'id': 'ezekiel', 'name': 'Ezekiel', 'nameRu': 'Иезекииль', 'nameBe': 'Езекііль', 'chapters': 48},
    {'id': 'daniel', 'name': 'Daniel', 'nameRu': 'Даниил', 'nameBe': 'Данііл', 'chapters': 12},
    {'id': 'hosea', 'name': 'Hosea', 'nameRu': 'Осия', 'nameBe': 'Асія', 'chapters': 14},
    {'id': 'joel', 'name': 'Joel', 'nameRu': 'Иоиль', 'nameBe': 'Ёіль', 'chapters': 3},
    {'id': 'amos', 'name': 'Amos', 'nameRu': 'Амос', 'nameBe': 'Амос', 'chapters': 9},
    {'id': 'obadiah', 'name': 'Obadiah', 'nameRu': 'Авдий', 'nameBe': 'Аўдзей', 'chapters': 1},
    {'id': 'jonah', 'name': 'Jonah', 'nameRu': 'Иона', 'nameBe': 'Ёна', 'chapters': 4},
    {'id': 'micah', 'name': 'Micah', 'nameRu': 'Михей', 'nameBe': 'Міхей', 'chapters': 7},
    {'id': 'nahum', 'name': 'Nahum', 'nameRu': 'Наум', 'nameBe': 'Наўм', 'chapters': 3},
    {'id': 'habakkuk', 'name': 'Habakkuk', 'nameRu': 'Аввакум', 'nameBe': 'Авакум', 'chapters': 3},
    {'id': 'zephaniah', 'name': 'Zephaniah', 'nameRu': 'Софония', 'nameBe': 'Сафанія', 'chapters': 3},
    {'id': 'haggai', 'name': 'Haggai', 'nameRu': 'Аггей', 'nameBe': 'Агей', 'chapters': 2},
    {'id': 'zechariah', 'name': 'Zechariah', 'nameRu': 'Захария', 'nameBe': 'Захарый', 'chapters': 14},
    {'id': 'malachi', 'name': 'Malachi', 'nameRu': 'Малахия', 'nameBe': 'Малахія', 'chapters': 4},
    {'id': 'matthew', 'name': 'Matthew', 'nameRu': 'Матфей', 'nameBe': 'Матфей', 'chapters': 28},
    {'id': 'mark', 'name': 'Mark', 'nameRu': 'Марк', 'nameBe': 'Марк', 'chapters': 16},
    {'id': 'luke', 'name': 'Luke', 'nameRu': 'Лука', 'nameBe': 'Лука', 'chapters': 24},
    {'id': 'john', 'name': 'John', 'nameRu': 'Иоанн', 'nameBe': 'Іаан', 'chapters': 21},
    {'id': 'acts', 'name': 'Acts', 'nameRu': 'Деяния', 'nameBe': 'Дзеянні', 'chapters': 28},
    {'id': 'romans', 'name': 'Romans', 'nameRu': 'Римлянам', 'nameBe': 'Рымлянам', 'chapters': 16},
    {'id': '1-corinthians', 'name': '1 Corinthians', 'nameRu': '1 Коринфянам', 'nameBe': '1 Карынфянам', 'chapters': 16},
    {'id': '2-corinthians', 'name': '2 Corinthians', 'nameRu': '2 Коринфянам', 'nameBe': '2 Карынфянам', 'chapters': 13},
    {'id': 'galatians', 'name': 'Galatians', 'nameRu': 'Галатам', 'nameBe': 'Галатам', 'chapters': 6},
    {'id': 'ephesians', 'name': 'Ephesians', 'nameRu': 'Ефесянам', 'nameBe': 'Эфесянам', 'chapters': 6},
    {'id': 'philippians', 'name': 'Philippians', 'nameRu': 'Филиппийцам', 'nameBe': 'Філіп\'янам', 'chapters': 4},
    {'id': 'colossians', 'name': 'Colossians', 'nameRu': 'Колоссянам', 'nameBe': 'Каласянам', 'chapters': 4},
    {'id': '1-thessalonians', 'name': '1 Thessalonians', 'nameRu': '1 Фессалоникийцам', 'nameBe': '1 Фесалонікійцам', 'chapters': 5},
    {'id': '2-thessalonians', 'name': '2 Thessalonians', 'nameRu': '2 Фессалоникийцам', 'nameBe': '2 Фесалонікійцам', 'chapters': 3},
    {'id': '1-timothy', 'name': '1 Timothy', 'nameRu': '1 Тимофею', 'nameBe': '1 Цімафею', 'chapters': 6},
    {'id': '2-timothy', 'name': '2 Timothy', 'nameRu': '2 Тимофею', 'nameBe': '2 Цімафею', 'chapters': 4},
    {'id': 'titus', 'name': 'Titus', 'nameRu': 'Титу', 'nameBe': 'Ціту', 'chapters': 3},
    {'id': 'philemon', 'name': 'Philemon', 'nameRu': 'Филимону', 'nameBe': 'Філімону', 'chapters': 1},
    {'id': 'hebrews', 'name': 'Hebrews', 'nameRu': 'Евреям', 'nameBe': 'Яўрэям', 'chapters': 13},
    {'id': 'james', 'name': 'James', 'nameRu': 'Иаков', 'nameBe': 'Якаў', 'chapters': 5},
    {'id': '1-peter', 'name': '1 Peter', 'nameRu': '1 Петра', 'nameBe': '1 Пятра', 'chapters': 5},
    {'id': '2-peter', 'name': '2 Peter', 'nameRu': '2 Петра', 'nameBe': '2 Пятра', 'chapters': 3},
    {'id': '1-john', 'name': '1 John', 'nameRu': '1 Иоанна', 'nameBe': '1 Іаана', 'chapters': 5},
    {'id': '2-john', 'name': '2 John', 'nameRu': '2 Иоанна', 'nameBe': '2 Іаана', 'chapters': 1},
    {'id': '3-john', 'name': '3 John', 'nameRu': '3 Иоанна', 'nameBe': '3 Іаана', 'chapters': 1},
    {'id': 'jude', 'name': 'Jude', 'nameRu': 'Иуда', 'nameBe': 'Іуда', 'chapters': 1},
    {'id': 'revelation', 'name': 'Revelation', 'nameRu': 'Откровение', 'nameBe': 'Адкрыццё', 'chapters': 22},
  ];

  String _getVersionForLanguage(String languageCode) {
    return _versionMap[languageCode] ?? 'en-kjv';
  }

  String _getBookName(String bookId, String languageCode) {
    final book = _standardBooks.firstWhere(
      (b) => b['id'] == bookId,
      orElse: () => {'name': bookId, 'nameRu': bookId, 'nameBe': bookId},
    );
    
    switch (languageCode) {
      case 'ru':
        return book['nameRu'] as String;
      case 'be':
        return book['nameBe'] as String;
      default:
        return book['name'] as String;
    }
  }

  Future<List<BibleBook>> getBooks({String? languageCode}) async {
    try {
      final lang = languageCode ?? 'en';
      return _standardBooks.map((book) {
        return BibleBook(
          id: book['id'] as String,
          name: _getBookName(book['id'] as String, lang),
          url: '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  Future<List<BibleChapter>> getChapters(String bookId, {String? languageCode}) async {
    try {
      final book = _standardBooks.firstWhere(
        (b) => b['id'] == bookId,
        orElse: () => {'chapters': 0},
      );
      final chaptersCount = book['chapters'] as int;
      
      return List.generate(chaptersCount, (index) {
        return BibleChapter(
          bookId: bookId,
          book: _getBookName(bookId, languageCode ?? 'en'),
          chapter: index + 1,
          url: '',
        );
      });
    } catch (e) {
      throw Exception('Error fetching chapters: $e');
    }
  }

  Future<BibleChapterData> getChapter(String bookId, int chapter, {String? languageCode}) async {
    try {
      final lang = languageCode ?? 'en';
      final version = _getVersionForLanguage(lang);
      final url = '$_baseUrl/$version/books/$bookId/chapters/$chapter.json';
      
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return _parseChapterData(jsonData, bookId, chapter, lang);
      }
      
      throw Exception('Failed to load chapter: ${response.statusCode}. URL: $url');
    } catch (e) {
      throw Exception('Error fetching chapter: $e');
    }
  }

  BibleChapterData _parseChapterData(
    Map<String, dynamic> json,
    String bookId,
    int chapter,
    String languageCode,
  ) {
    List<BibleVerse> verses = [];
    
    // Структура ответа: данные в поле "data" как массив объектов
    if (json.containsKey('data') && json['data'] is List) {
      final dataArray = json['data'] as List<dynamic>;
      verses = dataArray.map((item) {
        if (item is Map<String, dynamic>) {
          // Номер стиха может быть строкой или числом
          final verseNumStr = item['verse']?.toString() ?? '0';
          final verseNum = int.tryParse(verseNumStr) ?? 0;
          final verseText = item['text']?.toString() ?? '';
          
          return BibleVerse(
            verse: verseNum,
            text: verseText,
          );
        }
        return BibleVerse(verse: 0, text: '');
      }).where((v) => v.text.isNotEmpty && v.verse > 0).toList();
      
      // Сортируем стихи по номеру
      verses.sort((a, b) => a.verse.compareTo(b.verse));
    }
    // Fallback: пробуем старую структуру с полем "verses"
    else if (json.containsKey('verses') && json['verses'] is List) {
      final versesJson = json['verses'] as List<dynamic>;
      verses = versesJson.map((v) {
        if (v is Map<String, dynamic>) {
          final verseNum = v['verse'] ?? v['verse_number'] ?? v['number'] ?? 0;
          final verseText = v['text'] ?? v['content'] ?? v['verse_text'] ?? '';
          
          return BibleVerse(
            verse: verseNum is int ? verseNum : (verseNum is String ? int.tryParse(verseNum) ?? 0 : 0),
            text: verseText is String ? verseText : '',
          );
        }
        return BibleVerse(verse: 0, text: '');
      }).where((v) => v.text.isNotEmpty).toList();
    }

    return BibleChapterData(
      translation: json['translation'] is String ? json['translation'] as String : 
                   json['version'] is String ? json['version'] as String : '',
      translationName: json['translation_name'] is String ? json['translation_name'] as String :
                       json['version_name'] is String ? json['version_name'] as String : '',
      book: _getBookName(bookId, languageCode),
      chapter: chapter,
      verses: verses,
    );
  }

  void dispose() {
    _client.close();
  }
}
