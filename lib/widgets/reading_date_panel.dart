import 'package:flutter/material.dart';

class ReadingDatePanel extends StatelessWidget {
  final String title;
  final bool isToday;
  final VoidCallback? onTap;

  const ReadingDatePanel({
    super.key,
    required this.title,
    this.isToday = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isToday ? Colors.red[700] : Theme.of(context).primaryColor,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isToday ? Colors.red[700] : Theme.of(context).primaryColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

