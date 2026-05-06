import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/nighttrack_theme.dart';

class NightTrackApp extends StatelessWidget {
  const NightTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = buildAppRouter();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'NightTrack',
      theme: NightTrackTheme.dark(),
      routerConfig: router,
    );
  }
}
