import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class TimeGreeting extends StatelessWidget {
  const TimeGreeting({super.key});

  String _getGreeting(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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

  @override
  Widget build(BuildContext context) {
    return Text(
      _getGreeting(context),
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 29,
      ),
    );
  }
}

