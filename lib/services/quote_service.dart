import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bible_quote.dart';

class QuoteService {
  static const String _baseUrl = 'https://labs.bible.org/api';
  final http.Client _client = http.Client();

  Future<BibleQuote> getRandomQuote() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/?passage=random&type=json'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        if (jsonData.isNotEmpty) {
          return BibleQuote.fromJson(jsonData[0] as Map<String, dynamic>);
        }
        throw Exception('Empty response from quote API');
      }
      throw Exception('Failed to load quote: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching quote: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

