import 'package:flutter/foundation.dart';
import '../models/daily_reading.dart';
import 'api_service.dart';

class AppProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<DailyReading> getReadingForDate(DateTime date) async {
    try {
      final reading = await _apiService.getDailyReadingForDate(date);
      return reading;
    } catch (e) {
      throw Exception('Error fetching reading for date: $e');
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
