import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';
import '../models/daily_reading.dart';
import '../models/styled_text_segment.dart';

class ApiService {
  static const String _usccbBaseUrl = 'https://bible.usccb.org';
  
  final http.Client _client = http.Client();

  Future<DailyReading> getDailyReadingForDate(DateTime targetDate) async {
    try {
      final reading = await _fetchFromUSCCB(targetDate);
      if (reading != null && reading.readings.isNotEmpty) {
        return reading;
      }
      
      return DailyReading(
        id: 'daily_${targetDate.millisecondsSinceEpoch}',
        date: targetDate,
        title: 'Чытанне дня',
        readings: [
          TextSegment('Чытанне дня недоступны'),
        ],
        language: 'en',
        source: 'none',
        link: null,
      );
    } catch (e) {
      throw Exception('Error fetching daily reading: $e');
    }
  }

  Future<DailyReading?> _fetchFromUSCCB(DateTime targetDate) async {
    try {
      final month = targetDate.month.toString().padLeft(2, '0');
      final day = targetDate.day.toString().padLeft(2, '0');
      final year = targetDate.year.toString().substring(2);
      final url = '$_usccbBaseUrl/bible/readings/$month$day$year.cfm';
      
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 10));

      String finalUrl = url;
      String body = response.body;
      
      if (response.statusCode == 200 || response.statusCode == 301 || response.statusCode == 302) {
        var document = html_parser.parse(body);
        
        final redirectMeta = document.querySelector('meta[http-equiv=refresh]');
        if (redirectMeta != null) {
          final content = redirectMeta.attributes['content'];
          if (content != null) {
            final urlMatch = RegExp(r"url=([^\s;]+)").firstMatch(content);
            if (urlMatch != null) {
              final redirectUrl = urlMatch.group(1)!;
              
              final redirectResponse = await _client.get(
                Uri.parse(redirectUrl.startsWith('http') ? redirectUrl : '$_usccbBaseUrl$redirectUrl'),
                headers: {
                  'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                  'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
                },
              ).timeout(const Duration(seconds: 10));
              
              if (redirectResponse.statusCode == 200) {
                body = redirectResponse.body;
                finalUrl = redirectUrl.startsWith('http') ? redirectUrl : '$_usccbBaseUrl$redirectUrl';
                document = html_parser.parse(body);
              }
            }
          }
        }
        
        return _parseUSCCBHtml(document, targetDate, finalUrl);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  DailyReading? _parseUSCCBHtml(Document document, DateTime targetDate, String url) {
    try {
      String title = 'Чытанне дня';
      final titleElement = document.querySelector('h1, .field--name-title, .page-title, title');
      if (titleElement != null) {
        title = titleElement.text.trim();
        title = title.replaceAll(RegExp(r'\s*\|\s*USCCB.*$', caseSensitive: false), '').trim();
      }
      
      List<StyledTextSegment> segments = [];
      
      final innerblocks = document.querySelectorAll('div.innerblock');
      
      for (final innerblock in innerblocks) {
        final heading = innerblock.querySelector('h3.name');
        if (heading == null) continue;
        
        final headingText = heading.text.trim();
        
        // Добавляем заголовок чтения
        segments.add(TitleSegment(headingText));
        
        final addressDiv = innerblock.querySelector('div.address');
        String reference = '';
        
        if (addressDiv != null) {
          final referenceLink = addressDiv.querySelector('a[href*="bible"]');
          if (referenceLink != null) {
            reference = referenceLink.text.trim();
          }
        }
        
        final contentBody = innerblock.querySelector('div.content-body');
        if (contentBody == null) continue;
        
        final text = _extractReadingText(contentBody);
        final cleanText = _cleanText(text);
        
        if (cleanText.isEmpty) continue;
        
        if (reference.isNotEmpty) {
          segments.add(const ParagraphBreakSegment());
          segments.add(BibleVerseSegment(reference, reference));
        }
        
        segments.add(TextSegment(cleanText));
      }
      
      if (segments.isEmpty) {
        return null;
      }
      
      return DailyReading(
        id: 'daily_${targetDate.millisecondsSinceEpoch}',
        date: targetDate,
        title: title,
        readings: segments,
        language: 'en',
        source: 'usccb',
        link: url,
      );
    } catch (e) {
      return null;
    }
  }


  String _extractReadingText(Element element) {
    element.querySelectorAll('h1, h2, h3, h4, h5, h6, nav, .navigation, .menu, header, footer').forEach((e) => e.remove());
    
    final paragraphs = element.querySelectorAll('p');
    if (paragraphs.isNotEmpty) {
      return paragraphs.map((p) {
        String html = p.innerHtml;
        html = html.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ');
        String text = html.replaceAll(RegExp(r'<[^>]+>'), '');
        text = text
            .replaceAll('&nbsp;', ' ')
            .replaceAll('&amp;', '&')
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>')
            .replaceAll('&quot;', '"')
            .replaceAll('&#39;', "'");
        text = text.replaceAll(RegExp(r'[ \t]+'), ' ');
        return text.trim();
      }).where((t) => t.isNotEmpty).join(' ');
    }
    
    String html = element.innerHtml;
    html = html.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ');
    html = html.replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), ' ');
    html = html.replaceAll(RegExp(r'</p>', caseSensitive: false), ' ');
    html = html.replaceAll(RegExp(r'<[^>]+>'), '');
    html = html.replaceAll(RegExp(r'[ \t]+'), ' ');
    return html.trim();
  }

  String _cleanText(String text) {
    if (text.isEmpty) return '';
    
    text = text.replaceAll(RegExp(r'[ \t]+'), ' ');
    text = text.replaceAll(RegExp(r'\n+'), ' ');
    text = text.replaceAll(RegExp(r'[ \t]+'), ' ');
    text = text.trim();
    
    return text;
  }

  void dispose() {
    _client.close();
  }
}

