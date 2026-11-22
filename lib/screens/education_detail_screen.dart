import 'package:flutter/material.dart';

import '../models/education_article.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class EducationDetailScreen extends StatelessWidget {
  const EducationDetailScreen({super.key, required this.article});

  final EducationArticle article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.category)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            article.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '${article.minutes} menit baca',
            style: const TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 18),
          SoftPanel(
            child: Text(
              article.body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.55,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
