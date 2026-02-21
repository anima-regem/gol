import 'dart:async';

import 'package:flutter/material.dart';

import '../models/cell_position.dart';

const List<_PatternSpec> _patternSpecs = <_PatternSpec>[
  _PatternSpec(
    title: 'Block',
    type: 'Still Life',
    meaning:
        'A stable structure that never changes. Still lifes represent local equilibrium.',
    rows: 8,
    cols: 8,
    tick: Duration(milliseconds: 380),
    seed: <CellPosition>[
      CellPosition(row: 3, col: 3),
      CellPosition(row: 3, col: 4),
      CellPosition(row: 4, col: 3),
      CellPosition(row: 4, col: 4),
    ],
  ),
  _PatternSpec(
    title: 'Blinker',
    type: 'Oscillator',
    meaning:
        'Flips between vertical and horizontal every generation. A clean period-2 oscillator.',
    rows: 9,
    cols: 9,
    tick: Duration(milliseconds: 320),
    seed: <CellPosition>[
      CellPosition(row: 3, col: 4),
      CellPosition(row: 4, col: 4),
      CellPosition(row: 5, col: 4),
    ],
  ),
  _PatternSpec(
    title: 'Toad',
    type: 'Oscillator',
    meaning:
        'A breathing period-2 oscillator that demonstrates crowding and spacing effects.',
    rows: 10,
    cols: 10,
    tick: Duration(milliseconds: 340),
    seed: <CellPosition>[
      CellPosition(row: 4, col: 3),
      CellPosition(row: 4, col: 4),
      CellPosition(row: 4, col: 5),
      CellPosition(row: 5, col: 4),
      CellPosition(row: 5, col: 5),
      CellPosition(row: 5, col: 6),
    ],
  ),
  _PatternSpec(
    title: 'Glider',
    type: 'Spaceship',
    meaning:
        'Moves diagonally forever in open space. It transports information through the grid.',
    rows: 12,
    cols: 12,
    tick: Duration(milliseconds: 260),
    wrapEdges: true,
    seed: <CellPosition>[
      CellPosition(row: 3, col: 4),
      CellPosition(row: 4, col: 5),
      CellPosition(row: 5, col: 3),
      CellPosition(row: 5, col: 4),
      CellPosition(row: 5, col: 5),
    ],
  ),
  _PatternSpec(
    title: 'LWSS',
    type: 'Spaceship',
    meaning:
        'A larger moving craft that hints how Game of Life can build signaling systems.',
    rows: 14,
    cols: 14,
    tick: Duration(milliseconds: 220),
    wrapEdges: true,
    seed: <CellPosition>[
      CellPosition(row: 5, col: 4),
      CellPosition(row: 5, col: 7),
      CellPosition(row: 6, col: 3),
      CellPosition(row: 7, col: 3),
      CellPosition(row: 8, col: 3),
      CellPosition(row: 8, col: 7),
      CellPosition(row: 6, col: 8),
      CellPosition(row: 7, col: 8),
      CellPosition(row: 8, col: 6),
    ],
  ),
];

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key, required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroCard(),
            const SizedBox(height: 12),
            const _InfoPanel(
              icon: Icons.rule_rounded,
              title: 'Rules',
              paragraphs: <String>[
                '1. Any live cell with fewer than two live neighbors dies (underpopulation).',
                '2. Any live cell with two or three live neighbors survives.',
                '3. Any live cell with more than three live neighbors dies (overpopulation).',
                '4. Any dead cell with exactly three live neighbors becomes alive (reproduction).',
              ],
            ),
            const SizedBox(height: 10),
            const _InfoPanel(
              icon: Icons.lightbulb_outline_rounded,
              title: 'Philosophy',
              paragraphs: <String>[
                'Emergence means complexity can appear without a central controller. '
                    'No cell has a plan, but collective behavior feels purposeful.',
                'Game of Life is a lens for studying order, adaptation, and self-organization '
                    'in nature, distributed systems, and artificial life.',
              ],
            ),
            const SizedBox(height: 10),
            const _InfoPanel(
              icon: Icons.account_tree_outlined,
              title: 'Core Concepts',
              paragraphs: <String>[
                'Discrete space and time: a fixed grid, updated generation by generation.',
                'Local interaction: each cell reads only its immediate neighborhood.',
                'Determinism: same initial state always yields the same future.',
                'Sensitivity: tiny changes in seed can produce radically different behavior.',
              ],
            ),
            const SizedBox(height: 16),
            _PatternShowcase(active: active),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color.lerp(
              scheme.surface,
              Theme.of(context).scaffoldBackgroundColor,
              0.2,
            )!,
            Color.lerp(scheme.surface, scheme.primary, 0.08)!,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Color.lerp(scheme.onSurface, scheme.surface, 0.76)!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Color.lerp(scheme.primary, scheme.surface, 0.72),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Info',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Game of Life is a cellular automaton by John Conway (1970). '
            'Tiny local rules produce rich global behavior that feels unexpectedly alive.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Color.lerp(scheme.onSurface, scheme.surface, 0.56),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.paragraphs,
  });

  final IconData icon;
  final String title;
  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.lerp(scheme.onSurface, scheme.surface, 0.78)!,
        ),
        color: Color.lerp(
          Theme.of(context).scaffoldBackgroundColor,
          scheme.surface,
          0.33,
        ),
      ),
      child: Column(
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
          const SizedBox(height: 8),
          for (final text in paragraphs) ...[
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.34,
                color: Color.lerp(scheme.onSurface, scheme.surface, 0.58),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _PatternSpec {
  const _PatternSpec({
    required this.title,
    required this.type,
    required this.meaning,
    required this.rows,
    required this.cols,
    required this.tick,
    required this.seed,
    this.wrapEdges = false,
  });

  final String title;
  final String type;
  final String meaning;
  final int rows;
  final int cols;
  final Duration tick;
  final List<CellPosition> seed;
  final bool wrapEdges;
}

class _PatternShowcase extends StatefulWidget {
  const _PatternShowcase({required this.active});

  final bool active;

  @override
  State<_PatternShowcase> createState() => _PatternShowcaseState();
}

class _PatternShowcaseState extends State<_PatternShowcase> {
  static const List<String> _types = <String>[
    'All',
    'Still Life',
    'Oscillator',
    'Spaceship',
  ];

  late final PageController _pageController = PageController(
    viewportFraction: 0.94,
  );
  Timer? _autoSlideTimer;
  String _selectedType = 'All';
  int _pageIndex = 0;

  List<_PatternSpec> get _visiblePatterns {
    if (_selectedType == 'All') {
      return _patternSpecs;
    }
    return _patternSpecs
        .where((pattern) => pattern.type == _selectedType)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    if (widget.active) {
      _startAutoSlide();
    }
  }

  @override
  void didUpdateWidget(covariant _PatternShowcase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.active && widget.active) {
      _startAutoSlide();
    } else if (oldWidget.active && !widget.active) {
      _stopAutoSlide();
    }
  }

  @override
  void dispose() {
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final visible = _visiblePatterns;
      if (!mounted || !widget.active || visible.length <= 1) {
        return;
      }
      final next = (_pageIndex + 1) % visible.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
  }

  void _setType(String type) {
    if (_selectedType == type) {
      return;
    }
    setState(() {
      _selectedType = type;
      _pageIndex = 0;
    });
    _pageController.jumpToPage(0);
  }

  void _jumpToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visible = _visiblePatterns;
    final safeIndex = visible.isEmpty
        ? 0
        : _pageIndex.clamp(0, visible.length - 1);
    final selected = visible[safeIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.lerp(scheme.onSurface, scheme.surface, 0.78)!,
        ),
        color: Color.lerp(
          Theme.of(context).scaffoldBackgroundColor,
          scheme.surface,
          0.28,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usual Patterns',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Filter families and swipe animated classics. Each pattern reveals a different '
            'kind of behavior in the Life universe.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Color.lerp(scheme.onSurface, scheme.surface, 0.56),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final type in _types)
                ChoiceChip(
                  label: Text(type),
                  selected: _selectedType == type,
                  onSelected: (_) => _setType(type),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 286,
            child: PageView.builder(
              controller: _pageController,
              itemCount: visible.length,
              onPageChanged: (index) {
                setState(() {
                  _pageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _PatternDemoCard(
                    active: widget.active && index == safeIndex,
                    spec: visible[index],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(
                label: Text('${selected.type} Pattern'),
                avatar: Icon(
                  Icons.hub_rounded,
                  size: 14,
                  color: scheme.primary,
                ),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const Spacer(),
              Text(
                '${safeIndex + 1}/${visible.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Color.lerp(scheme.onSurface, scheme.surface, 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < visible.length; i++)
                GestureDetector(
                  onTap: () => _jumpToPage(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: safeIndex == i ? 18 : 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: safeIndex == i
                          ? scheme.primary
                          : Color.lerp(scheme.onSurface, scheme.surface, 0.62),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PatternDemoCard extends StatefulWidget {
  const _PatternDemoCard({required this.active, required this.spec});

  final bool active;
  final _PatternSpec spec;

  @override
  State<_PatternDemoCard> createState() => _PatternDemoCardState();
}

class _PatternDemoCardState extends State<_PatternDemoCard> {
  late List<bool> _cells;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _cells = _seededBoard();
    if (widget.active) {
      _start();
    }
  }

  @override
  void didUpdateWidget(covariant _PatternDemoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active == widget.active) {
      return;
    }

    if (widget.active) {
      _start();
    } else {
      _stop();
    }
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.spec.tick, (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _cells = _nextGeneration(_cells);
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  int _index(int row, int col) => row * widget.spec.cols + col;

  List<bool> _seededBoard() {
    final next = List<bool>.filled(widget.spec.rows * widget.spec.cols, false);
    for (final cell in widget.spec.seed) {
      if (cell.row < 0 ||
          cell.row >= widget.spec.rows ||
          cell.col < 0 ||
          cell.col >= widget.spec.cols) {
        continue;
      }
      next[_index(cell.row, cell.col)] = true;
    }
    return next;
  }

  List<bool> _nextGeneration(List<bool> current) {
    final next = List<bool>.filled(current.length, false);

    for (var row = 0; row < widget.spec.rows; row++) {
      for (var col = 0; col < widget.spec.cols; col++) {
        final idx = _index(row, col);
        final alive = current[idx];
        var neighbors = 0;

        for (var dr = -1; dr <= 1; dr++) {
          for (var dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) {
              continue;
            }

            var nr = row + dr;
            var nc = col + dc;
            if (widget.spec.wrapEdges) {
              nr = (nr + widget.spec.rows) % widget.spec.rows;
              nc = (nc + widget.spec.cols) % widget.spec.cols;
            } else if (nr < 0 ||
                nr >= widget.spec.rows ||
                nc < 0 ||
                nc >= widget.spec.cols) {
              continue;
            }

            if (current[_index(nr, nc)]) {
              neighbors++;
            }
          }
        }

        next[idx] = alive ? neighbors == 2 || neighbors == 3 : neighbors == 3;
      }
    }

    return next;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dead = Color.lerp(scheme.surface, scheme.onSurface, 0.12)!;
    final alive = Color.lerp(scheme.surface, scheme.primary, 0.84)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.lerp(scheme.onSurface, scheme.surface, 0.78)!,
        ),
        color: Color.lerp(
          Theme.of(context).scaffoldBackgroundColor,
          scheme.surface,
          0.3,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(widget.spec.type),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              const Spacer(),
              Icon(
                Icons.auto_awesome_motion_rounded,
                size: 16,
                color: scheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cells.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.spec.cols,
                crossAxisSpacing: 1.5,
                mainAxisSpacing: 1.5,
              ),
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 130),
                  decoration: BoxDecoration(
                    color: _cells[index] ? alive : dead,
                    borderRadius: BorderRadius.circular(2.8),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.spec.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.spec.meaning,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              height: 1.34,
              color: Color.lerp(scheme.onSurface, scheme.surface, 0.58),
            ),
          ),
        ],
      ),
    );
  }
}
