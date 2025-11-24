import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/daily_reading.dart';
import '../models/styled_text_segment.dart';
import '../services/app_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/loading_widget.dart';

class DailyReadingsScreen extends StatefulWidget {
  final DateTime? targetDate;
  
  const DailyReadingsScreen({super.key, this.targetDate});

  @override
  State<DailyReadingsScreen> createState() => _DailyReadingsScreenState();
}

class _DailyReadingsScreenState extends State<DailyReadingsScreen> {
  late DateTime _currentDate;
  late Future<DailyReading> _readingFuture;
  final Set<String> _readReadings = {}; // Хранит ID прочитанных чтений

  @override
  void initState() {
    super.initState();
    _currentDate = widget.targetDate ?? DateTime.now();
    _loadReading();
  }

  void _loadReading() {
    final provider = context.read<AppProvider>();
    _readingFuture = provider.getReadingForDate(_currentDate);
  }

  void _navigateToDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
      _readReadings.clear(); // Очищаем отметки при смене даты
      _loadReading();
    });
  }

  void _selectDate() async {
    final currentLocale = Localizations.localeOf(context);
    
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: currentLocale,
    );
    
    if (selectedDate != null) {
      _navigateToDate(selectedDate);
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  String _formatDate(DateTime date) {
    final localizations = AppLocalizations.of(context)!;
    if (_isToday(date)) {
      return localizations.today;
    }
    return '${date.day}.${date.month}.${date.year}';
  }

  List<ReadingCardData> _extractReadings(DailyReading reading) {
    final List<ReadingCardData> readings = [];
    String? currentTitle;
    String? currentReference;
    String? currentText;

    for (final segment in reading.readings) {
      if (segment is TitleSegment) {
        // Сохраняем предыдущее чтение, если есть
        if (currentTitle != null) {
          readings.add(ReadingCardData(
            title: currentTitle,
            reference: currentReference ?? '',
            text: currentText ?? '',
          ));
        }
        // Начинаем новое чтение
        currentTitle = segment.text;
        currentReference = null;
        currentText = null;
      } else if (segment is BibleVerseSegment && segment.reference != null) {
        currentReference = segment.reference;
      } else if (segment is TextSegment) {
        if (currentText == null) {
          currentText = segment.text;
        } else {
          currentText += ' ${segment.text}';
        }
      }
    }
    
    // Добавляем последнее чтение
    if (currentTitle != null) {
      readings.add(ReadingCardData(
        title: currentTitle,
        reference: currentReference ?? '',
        text: currentText ?? '',
      ));
    }

    return readings;
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
          localizations.dailyReadings,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'serif',
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
      body: FutureBuilder<DailyReading>(
        future: _readingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingWidget(),
            );
          }
          
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.dailyReadingsUnavailable,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildContent(DailyReading reading) {
    final localizations = AppLocalizations.of(context)!;
    const Color maroonColor = Color(0xFF8B0000);
    final readings = _extractReadings(reading);
    final totalReadings = readings.length;
    final readCount = _readReadings.length;

    return Column(
      children: [
        // Темный бордовый блок с датой и прогрессом
        Container(
          color: maroonColor,
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              // Дата с календарем и стрелками
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () {
                        _navigateToDate(_currentDate.subtract(const Duration(days: 1)));
                      },
                    ),
                    InkWell(
                      onTap: _selectDate,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(_currentDate),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.white),
                      onPressed: () {
                        _navigateToDate(_currentDate.add(const Duration(days: 1)));
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
                  widthFactor: totalReadings > 0 ? readCount / totalReadings : 0,
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
                  '${localizations.read}: $readCount из $totalReadings',
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

        const SizedBox(height: 20),

        // Карточки чтений
        Expanded(
          child: readings.isEmpty
              ? Center(
                  child: Text(
                    localizations.noResultsFound,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: readings.length,
                  itemBuilder: (context, index) {
                    final readingData = readings[index];
                    final readingId = '${reading.id}_$index';
                    final isRead = _readReadings.contains(readingId);

                    return _buildReadingCard(
                      title: readingData.title,
                      reference: readingData.reference,
                      text: readingData.text,
                      isRead: isRead,
                      onMark: () {
                        setState(() {
                          if (isRead) {
                            _readReadings.remove(readingId);
                          } else {
                            _readReadings.add(readingId);
                          }
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildReadingCard({
    required String title,
    required String reference,
    required String text,
    required bool isRead,
    required VoidCallback onMark,
  }) {
    const Color maroonColor = Color(0xFF8B0000);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                      title,
                      style: const TextStyle(
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
                            reference,
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
                onTap: onMark,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isRead ? maroonColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isRead ? maroonColor : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isRead ? Icons.check_circle : Icons.circle_outlined,
                        size: 16,
                        color: isRead ? Colors.white : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.mark,
                        style: TextStyle(
                          fontSize: 12,
                          color: isRead ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ReadingCardData {
  final String title;
  final String reference;
  final String text;

  ReadingCardData({
    required this.title,
    required this.reference,
    required this.text,
  });
}
