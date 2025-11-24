import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/bible_book.dart';
import '../services/bible_service.dart';
import '../widgets/loading_widget.dart';
import 'bible_chapter_screen.dart';

class BibleChaptersScreen extends StatefulWidget {
  final BibleBook book;

  const BibleChaptersScreen({
    super.key,
    required this.book,
  });

  @override
  State<BibleChaptersScreen> createState() => _BibleChaptersScreenState();
}

class _BibleChaptersScreenState extends State<BibleChaptersScreen> {
  final BibleService _bibleService = BibleService();
  late Future<List<BibleChapter>> _chaptersFuture;
  final Set<int> _readChapters = {}; // Хранит номера прочитанных глав

  @override
  void initState() {
    super.initState();
    // Инициализируем с пустым Future, будет обновлен в didChangeDependencies
    _chaptersFuture = Future.value(<BibleChapter>[]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    _chaptersFuture = _bibleService.getChapters(widget.book.id, languageCode: languageCode);
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
          widget.book.name,
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
      body: FutureBuilder<List<BibleChapter>>(
        future: _chaptersFuture,
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

          final chapters = snapshot.data!;
          final totalChapters = chapters.length;
          final readCount = _readChapters.length;

          return Column(
            children: [
              // Темный бордовый блок с прогрессом
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
                          totalChapters > 0 
                              ? '${(readCount / totalChapters * 100).toInt()}%'
                              : '0%',
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
                        widthFactor: totalChapters > 0 ? readCount / totalChapters : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B0000),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${localizations.read}: $readCount из $totalChapters',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Сетка глав
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    final chapterNumber = chapter.chapter;
                    final isRead = _readChapters.contains(chapterNumber);

                    return InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BibleChapterScreen(
                              bookId: widget.book.id,
                              bookName: widget.book.name,
                              chapter: chapterNumber,
                              totalChapters: totalChapters,
                              onChapterRead: (chapterNum, read) {
                                setState(() {
                                  if (read) {
                                    _readChapters.add(chapterNum);
                                  } else {
                                    _readChapters.remove(chapterNum);
                                  }
                                });
                              },
                              readChapters: _readChapters,
                            ),
                          ),
                        );
                        // Обновляем состояние после возврата
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isRead ? maroonColor.withOpacity(0.2) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: isRead 
                              ? Border.all(color: maroonColor, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '$chapterNumber',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isRead ? maroonColor : Colors.black,
                            ),
                          ),
                        ),
                      ),
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
}
