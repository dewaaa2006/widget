import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/models.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bantuan & FAQ'),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: HelpRepository.questions.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final question = HelpRepository.questions[index];
            return ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 0.0),
              title: Text(
                question.question,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              childrenPadding: const EdgeInsets.only(left: 0, right: 0, bottom: AppSpacing.md),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.answer,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
