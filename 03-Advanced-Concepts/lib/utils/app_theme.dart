import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

/// Centralized design system for the app.
///
/// Provides light & dark [ThemeData], a rich semantic color palette
/// (priority levels, status colors), gradients, spacing/radius tokens,
/// and small helpers so screens don't hardcode styling decisions.
class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------------
  // Brand palette
  // ---------------------------------------------------------------------
  static const Color _primaryColor = Color(0xFF3F51B5);
  static const Color _secondaryColor = Color(0xFF5C6BC0);
  static const Color _tertiaryColor = Color(0xFF00BFA5);

  static const Color _primaryColorDark = Color(0xFF90CAF9);
  static const Color _secondaryColorDark = Color(0xFF9FA8DA);
  static const Color _tertiaryColorDark = Color(0xFF64FFDA);

  // Semantic / status palette (kept identical in both themes so meaning
  // never changes between light & dark mode).
  static const Color _highPriorityColor = Color(0xFFE53935);
  static const Color _mediumPriorityColor = Color(0xFFFF9800);
  static const Color _lowPriorityColor = Color(0xFF43A047);
  static const Color _overdueColor = Color(0xFFD32F2F);
  static const Color _completedColor = Color(0xFF388E3C);
  static const Color _infoColor = Color(0xFF1E88E5);
  static const Color _warningColor = Color(0xFFFFB300);

  // ---------------------------------------------------------------------
  // Design tokens — spacing, radius, elevation, motion
  // ---------------------------------------------------------------------
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 24;

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animMedium = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 450);
  static const Curve animCurve = Curves.easeOutCubic;

  // ---------------------------------------------------------------------
  // Public color getters
  // ---------------------------------------------------------------------
  static Color get highPriorityColor => _highPriorityColor;
  static Color get mediumPriorityColor => _mediumPriorityColor;
  static Color get lowPriorityColor => _lowPriorityColor;
  static Color get overdueColor => _overdueColor;
  static Color get completedColor => _completedColor;
  static Color get infoColor => _infoColor;
  static Color get warningColor => _warningColor;

  /// Resolves a priority color from a free-text label. Falls back to
  /// medium priority so unexpected values still render sensibly.
  static Color priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return _highPriorityColor;
      case 'medium':
        return _mediumPriorityColor;
      case 'low':
        return _lowPriorityColor;
      default:
        return _mediumPriorityColor;
    }
  }

  /// A soft two-tone gradient built from a priority color, handy for
  /// chips, badges, or card accent strips.
  static LinearGradient priorityGradient(String priority) {
    final base = priorityColor(priority);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [base, Color.lerp(base, Colors.black, 0.15) ?? base],
    );
  }

  /// The brand gradient used for headers, FAB backgrounds, and hero
  /// sections. Pass [dark] to get the dark-theme variant.
  static LinearGradient brandGradient({bool dark = false}) {
    final colors = dark
        ? [_primaryColorDark, _tertiaryColorDark]
        : [_primaryColor, _tertiaryColor];
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  /// A subtle elevation-style shadow that adapts to light/dark surfaces.
  static List<BoxShadow> softShadow({bool dark = false}) {
    return [
      BoxShadow(
        color: (dark ? Colors.black : _primaryColor).withValues(
          alpha: dark ? 0.35 : 0.08,
        ),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }

  // ---------------------------------------------------------------------
  // Shared text theme (scaled Material 3 type ramp)
  // ---------------------------------------------------------------------
  static TextTheme _textTheme(ColorScheme scheme) {
    final onSurface = scheme.onSurface;
    return TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: onSurface, letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: onSurface),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: onSurface),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: onSurface),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: onSurface),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: onSurface),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: onSurface),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface, letterSpacing: 0.15),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface, letterSpacing: 0.1),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: onSurface, letterSpacing: 0.15),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: onSurface, letterSpacing: 0.25),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: scheme.onSurfaceVariant, letterSpacing: 0.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface, letterSpacing: 0.1),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: onSurface, letterSpacing: 0.5),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant, letterSpacing: 0.5),
    );
  }

  // ---------------------------------------------------------------------
  // Shared component theming (built once per ColorScheme, used by both
  // light & dark ThemeData so visual language stays consistent).
  // ---------------------------------------------------------------------
  static ThemeData _buildTheme(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final textTheme = _textTheme(scheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: scheme.surfaceTint,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.headlineSmall,
        iconTheme: IconThemeData(color: scheme.onSurface),
        systemOverlayStyle: isDark
            ? const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        )
            : const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: isDark ? 2 : 1,
        color: scheme.surfaceContainerLow,
        surfaceTintColor: scheme.surfaceTint,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        margin: const EdgeInsets.symmetric(horizontal: spaceMd, vertical: spaceXs + 2),
        clipBehavior: Clip.antiAlias,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 3,
        highlightElevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        labelStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: spaceMd, vertical: 14),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.12),
          elevation: 2,
          shadowColor: scheme.primary.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: spaceLg, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: textTheme.labelLarge,
          animationDuration: animFast,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: spaceLg, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
          padding: const EdgeInsets.symmetric(horizontal: spaceLg, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: spaceMd, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.primaryContainer,
        disabledColor: scheme.onSurface.withValues(alpha: 0.08),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(color: scheme.onPrimaryContainer),
        padding: const EdgeInsets.symmetric(horizontal: spaceSm, vertical: spaceXs),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.25)),
        ),
        side: BorderSide.none,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: scheme.surfaceTint,
        elevation: 6,
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: scheme.surfaceTint,
        elevation: 4,
        showDragHandle: true,
        dragHandleColor: scheme.onSurfaceVariant.withValues(alpha: 0.4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXLarge)),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: scheme.primary, width: 3),
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.6),
        thickness: 1,
        space: spaceMd,
      ),

      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: spaceMd, vertical: spaceXs),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected) ? scheme.primary : scheme.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
              ? scheme.primary.withValues(alpha: 0.5)
              : scheme.surfaceContainerHighest,
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected) ? scheme.primary : Colors.transparent,
        ),
        checkColor: WidgetStateProperty.all(scheme.onPrimary),
        side: BorderSide(color: scheme.outline, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected) ? scheme.primary : scheme.outline,
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        circularTrackColor: scheme.surfaceContainerHighest,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        textStyle: TextStyle(color: scheme.onInverseSurface, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: spaceSm, vertical: spaceXs),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        actionTextColor: scheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
      ),

      badgeTheme: BadgeThemeData(
        backgroundColor: _highPriorityColor,
        textColor: Colors.white,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.primaryContainer,
        surfaceTintColor: scheme.surfaceTint,
        labelTextStyle: WidgetStateProperty.resolveWith(
              (states) => textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected) ? scheme.onSurface : scheme.onSurfaceVariant,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Public theme factories
  // ---------------------------------------------------------------------
  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
      primary: _primaryColor,
      secondary: _secondaryColor,
      tertiary: _tertiaryColor,
    );
    return _buildTheme(scheme);
  }

  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
      primary: _primaryColorDark,
      secondary: _secondaryColorDark,
      tertiary: _tertiaryColorDark,
    );
    return _buildTheme(scheme);
  }

  /// Builds a fully custom theme from a user-picked seed color, so the
  /// app can offer "dynamic" per-user accent colors beyond the two
  /// defaults above (e.g. a settings screen color picker).
  static ThemeData fromSeed(Color seedColor, {required Brightness brightness}) {
    final scheme = ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
    return _buildTheme(scheme);
  }
}