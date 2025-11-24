import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/prayer.dart';
import '../data/prayers_data.dart';
import 'prayer_detail_screen.dart';

class PrayersListScreen extends StatefulWidget {
  final String category;
  final List<Prayer> prayers;

  const PrayersListScreen({
    super.key,
    required this.category,
    required this.prayers,
  });

  @override
  State<PrayersListScreen> createState() => _PrayersListScreenState();
}

class _PrayersListScreenState extends State<PrayersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Prayer> _filteredPrayers = [];

  @override
  void initState() {
    super.initState();
    _filteredPrayers = widget.prayers;
    _searchController.addListener(_filterPrayers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPrayers() {
    final query = _searchController.text.toLowerCase().trim();
    final currentLocale = Localizations.localeOf(context).languageCode;

    if (query.isEmpty) {
      setState(() {
        _filteredPrayers = widget.prayers;
      });
      return;
    }

    setState(() {
      _filteredPrayers = widget.prayers.where((prayer) {
        final title = prayer.getTitle(currentLocale).toLowerCase();
        final text = prayer.getText(currentLocale).toLowerCase();
        return title.contains(query) || text.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final isLiturgyHours = widget.category == localizations.liturgyHours;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (!isLiturgyHours)
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: localizations.search,
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
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          Expanded(
            child: _filteredPrayers.isEmpty && _searchController.text.isNotEmpty
                ? Center(
                    child: Text(
                      localizations.noResultsFound,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  )
                : (widget.prayers.isEmpty
                    ? Center(
                        child: Text(
                          localizations.noResultsFound,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredPrayers.length,
                        itemBuilder: (context, index) {
                          final prayer = _filteredPrayers[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrayerDetailScreen(prayer: prayer),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      prayer.getTitle(currentLocale.languageCode),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
          ),
        ],
      ),
    );
  }
}

