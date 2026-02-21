import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'info_screen.dart';
import 'life_screen.dart';
import 'settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.selectedTheme,
    required this.selectedThemeIndex,
    required this.darkMode,
    required this.onThemeChanged,
    required this.onDarkModeChanged,
  });

  final AppThemeOption selectedTheme;
  final int selectedThemeIndex;
  final bool darkMode;
  final ValueChanged<int> onThemeChanged;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pageBackground = Theme.of(context).scaffoldBackgroundColor;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final gradient = widget.selectedTheme.appGradient(
      darkMode: widget.darkMode,
    );
    final shellBorder = Color.lerp(scheme.onSurface, scheme.surface, 0.83)!;
    const navHeight = 62.0;
    const navMargin = 10.0;
    final navBottom = navMargin + bottomInset.clamp(0.0, 18.0);
    final contentBottomPadding = navHeight + navBottom + 10;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(decoration: BoxDecoration(gradient: gradient)),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Color.lerp(scheme.surface, pageBackground, 0.35)!,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, contentBottomPadding),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.lerp(scheme.surface, pageBackground, 0.3),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: shellBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Color.lerp(
                          Colors.black,
                          scheme.primary,
                          0.9,
                        )!.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: IndexedStack(
                      index: _tabIndex,
                      children: [
                        LifeScreen(active: _tabIndex == 0),
                        InfoScreen(active: _tabIndex == 1),
                        SettingsScreen(
                          selectedThemeIndex: widget.selectedThemeIndex,
                          darkMode: widget.darkMode,
                          onThemeChanged: widget.onThemeChanged,
                          onDarkModeChanged: widget.onDarkModeChanged,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: navBottom,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(
                          scheme.surface,
                          pageBackground,
                          0.06,
                        )!.withValues(alpha: 0.78),
                        Color.lerp(
                          scheme.surface,
                          pageBackground,
                          0.2,
                        )!.withValues(alpha: 0.66),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: shellBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: navHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 7,
                      ),
                      child: Row(
                        children: [
                          _DockItem(
                            icon: Icons.sports_esports_rounded,
                            selected: _tabIndex == 0,
                            onTap: () => setState(() {
                              _tabIndex = 0;
                            }),
                          ),
                          _DockItem(
                            icon: Icons.menu_book_rounded,
                            selected: _tabIndex == 1,
                            onTap: () => setState(() {
                              _tabIndex = 1;
                            }),
                          ),
                          _DockItem(
                            icon: Icons.tune_rounded,
                            selected: _tabIndex == 2,
                            onTap: () => setState(() {
                              _tabIndex = 2;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: selected
                    ? Color.lerp(scheme.primary, scheme.surface, 0.76)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? Color.lerp(scheme.primary, scheme.surface, 0.22)!
                      : Colors.transparent,
                ),
              ),
              child: Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  scale: selected ? 1.0 : 0.92,
                  child: Icon(
                    icon,
                    size: 23,
                    color: selected
                        ? scheme.onSurface
                        : Color.lerp(scheme.onSurface, scheme.surface, 0.38),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
