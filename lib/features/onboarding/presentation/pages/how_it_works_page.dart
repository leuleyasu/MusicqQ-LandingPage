import 'package:flutter/material.dart';

import '../../../../app/theme/nighttrack_colors.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How it works'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              'MusicQ is your venue operating system.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 14),
            _Step(
              index: 1,
              title: 'Create your organization',
              body:
                  'Set up your venue profile, hours, music policy, and staff roles.',
            ),
            _Step(
              index: 2,
              title: 'Go live with requests & queue',
              body:
                  'Accept customer song requests, manage the queue, and coordinate DJs/admins.',
            ),
            _Step(
              index: 3,
              title: 'Payments & time credits',
              body:
                  'Track payments, time credits, and activity with real-time visibility.',
            ),
            _Step(
              index: 4,
              title: 'Promote events & track revenue',
              body:
                  'Publish events, monitor analytics, and keep customers engaged.',
            ),
            const SizedBox(height: 18),
            Text(
              'This page is a placeholder — next we can connect it to your real onboarding flow.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: NightTrackColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.index,
    required this.title,
    required this.body,
  });

  final int index;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: NightTrackColors.primary.withValues(alpha: 0.25),
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: NightTrackColors.textPrimary,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: NightTrackColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

