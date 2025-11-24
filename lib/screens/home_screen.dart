import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widgets/time_greeting.dart';
import '../widgets/loading_widget.dart';
import '../l10n/app_localizations.dart';
import '../services/app_provider.dart';
import '../services/quote_service.dart';
import '../models/daily_reading.dart';
import '../models/bible_quote.dart';
import '../models/styled_text_segment.dart';
import 'daily_readings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuoteService _quoteService = QuoteService();
  late Future<BibleQuote> _quoteFuture;
  late Future<DailyReading> _todayReadingFuture;

  @override
  void initState() {
    super.initState();
    _quoteFuture = _quoteService.getRandomQuote();
    _loadTodayReading();
  }

  void _loadTodayReading() {
    final provider = context.read<AppProvider>();
    _todayReadingFuture = provider.getReadingForDate(DateTime.now());
  }

  @override
  void dispose() {
    _quoteService.dispose();
    super.dispose();
  }

  String? _extractReferenceByTitle(DailyReading reading, String titleKeyword) {
    bool foundTitle = false;
    for (final segment in reading.readings) {
      if (segment is TitleSegment) {
        final title = segment.text.toLowerCase();
        if (title.contains(titleKeyword.toLowerCase())) {
          foundTitle = true;
          continue;
        }
      }
      if (foundTitle && segment is BibleVerseSegment && segment.reference != null) {
        return segment.reference;
      }
    }
    return null;
  }

  String? _extractReference(DailyReading reading, int index) {
    int count = 0;
    for (final segment in reading.readings) {
      if (segment is BibleVerseSegment && segment.reference != null) {
        if (count == index) {
          return segment.reference;
        }
        count++;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Бордовый цвет для заголовка
    const Color maroonColor = Color(0xFF8B0000);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: maroonColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Темный бордовый заголовок
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 16,
              ),
              decoration: const BoxDecoration(
                color: maroonColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getGreeting(localizations),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Daily Word',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Статистика в header
                  Row(
                    children: [
                      // Дни подряд
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '7',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            localizations.daysInARow,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      // Прогресс дня
                      Row(
                        children: [
                          const Icon(
                            Icons.track_changes,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '60%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            localizations.dayProgress,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Контент
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Цитата дня
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FutureBuilder<BibleQuote>(
                        future: _quoteFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _buildQuoteCard(
                              reference: '',
                              text: 'Загрузка...',
                              author: '',
                            );
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return _buildQuoteCard(
                              reference: '',
                              text: 'Не удалось загрузить цитату',
                              author: '',
                            );
                          }
                          final quote = snapshot.data!;
                          return _buildQuoteCard(
                            reference: quote.reference,
                            text: quote.text,
                            author: '',
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Чтения дня
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: Colors.black87,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    localizations.dailyReadings,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DailyReadingsScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  '${localizations.all} →',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<DailyReading>(
                            future: _todayReadingFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(
                                  child: LoadingWidget(),
                                );
                              }
                              if (snapshot.hasError || !snapshot.hasData) {
                                return const Center(
                                  child: Text('Не удалось загрузить чтения'),
                                );
                              }
                              final reading = snapshot.data!;
                              // Пытаемся найти по заголовкам, иначе по индексу
                              final firstReadingRef = _extractReferenceByTitle(reading, 'first') ??
                                  _extractReferenceByTitle(reading, 'reading') ??
                                  _extractReference(reading, 0);
                              final gospelRef = _extractReferenceByTitle(reading, 'gospel') ??
                                  _extractReference(reading, 1);
                              
                              return Row(
                                children: [
                                  Expanded(
                                    child: _buildReadingCard(
                                      icon: Icons.menu_book,
                                      title: localizations.firstReading,
                                      reference: firstReadingRef ?? '—',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildReadingCard(
                                      icon: Icons.auto_awesome,
                                      title: localizations.gospel,
                                      reference: gospelRef ?? '—',
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting(AppLocalizations localizations) {
    final hour = DateTime.now().hour;
    if (hour <= 11) {
      return localizations.goodMorning;
    } else if (hour > 11 && hour < 16) {
      return localizations.goodDay;
    } else if (hour >= 16 && hour < 18) {
      return localizations.goodEvening;
    } else {
      return localizations.goodNight;
    }
  }

  Widget _buildQuoteCard({
    required String reference,
    required String text,
    required String author,
  }) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.black87,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.quoteOfTheDay,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (reference.isNotEmpty)
            Text(
              reference,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          if (reference.isNotEmpty) const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          if (author.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              author,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReadingCard({
    required IconData icon,
    required String title,
    required String reference,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            reference,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

}
