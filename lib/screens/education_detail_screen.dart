import 'package:material_ui/material_ui.dart';

import '../models/education_article.dart';
import '../navigation/shell_nav.dart';
import '../theme/app_theme.dart';
import '../utils/practice_router.dart';
import '../widgets/common_widgets.dart';

class EducationDetailScreen extends StatelessWidget {
  const EducationDetailScreen({super.key, required this.article});

  final EducationArticle article;

  @override
  Widget build(BuildContext context) {
    final hasPractice = article.relatedPracticeId != null;

    return Scaffold(
      appBar: AppBar(title: Text(article.category)),
      body: AtmosphereBackground(
        child: ListView(
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
            if (hasPractice) ...[
              const SizedBox(height: 16),
              SoftPanel(
                color: AppColors.deep,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Praktikkan sekarang',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.relatedPracticeLabel ??
                          'Latihan terkait artikel ini',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await openPracticeById(
                          context,
                          article.relatedPracticeId,
                        );
                        ShellNav.bump();
                      },
                      child: Text(
                        article.relatedPracticeLabel ?? 'Buka latihan',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
