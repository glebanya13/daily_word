import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_book.dart';
import '../services/bible_service.dart';
import '../widgets/loading_widget.dart';

class BibleChapterScreen extends StatefulWidget {
  final String bookId;
  final String bookName;
  final int chapter;
  final int totalChapters;
  final Function(int, bool) onChapterRead; // Передаем номер главы и статус
  final Set<int> readChapters; // Все прочитанные главы

  const BibleChapterScreen({
    super.key,
    required this.bookId,
    required this.bookName,
    required this.chapter,
    required this.totalChapters,
    required this.onChapterRead,
    required this.readChapters,
  });

  @override
  State<BibleChapterScreen> createState() => _BibleChapterScreenState();
}

class _BibleChapterScreenState extends State<BibleChapterScreen> {
  final BibleService _bibleService = BibleService();
  late Future<BibleChapterData> _chapterFuture;
  int _currentChapter = 1;
  bool _isRead = false;

  @override
  void initState() {
    super.initState();
    _currentChapter = widget.chapter;
    _isRead = widget.readChapters.contains(_currentChapter);
    // Инициализируем с пустым Future, будет обновлен в didChangeDependencies
    _chapterFuture = Future.value(BibleChapterData(
      translation: '',
      translationName: '',
      book: '',
      chapter: 0,
      verses: [],
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadChapter();
  }

  @override
  void didUpdateWidget(BibleChapterScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isRead = widget.readChapters.contains(_currentChapter);
  }

  void _loadChapter() {
    final languageCode = Localizations.localeOf(context).languageCode;
    _chapterFuture = _bibleService.getChapter(widget.bookId, _currentChapter, languageCode: languageCode);
  }

  void _navigateToChapter(int newChapter) {
    if (newChapter < 1 || newChapter > widget.totalChapters) return;
    
    setState(() {
      _currentChapter = newChapter;
      _isRead = widget.readChapters.contains(_currentChapter);
      _loadChapter();
    });
  }

  @override
  void dispose() {
    _bibleService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    const Color maroonColor = Color(0xFF8B0000);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.bookName} $_currentChapter',
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
      body: FutureBuilder<BibleChapterData>(
        future: _chapterFuture,
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
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                localizations.noResultsFound,
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }

          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildContent(BibleChapterData chapterData) {
    final localizations = AppLocalizations.of(context)!;
    const Color maroonColor = Color(0xFF8B0000);
    final readCount = widget.readChapters.length;
    final totalChapters = widget.totalChapters;

    return Column(
      children: [
        // Темный бордовый блок с навигацией и прогрессом
        Container(
          color: maroonColor,
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              // Навигация по главам
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () {
                        _navigateToChapter(_currentChapter - 1);
                      },
                    ),
                    Text(
                      '${localizations.chapter} $_currentChapter',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.white),
                      onPressed: () {
                        _navigateToChapter(_currentChapter + 1);
                      },
                    ),
                  ],
                ),
              ),

              // Прогресс-бар
              Container(
                width: double.infinity,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: totalChapters > 0 ? readCount / totalChapters : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),

              // Текст прогресса
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  '${localizations.read}: $readCount из $totalChapters',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        // Карточка с текстом главы
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: _buildChapterCard(
              chapterData: chapterData,
              localizations: localizations,
              maroonColor: maroonColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChapterCard({
    required BibleChapterData chapterData,
    required AppLocalizations localizations,
    required Color maroonColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${localizations.chapter} $_currentChapter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: maroonColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.menu_book, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${widget.bookName} $_currentChapter',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  final newReadState = !_isRead;
                  widget.onChapterRead(_currentChapter, newReadState);
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isRead ? maroonColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isRead ? maroonColor : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isRead ? Icons.check_circle : Icons.circle_outlined,
                        size: 16,
                        color: _isRead ? Colors.white : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        localizations.mark,
                        style: TextStyle(
                          fontSize: 12,
                          color: _isRead ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Текст стихов
          ...chapterData.verses.map((verse) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: '${verse.verse} ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: verse.text,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
