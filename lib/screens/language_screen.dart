import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/language_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.language,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                localizations.interfaceLanguage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                localizations.availableLanguages,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                localizations.interfaceLanguageDescription,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              _buildLanguageOption(
                context,
                languageCode: 'en',
                countryCode: 'US',
                name: localizations.english,
                currentLocale: languageProvider.locale,
                onTap: () {
                  languageProvider.setLocale(const Locale('en', 'US'));
                },
              ),
              _buildLanguageOption(
                context,
                languageCode: 'ru',
                countryCode: 'RU',
                name: localizations.russian,
                currentLocale: languageProvider.locale,
                onTap: () {
                  languageProvider.setLocale(const Locale('ru', 'RU'));
                },
              ),
              _buildLanguageOption(
                context,
                languageCode: 'be',
                countryCode: 'BY',
                name: localizations.belarusian,
                currentLocale: languageProvider.locale,
                onTap: () {
                  languageProvider.setLocale(const Locale('be', 'BY'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String languageCode,
    required String countryCode,
    required String name,
    required Locale currentLocale,
    required VoidCallback onTap,
  }) {
    final isSelected = currentLocale.languageCode == languageCode;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
                name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Colors.red,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

