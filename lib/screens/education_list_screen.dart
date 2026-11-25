import 'package:material_ui/material_ui.dart';

import '../data/sample_articles.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'education_detail_screen.dart';

class EducationListScreen extends StatelessWidget {
  const EducationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Materi edukasi')),
      body: AtmosphereBackground(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          itemCount: sampleArticles.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final article = sampleArticles[index];
            return SoftPanel(
              padding: const EdgeInsets.all(14),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.soft,
                  foregroundColor: AppColors.deep,
                  child: Text(
                    '${article.minutes}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                title: Text(
                  article.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${article.category} · ${article.minutes} menit\n${article.subtitle}',
                    style: const TextStyle(color: AppColors.muted, height: 1.4),
                  ),
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EducationDetailScreen(article: article),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
