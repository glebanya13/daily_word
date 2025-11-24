import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_book.dart';
import '../services/bible_service.dart';
import '../widgets/loading_widget.dart';
import 'bible_chapters_screen.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  final BibleService _bibleService = BibleService();
  late Future<List<BibleBook>> _booksFuture;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, double> _bookProgress = {}; // Моковые данные прогресса
  
  // Стандартное количество глав для каждой книги Библии (новые ID)
  static const Map<String, int> _standardChaptersCount = {
    'genesis': 50, 'exodus': 40, 'leviticus': 27, 'numbers': 36, 'deuteronomy': 34,
    'joshua': 24, 'judges': 21, 'ruth': 4, '1-samuel': 31, '2-samuel': 24,
    '1-kings': 22, '2-kings': 25, '1-chronicles': 29, '2-chronicles': 36, 'ezra': 10,
    'nehemiah': 13, 'esther': 10, 'job': 42, 'psalms': 150, 'proverbs': 31,
    'ecclesiastes': 12, 'song-of-solomon': 8, 'isaiah': 66, 'jeremiah': 52, 'lamentations': 5,
    'ezekiel': 48, 'daniel': 12, 'hosea': 14, 'joel': 3, 'amos': 9,
    'obadiah': 1, 'jonah': 4, 'micah': 7, 'nahum': 3, 'habakkuk': 3,
    'zephaniah': 3, 'haggai': 2, 'zechariah': 14, 'malachi': 4,
    'matthew': 28, 'mark': 16, 'luke': 24, 'john': 21, 'acts': 28,
    'romans': 16, '1-corinthians': 16, '2-corinthians': 13, 'galatians': 6, 'ephesians': 6,
    'philippians': 4, 'colossians': 4, '1-thessalonians': 5, '2-thessalonians': 3, '1-timothy': 6,
    '2-timothy': 4, 'titus': 3, 'philemon': 1, 'hebrews': 13, 'james': 5,
    '1-peter': 5, '2-peter': 3, '1-john': 5, '2-john': 1, '3-john': 1,
    'jude': 1, 'revelation': 22,
  };

  @override
  void initState() {
    super.initState();
    _initializeMockProgress();
    // Инициализируем с пустым Future, будет обновлен в didChangeDependencies
    _booksFuture = Future.value(<BibleBook>[]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    _booksFuture = _bibleService.getBooks(languageCode: languageCode);
  }

  void _initializeMockProgress() {
    // Моковые данные прогресса для демонстрации
    _bookProgress['genesis'] = 0.45;
    _bookProgress['exodus'] = 0.20;
    _bookProgress['leviticus'] = 0.15;
  }

  int _getChaptersCount(String bookId) {
    return _standardChaptersCount[bookId] ?? 0;
  }

  double _calculateOverallProgress(List<BibleBook> books) {
    if (books.isEmpty) return 0.0;
    double totalProgress = 0.0;
    for (final book in books) {
      totalProgress += _bookProgress[book.id] ?? 0.0;
    }
    return totalProgress / books.length;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bibleService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const Color maroonColor = Color(0xFF8B0000);
    const Color goldColor = Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          localizations.bible,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: maroonColor,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: maroonColor,
          ),
        ),
      ),
      body: FutureBuilder<List<BibleBook>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingWidget(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                localizations.noResultsFound,
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }

          final allBooks = snapshot.data!;
          final query = _searchController.text.toLowerCase().trim();
          final books = query.isEmpty
              ? allBooks
              : allBooks.where((book) => book.name.toLowerCase().contains(query)).toList();
          
          final overallProgress = _calculateOverallProgress(allBooks);

          return Column(
            children: [
              // Темный красный блок с прогрессом
              Container(
                color: maroonColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    // Прогресс-бар
                    Row(
                      children: [
                        Text(
                          localizations.overallProgress,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(overallProgress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: overallProgress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B0000), // Темнее бордового
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Поисковая строка
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[50],
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: localizations.searchBook,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: maroonColor),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),

              // Заголовок "Все книги"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: Colors.grey[50],
                child: Row(
                  children: [
                    const Icon(Icons.menu_book, color: maroonColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      localizations.allBooks,
                      style: const TextStyle(
                        color: maroonColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Список книг
              Expanded(
                child: books.isEmpty
                    ? Center(
                        child: Text(
                          localizations.noResultsFound,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          final chaptersCount = _getChaptersCount(book.id);
                          final progress = _bookProgress[book.id] ?? 0.0;
                          final progressPercent = (progress * 100).toInt();

                          return _buildBookCard(
                            book: book,
                            chaptersCount: chaptersCount,
                            progress: progress,
                            progressPercent: progressPercent,
                            maroonColor: maroonColor,
                            goldColor: goldColor,
                            localizations: localizations,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookCard({
    required BibleBook book,
    required int chaptersCount,
    required double progress,
    required int progressPercent,
    required Color maroonColor,
    required Color goldColor,
    required AppLocalizations localizations,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BibleChaptersScreen(
              book: book,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Вертикальная красная полоска
            Container(
              width: 4,
              height: 80,
              decoration: BoxDecoration(
                color: maroonColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Информация о книге
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B0000),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$chaptersCount ${localizations.chapters}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Прогресс-бар книги
                    Container(
                      width: double.infinity,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: maroonColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Процент и стрелка
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_upward,
                    color: Color(0xFFD4AF37),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$progressPercent%',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
