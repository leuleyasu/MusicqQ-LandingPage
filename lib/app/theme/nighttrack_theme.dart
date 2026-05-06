import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nighttrack_colors.dart';

class NightTrackTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);

    final textTheme = GoogleFonts.spaceGroteskTextTheme(base.textTheme).apply(
      bodyColor: NightTrackColors.textPrimary,
      displayColor: NightTrackColors.textPrimary,
    );

    final colorScheme = base.colorScheme.copyWith(
      brightness: Brightness.dark,
      primary: NightTrackColors.primary,
      secondary: NightTrackColors.accent,
      surface: NightTrackColors.surface,
      onSurface: NightTrackColors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: NightTrackColors.bg,
      colorScheme: colorScheme,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: NightTrackColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
