import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.help,
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
                localizations.productSupport,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              _buildLinkItem(
                context,
                icon: Icons.open_in_new,
                title: localizations.supportWebsite,
                onTap: () {},
              ),
              _buildLinkItem(
                context,
                icon: Icons.bug_report_outlined,
                title: localizations.reportAppProblem,
                onTap: () {},
              ),
              _buildLinkItem(
                context,
                icon: Icons.feedback_outlined,
                title: localizations.contentFeedback,
                onTap: () {},
              ),
              _buildLinkItem(
                context,
                icon: Icons.open_in_new,
                title: localizations.suggestionsAndIdeas,
                onTap: () {},
              ),
              const SizedBox(height: 32),
              Text(
                localizations.spiritualSupport,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              _buildLinkItem(
                context,
                icon: Icons.favorite_outline,
                title: localizations.askForPrayer,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
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
            Icon(
              icon,
              color: Colors.black,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
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
  }
}

