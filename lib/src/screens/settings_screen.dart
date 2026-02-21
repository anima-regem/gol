import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.selectedThemeIndex,
    required this.darkMode,
    required this.onThemeChanged,
    required this.onDarkModeChanged,
  });

  final int selectedThemeIndex;
  final bool darkMode;
  final ValueChanged<int> onThemeChanged;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = appThemeOptions[selectedThemeIndex];

    final monochromeIndexes = <int>[];
    final colorIndexes = <int>[];
    for (var i = 0; i < appThemeOptions.length; i++) {
      if (appThemeOptions[i].family == ThemeFamily.monochrome) {
        monochromeIndexes.add(i);
      } else {
        colorIndexes.add(i);
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsHero(selected: selected, darkMode: darkMode),
            const SizedBox(height: 12),
            _ModeToggleTile(
              darkMode: darkMode,
              onDarkModeChanged: onDarkModeChanged,
            ),
            const SizedBox(height: 16),
            _SectionTitle(
              icon: Icons.contrast_rounded,
              title: 'Monochrome Themes',
              subtitle: 'Focused palettes that highlight grid behavior.',
            ),
            const SizedBox(height: 10),
            _ThemeGrid(
              indexes: monochromeIndexes,
              selectedThemeIndex: selectedThemeIndex,
              darkMode: darkMode,
              onThemeChanged: onThemeChanged,
            ),
            const SizedBox(height: 14),
            _SectionTitle(
              icon: Icons.palette_outlined,
              title: 'Solaris Styles',
              subtitle: 'Each style includes its own playful microinteraction.',
            ),
            const SizedBox(height: 10),
            _ThemeGrid(
              indexes: colorIndexes,
              selectedThemeIndex: selectedThemeIndex,
              darkMode: darkMode,
              onThemeChanged: onThemeChanged,
            ),
            const SizedBox(height: 8),
            Text(
              'Default is Dark Solaris in dark mode for a terminal-night look.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Color.lerp(scheme.onSurface, scheme.surface, 0.56),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsHero extends StatelessWidget {
  const _SettingsHero({required this.selected, required this.darkMode});

  final AppThemeOption selected;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: selected.appGradient(darkMode: darkMode),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Color.lerp(scheme.onSurface, scheme.surface, 0.74)!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Re-theme the app instantly and tune contrast for your environment.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Color.lerp(scheme.onSurface, scheme.surface, 0.56),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              Chip(
                label: Text(selected.name),
                avatar: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 16,
                ),
                visualDensity: VisualDensity.compact,
              ),
              Chip(
                label: Text(darkMode ? 'Dark Mode' : 'Light Mode'),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeToggleTile extends StatelessWidget {
  const _ModeToggleTile({
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.lerp(
          Theme.of(context).scaffoldBackgroundColor,
          scheme.surface,
          0.3,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.lerp(scheme.onSurface, scheme.surface, 0.78)!,
        ),
      ),
      child: SwitchListTile(
        value: darkMode,
        onChanged: onDarkModeChanged,
        secondary: Icon(Icons.dark_mode_rounded, color: scheme.primary),
        title: Text(
          'Dark Mode',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        subtitle: Text(
          'Switch between light and dark for visual comfort.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Color.lerp(scheme.onSurface, scheme.surface, 0.58),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: scheme.primary),
            const SizedBox(width: 6),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Color.lerp(scheme.onSurface, scheme.surface, 0.58),
          ),
        ),
      ],
    );
  }
}

class _ThemeGrid extends StatelessWidget {
  const _ThemeGrid({
    required this.indexes,
    required this.selectedThemeIndex,
    required this.darkMode,
    required this.onThemeChanged,
  });

  final List<int> indexes;
  final int selectedThemeIndex;
  final bool darkMode;
  final ValueChanged<int> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 680
            ? 3
            : constraints.maxWidth >= 420
            ? 2
            : 1;
        final spacing = 10.0;
        final width =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final index in indexes)
              SizedBox(
                width: width,
                child: ThemeChoiceTile(
                  option: appThemeOptions[index],
                  selected: index == selectedThemeIndex,
                  darkMode: darkMode,
                  onTap: () => onThemeChanged(index),
                ),
              ),
          ],
        );
      },
    );
  }
}

class ThemeChoiceTile extends StatelessWidget {
  const ThemeChoiceTile({
    super.key,
    required this.option,
    required this.selected,
    required this.darkMode,
    required this.onTap,
  });

  final AppThemeOption option;
  final bool selected;
  final bool darkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? Color.lerp(scheme.primary, scheme.surface, 0.88)
          : Color.lerp(
              Theme.of(context).scaffoldBackgroundColor,
              scheme.surface,
              0.32,
            ),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? scheme.primary
                  : Color.lerp(scheme.onSurface, scheme.surface, 0.8)!,
              width: selected ? 1.6 : 1.1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (final color in option.preview(darkMode: darkMode))
                    Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.lerp(
                            scheme.onSurface,
                            scheme.surface,
                            0.7,
                          )!,
                        ),
                      ),
                    ),
                  const Spacer(),
                  _ThemeTwistPreview(
                    twist: option.twist,
                    active: selected,
                    color: scheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                option.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                option.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Color.lerp(scheme.onSurface, scheme.surface, 0.58),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeTwistPreview extends StatefulWidget {
  const _ThemeTwistPreview({
    required this.twist,
    required this.active,
    required this.color,
  });

  final ThemeTwist twist;
  final bool active;
  final Color color;

  @override
  State<_ThemeTwistPreview> createState() => _ThemeTwistPreviewState();
}

class _ThemeTwistPreviewState extends State<_ThemeTwistPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 24,
      height: 24,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final intensity = widget.active ? 1.0 : 0.55;

          switch (widget.twist) {
            case ThemeTwist.shimmer:
              return Stack(
                children: [
                  _twistBase(scheme),
                  Align(
                    alignment: Alignment(-1 + (2 * t), 0),
                    child: Container(
                      width: 6,
                      height: 20,
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.55 * intensity),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              );
            case ThemeTwist.pulse:
              final scale =
                  0.55 + (0.45 * (0.5 + (0.5 * math.sin(t * math.pi * 2))));
              return Center(
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withValues(alpha: 0.8 * intensity),
                    ),
                  ),
                ),
              );
            case ThemeTwist.orbit:
              final angle = t * math.pi * 2;
              return Stack(
                children: [
                  _twistBase(scheme),
                  Align(
                    alignment: Alignment(
                      math.cos(angle) * 0.8,
                      math.sin(angle) * 0.8,
                    ),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color.withValues(alpha: 0.95 * intensity),
                      ),
                    ),
                  ),
                ],
              );
            case ThemeTwist.scanline:
              return Stack(
                children: [
                  _twistBase(scheme),
                  Align(
                    alignment: Alignment(0, -1 + (2 * t)),
                    child: Container(
                      width: 18,
                      height: 2,
                      color: widget.color.withValues(alpha: 0.9 * intensity),
                    ),
                  ),
                ],
              );
            case ThemeTwist.sparks:
              return Stack(
                children: [
                  _twistBase(scheme),
                  for (var i = 0; i < 3; i++)
                    Align(
                      alignment: Alignment(-0.7 + (i * 0.7), 0),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.color.withValues(
                            alpha:
                                (0.35 + (0.65 * ((t + (i * 0.15)) % 1))) *
                                intensity,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            case ThemeTwist.wave:
              return Stack(
                children: [
                  _twistBase(scheme),
                  Align(
                    alignment: Alignment(0, 0.6 * math.sin(t * math.pi * 2)),
                    child: Container(
                      width: 16,
                      height: 4,
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.85 * intensity),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              );
            case ThemeTwist.bounce:
              return Align(
                alignment: Alignment(
                  0,
                  -0.7 + (1.4 * (0.5 + (0.5 * math.sin(t * math.pi * 2)))),
                ),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 0.9 * intensity),
                  ),
                ),
              );
          }
        },
      ),
    );
  }

  Widget _twistBase(ColorScheme scheme) {
    return Center(
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color.lerp(scheme.onSurface, scheme.surface, 0.7)!,
          ),
          color: Color.lerp(scheme.surface, scheme.primary, 0.88),
        ),
      ),
    );
  }
}
