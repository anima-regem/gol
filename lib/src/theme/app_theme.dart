import 'package:flutter/material.dart';

enum ThemeFamily { monochrome, color }

enum ThemeTwist { shimmer, pulse, orbit, scanline, sparks, wave, bounce }

class AppThemeOption {
  const AppThemeOption({
    required this.name,
    required this.description,
    required this.family,
    required this.seed,
    required this.twist,
    required this.lightPalette,
    required this.darkPalette,
  });

  final String name;
  final String description;
  final ThemeFamily family;
  final Color seed;
  final ThemeTwist twist;
  final ThemePalette lightPalette;
  final ThemePalette darkPalette;

  ThemePalette resolvedPalette({required bool darkMode}) {
    return darkMode ? darkPalette : lightPalette;
  }

  List<Color> preview({required bool darkMode}) {
    final palette = resolvedPalette(darkMode: darkMode);
    return <Color>[
      palette.background,
      Color.lerp(palette.background, palette.surface, 0.6)!,
      palette.primary,
      palette.accent,
    ];
  }

  LinearGradient appGradient({required bool darkMode}) {
    final palette = resolvedPalette(darkMode: darkMode);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color.lerp(palette.background, palette.backgroundShift, 0.7)!,
        palette.backgroundShift,
        Color.lerp(palette.surface, palette.background, 0.65)!,
      ],
    );
  }

  ThemeData buildThemeData({required bool darkMode}) {
    final palette = resolvedPalette(darkMode: darkMode);
    final base = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: darkMode ? Brightness.dark : Brightness.light,
    );

    final scheme = base.copyWith(
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      secondary: palette.accent,
      onSecondary: palette.onSurface,
      surface: palette.surface,
      onSurface: palette.onSurface,
    );

    final textBase = ThemeData(
      brightness: darkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
    ).textTheme;

    final textTheme = textBase
        .apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
          fontFamily: 'monospace',
        )
        .copyWith(
          headlineMedium: textBase.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.15,
          ),
          titleLarge: textBase.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.1,
          ),
          titleMedium: textBase.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.08,
          ),
          bodyLarge: textBase.bodyLarge?.copyWith(height: 1.34),
          bodyMedium: textBase.bodyMedium?.copyWith(height: 1.32),
          bodySmall: textBase.bodySmall?.copyWith(height: 1.3),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: palette.background,
      dividerColor: Color.lerp(
        palette.onSurface,
        palette.surface,
        darkMode ? 0.68 : 0.82,
      ),
      cardTheme: CardThemeData(
        color: Color.lerp(palette.surface, palette.background, 0.26),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Color.lerp(palette.onSurface, palette.surface, 0.78)!,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: Color.lerp(
          scheme.primary,
          scheme.surface,
          darkMode ? 0.58 : 0.76,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: Color.lerp(scheme.primary, scheme.surface, 0.78),
        backgroundColor: Color.lerp(scheme.surface, scheme.onSurface, 0.08),
        side: BorderSide(
          color: Color.lerp(scheme.onSurface, scheme.surface, 0.75)!,
        ),
        labelStyle: TextStyle(color: scheme.onSurface),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: Color.lerp(scheme.surface, scheme.onSurface, 0.3),
        thumbColor: scheme.primary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return Color.lerp(scheme.onSurface, scheme.surface, 0.7);
        }),
      ),
    );
  }
}

class ThemePalette {
  const ThemePalette({
    required this.primary,
    required this.accent,
    required this.surface,
    required this.background,
    required this.backgroundShift,
    required this.onPrimary,
    required this.onSurface,
  });

  final Color primary;
  final Color accent;
  final Color surface;
  final Color background;
  final Color backgroundShift;
  final Color onPrimary;
  final Color onSurface;
}

const List<AppThemeOption> appThemeOptions = <AppThemeOption>[
  AppThemeOption(
    name: 'Graphite',
    description: 'High-contrast grayscale for crisp simulation visuals.',
    family: ThemeFamily.monochrome,
    seed: Color(0xFF5D6368),
    twist: ThemeTwist.wave,
    lightPalette: ThemePalette(
      primary: Color(0xFF1C1C1C),
      accent: Color(0xFF555555),
      surface: Color(0xFFF1F1F1),
      background: Color(0xFFE6E6E6),
      backgroundShift: Color(0xFFD3D3D3),
      onPrimary: Color(0xFFF7F7F7),
      onSurface: Color(0xFF181818),
    ),
    darkPalette: ThemePalette(
      primary: Color(0xFFD8D8D8),
      accent: Color(0xFF8F8F8F),
      surface: Color(0xFF212121),
      background: Color(0xFF141414),
      backgroundShift: Color(0xFF1C1C1C),
      onPrimary: Color(0xFF121212),
      onSurface: Color(0xFFF0F0F0),
    ),
  ),
  AppThemeOption(
    name: 'Mist',
    description: 'Soft fog-like grayscale with lighter surfaces.',
    family: ThemeFamily.monochrome,
    seed: Color(0xFF8A8E90),
    twist: ThemeTwist.pulse,
    lightPalette: ThemePalette(
      primary: Color(0xFF2B2B2B),
      accent: Color(0xFF7D878D),
      surface: Color(0xFFF7F7F7),
      background: Color(0xFFEEEEEE),
      backgroundShift: Color(0xFFDFE4E7),
      onPrimary: Color(0xFFF9F9F9),
      onSurface: Color(0xFF1D1D1D),
    ),
    darkPalette: ThemePalette(
      primary: Color(0xFFC9CED3),
      accent: Color(0xFF83919B),
      surface: Color(0xFF23272B),
      background: Color(0xFF171A1D),
      backgroundShift: Color(0xFF1E2328),
      onPrimary: Color(0xFF111518),
      onSurface: Color(0xFFE8ECF0),
    ),
  ),
  AppThemeOption(
    name: 'Slate',
    description: 'Denser monochrome palette with deeper panel shading.',
    family: ThemeFamily.monochrome,
    seed: Color(0xFF50555B),
    twist: ThemeTwist.bounce,
    lightPalette: ThemePalette(
      primary: Color(0xFF151515),
      accent: Color(0xFF555E65),
      surface: Color(0xFFE4E4E4),
      background: Color(0xFFD8D8D8),
      backgroundShift: Color(0xFFC9CED2),
      onPrimary: Color(0xFFF5F5F5),
      onSurface: Color(0xFF131313),
    ),
    darkPalette: ThemePalette(
      primary: Color(0xFFD5D8DC),
      accent: Color(0xFF8C959D),
      surface: Color(0xFF23262A),
      background: Color(0xFF181A1D),
      backgroundShift: Color(0xFF21252A),
      onPrimary: Color(0xFF141619),
      onSurface: Color(0xFFE8EBEE),
    ),
  ),
  AppThemeOption(
    name: 'Old Green Geek',
    description: 'Retro phosphor green for classic terminal energy.',
    family: ThemeFamily.color,
    seed: Color(0xFF2D8B4B),
    twist: ThemeTwist.scanline,
    lightPalette: ThemePalette(
      primary: Color(0xFF1E6F33),
      accent: Color(0xFF2EAD56),
      surface: Color(0xFFEAF5E8),
      background: Color(0xFFD8EAD4),
      backgroundShift: Color(0xFFC8E2C1),
      onPrimary: Color(0xFFF4FFF4),
      onSurface: Color(0xFF0F3A1C),
    ),
    darkPalette: ThemePalette(
      primary: Color(0xFF43F286),
      accent: Color(0xFF86FFB8),
      surface: Color(0xFF102317),
      background: Color(0xFF06120B),
      backgroundShift: Color(0xFF0B1B11),
      onPrimary: Color(0xFF04120A),
      onSurface: Color(0xFFB7F9CE),
    ),
  ),
  AppThemeOption(
    name: 'Dark Solaris',
    description: 'Warm amber glow inspired by nighttime Solaris terminals.',
    family: ThemeFamily.color,
    seed: Color(0xFFBC7E0A),
    twist: ThemeTwist.shimmer,
    lightPalette: ThemePalette(
      primary: Color(0xFF8A5A00),
      accent: Color(0xFFC98612),
      surface: Color(0xFFFFF3DF),
      background: Color(0xFFF6E7CC),
      backgroundShift: Color(0xFFEEDAB6),
      onPrimary: Color(0xFFFFF9EE),
      onSurface: Color(0xFF3C2800),
    ),
    darkPalette: ThemePalette(
      primary: Color(0xFFFFC247),
      accent: Color(0xFFFFD982),
      surface: Color(0xFF2A1D06),
      background: Color(0xFF140D02),
      backgroundShift: Color(0xFF241805),
      onPrimary: Color(0xFF2B1800),
      onSurface: Color(0xFFFFE8B2),
    ),
  ),
  AppThemeOption(
    name: 'Solaris Cyan',
    description: 'Electric cyan terminal haze with deep ocean shadows.',
    family: ThemeFamily.color,
    seed: Color(0xFF0E8E9C),
    twist: ThemeTwist.orbit,
    lightPalette: ThemePalette(
      primary: Color(0xFF0D6772),
      accent: Color(0xFF15AFC0),
      surface: Color(0xFFE1F8FB),
      background: Color(0xFFCFEFF4),
      backgroundShift: Color(0xFFB8E4EC),
      onPrimary: Color(0xFFF3FEFF),
      onSurface: Color(0xFF003A42),
    ),
    darkPalette: ThemePalette(
      primary: Color(0xFF5CEBFF),
      accent: Color(0xFF9AF6FF),
      surface: Color(0xFF05262B),
      background: Color(0xFF02171B),
      backgroundShift: Color(0xFF033137),
      onPrimary: Color(0xFF002229),
      onSurface: Color(0xFFB5F7FF),
    ),
  ),
  AppThemeOption(
    name: 'Solaris Crimson',
    description: 'Deep crimson phosphor with dramatic noir contrast.',
    family: ThemeFamily.color,
    seed: Color(0xFFC13B3B),
    twist: ThemeTwist.pulse,
    lightPalette: ThemePalette(
      primary: Color(0xFF8E2A2A),
      accent: Color(0xFFD74C4C),
      surface: Color(0xFFFFE7E7),
      background: Color(0xFFF7D4D4),
      backgroundShift: Color(0xFFF0C2C2),
      onPrimary: Color(0xFFFFF2F2),
      onSurface: Color(0xFF4B1010),
    ),
    darkPalette: ThemePalette(
      primary: Color(0xFFFF7D7D),
      accent: Color(0xFFFFB2B2),
      surface: Color(0xFF2B0D0D),
      background: Color(0xFF190707),
      backgroundShift: Color(0xFF2C1010),
      onPrimary: Color(0xFF2B0909),
      onSurface: Color(0xFFFFC8C8),
    ),
  ),
  AppThemeOption(
    name: 'Solaris Lime',
    description: 'Lime phosphor retro feel with ultra-readable dark mode.',
    family: ThemeFamily.color,
    seed: Color(0xFF7B9B15),
    twist: ThemeTwist.scanline,
    lightPalette: ThemePalette(
      primary: Color(0xFF567307),
      accent: Color(0xFF93B80F),
      surface: Color(0xFFF0F6DD),
      background: Color(0xFFE3EECA),
      backgroundShift: Color(0xFFD5E5B3),
      onPrimary: Color(0xFFF8FDEB),
      onSurface: Color(0xFF2E3A06),
    ),
    darkPalette: ThemePalette(
      primary: Color(0xFFCDFE46),
      accent: Color(0xFFE4FF92),
      surface: Color(0xFF1C2707),
      background: Color(0xFF121905),
      backgroundShift: Color(0xFF24330A),
      onPrimary: Color(0xFF1C2605),
      onSurface: Color(0xFFE9FFC1),
    ),
  ),
];
