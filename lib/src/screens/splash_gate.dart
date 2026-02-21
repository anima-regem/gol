import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplashGate extends StatefulWidget {
  const SplashGate({super.key, required this.child});

  final Widget child;

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  Timer? _timer;
  bool _showApp = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2300), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showApp = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 640),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _showApp
          ? KeyedSubtree(key: const ValueKey('app'), child: widget.child)
          : const _SplashScreen(key: ValueKey('splash')),
    );
  }
}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen({super.key});

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = Theme.of(context).scaffoldBackgroundColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final wave = math.sin(t * math.pi * 2);
        final drift = math.cos(t * math.pi * 2);

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(-0.6 + (wave * 0.25), -0.8),
                      radius: 1.25,
                      colors: <Color>[
                        Color.lerp(scheme.primary, background, 0.7)!,
                        Color.lerp(scheme.surface, background, 0.2)!,
                        background,
                      ],
                      stops: const <double>[0, 0.54, 1],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -40 + (wave * 24),
                top: 95 + (drift * 18),
                child: _GlowBlob(
                  color: Color.lerp(scheme.primary, Colors.white, 0.6)!,
                  size: 190,
                ),
              ),
              Positioned(
                right: -30 + (drift * 20),
                bottom: 100 + (wave * 20),
                child: _GlowBlob(
                  color: Color.lerp(scheme.secondary, Colors.white, 0.52)!,
                  size: 220,
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.rotate(
                      angle: wave * 0.05,
                      child: Container(
                        width: 118,
                        height: 118,
                        decoration: BoxDecoration(
                          color: Color.lerp(scheme.surface, background, 0.18),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color.lerp(
                              scheme.onSurface,
                              scheme.surface,
                              0.7,
                            )!,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: scheme.primary.withValues(alpha: 0.18),
                              blurRadius: 26,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.grid_view_rounded,
                          size: 60,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Game of Life',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                            color: scheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Emergence from simple rules',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Color.lerp(
                          scheme.onSurface,
                          scheme.surface,
                          0.58,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    _PulseGrid(progress: t),
                    const SizedBox(height: 16),
                    _LoadingRail(progress: t),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 44,
                child: Text(
                  'Initializing cellular universe...',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Color.lerp(scheme.onSurface, scheme.surface, 0.56),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 74,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

class _PulseGrid extends StatelessWidget {
  const _PulseGrid({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Color.lerp(
          scheme.surface,
          Theme.of(context).scaffoldBackgroundColor,
          0.2,
        ),
        border: Border.all(
          color: Color.lerp(scheme.onSurface, scheme.surface, 0.79)!,
        ),
      ),
      child: SizedBox(
        width: 208,
        height: 98,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 40,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            final phase = ((index * 19) % 37) / 37;
            final pulse =
                0.2 +
                (0.8 *
                    (0.5 + (0.5 * math.sin((progress + phase) * math.pi * 2))));
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Color.lerp(scheme.surface, scheme.primary, pulse * 0.82),
                borderRadius: BorderRadius.circular(3.5),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoadingRail extends StatelessWidget {
  const _LoadingRail({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 220,
      height: 8,
      decoration: BoxDecoration(
        color: Color.lerp(scheme.surface, scheme.onSurface, 0.18),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Align(
        alignment: Alignment(-1 + (progress * 2), 0),
        child: Container(
          width: 72,
          height: 8,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}
