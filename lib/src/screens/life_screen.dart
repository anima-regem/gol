import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import '../models/cell_position.dart';

class LifeScreen extends StatefulWidget {
  const LifeScreen({super.key, required this.active});

  final bool active;

  @override
  State<LifeScreen> createState() => _LifeScreenState();
}

class _LifeScreenState extends State<LifeScreen> {
  static const double _gridPadding = 8;
  static const double _targetCellSize = 19;
  static const double _gap = 2;

  final math.Random _random = math.Random();

  int _rows = 0;
  int _cols = 0;
  int _generation = 0;
  List<bool> _cells = const <bool>[];
  List<int> _ages = const <int>[];
  bool _running = false;
  double _speed = 0.55;
  Timer? _timer;
  _BoardMetrics? _metrics;
  bool? _paintToAlive;
  final Set<int> _strokeVisited = <int>{};
  final GlobalKey _gridExportKey = GlobalKey();

  int get _aliveCount => _cells.where((cell) => cell).length;

  Duration get _tickDuration {
    final ms = math.max(60, math.min(230, (230 - (_speed * 170)).round()));
    return Duration(milliseconds: ms);
  }

  @override
  void didUpdateWidget(covariant LifeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_running || widget.active) {
      return;
    }
    _stopSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_tickDuration, (_) => _step());
  }

  void _stopSimulation() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _running = false;
    });
  }

  void _toggleRunning() {
    setState(() {
      _running = !_running;
      if (_running) {
        _restartTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _setSpeed(double value) {
    setState(() {
      _speed = value;
      if (_running) {
        _restartTimer();
      }
    });
  }

  void _clearBoard() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _generation = 0;
      _cells = List<bool>.filled(_rows * _cols, false);
      _ages = List<int>.filled(_rows * _cols, 0);
    });
  }

  void _seedRandom() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _generation = 0;
      final nextCells = List<bool>.filled(_rows * _cols, false);
      final nextAges = List<int>.filled(_rows * _cols, 0);
      for (var i = 0; i < nextCells.length; i++) {
        final alive = _random.nextDouble() < 0.24;
        nextCells[i] = alive;
        nextAges[i] = alive ? 4 : 0;
      }
      _cells = nextCells;
      _ages = nextAges;
    });
  }

  void _step() {
    if (!_running || _rows == 0 || _cols == 0) {
      return;
    }

    final nextCells = List<bool>.filled(_cells.length, false);
    final nextAges = List<int>.filled(_ages.length, 0);

    for (var row = 0; row < _rows; row++) {
      for (var col = 0; col < _cols; col++) {
        final idx = _index(row, col);
        final alive = _cells[idx];
        var neighbors = 0;

        for (var dr = -1; dr <= 1; dr++) {
          for (var dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) {
              continue;
            }
            final nr = row + dr;
            final nc = col + dc;
            if (nr < 0 || nr >= _rows || nc < 0 || nc >= _cols) {
              continue;
            }
            if (_cells[_index(nr, nc)]) {
              neighbors++;
            }
          }
        }

        final nextAlive = alive
            ? neighbors == 2 || neighbors == 3
            : neighbors == 3;
        nextCells[idx] = nextAlive;
        if (nextAlive) {
          nextAges[idx] = alive ? math.min(4, _ages[idx] + 1) : 1;
        }
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _cells = nextCells;
      _ages = nextAges;
      _generation++;
    });
  }

  int _index(int row, int col) => row * _cols + col;

  void _syncBoardForSize(Size size) {
    final dims = _deriveDimensions(size);
    _metrics = _buildMetrics(size, dims.rows, dims.cols);

    if (dims.rows == _rows && dims.cols == _cols) {
      return;
    }

    final oldRows = _rows;
    final oldCols = _cols;
    final oldCells = _cells;
    final oldAges = _ages;

    _rows = dims.rows;
    _cols = dims.cols;

    final nextCells = List<bool>.filled(_rows * _cols, false);
    final nextAges = List<int>.filled(_rows * _cols, 0);

    final copyRows = math.min(oldRows, _rows);
    final copyCols = math.min(oldCols, _cols);

    for (var row = 0; row < copyRows; row++) {
      for (var col = 0; col < copyCols; col++) {
        final oldIdx = row * oldCols + col;
        final newIdx = _index(row, col);
        nextCells[newIdx] = oldCells[oldIdx];
        nextAges[newIdx] = oldAges[oldIdx];
      }
    }

    _cells = nextCells;
    _ages = nextAges;
  }

  _GridDimensions _deriveDimensions(Size size) {
    final cols = math.max(8, (size.width / (_targetCellSize + _gap)).floor());
    final rows = math.max(12, (size.height / (_targetCellSize + _gap)).floor());
    return _GridDimensions(rows: rows, cols: cols);
  }

  _BoardMetrics _buildMetrics(Size size, int rows, int cols) {
    final width = math.max(1.0, size.width - (_gridPadding * 2));
    final height = math.max(1.0, size.height - (_gridPadding * 2));
    final cellWidth = (width - ((cols - 1) * _gap)) / cols;
    final cellHeight = (height - ((rows - 1) * _gap)) / rows;

    return _BoardMetrics(
      rows: rows,
      cols: cols,
      cellWidth: cellWidth,
      cellHeight: cellHeight,
      padding: _gridPadding,
      gap: _gap,
    );
  }

  CellPosition? _cellFromOffset(Offset offset) {
    final metrics = _metrics;
    if (metrics == null) {
      return null;
    }

    final x = offset.dx - metrics.padding;
    final y = offset.dy - metrics.padding;
    if (x < 0 || y < 0) {
      return null;
    }

    final colStride = metrics.cellWidth + metrics.gap;
    final rowStride = metrics.cellHeight + metrics.gap;
    final col = (x / colStride).floor();
    final row = (y / rowStride).floor();

    if (col < 0 || col >= metrics.cols || row < 0 || row >= metrics.rows) {
      return null;
    }

    final insideCol = x - (col * colStride);
    final insideRow = y - (row * rowStride);
    if (insideCol > metrics.cellWidth || insideRow > metrics.cellHeight) {
      return null;
    }

    return CellPosition(row: row, col: col);
  }

  void _handleTap(TapDownDetails details) {
    if (_running) {
      return;
    }

    final cell = _cellFromOffset(details.localPosition);
    if (cell == null) {
      return;
    }

    final idx = _index(cell.row, cell.col);
    setState(() {
      final next = !_cells[idx];
      _cells[idx] = next;
      _ages[idx] = next ? 4 : 0;
    });
  }

  void _paintStroke(Offset position, {bool start = false}) {
    if (_running) {
      return;
    }

    final cell = _cellFromOffset(position);
    if (cell == null) {
      return;
    }

    final idx = _index(cell.row, cell.col);
    if (start) {
      _paintToAlive = !_cells[idx];
      _strokeVisited.clear();
    } else {
      _paintToAlive ??= !_cells[idx];
    }

    if (_strokeVisited.contains(idx)) {
      return;
    }

    _strokeVisited.add(idx);
    setState(() {
      _cells[idx] = _paintToAlive!;
      _ages[idx] = _paintToAlive! ? 4 : 0;
    });
  }

  void _finishStroke() {
    _paintToAlive = null;
    _strokeVisited.clear();
  }

  Future<void> _saveInitialSetupAsPng() async {
    if (_running || _generation != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Save is available for initial setup only (before simulation starts).',
          ),
        ),
      );
      return;
    }

    if (_aliveCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draw at least one live cell first.')),
      );
      return;
    }

    final renderObject = _gridExportKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grid not ready yet. Try again.')),
      );
      return;
    }

    try {
      final ratio = math.max(2.0, MediaQuery.of(context).devicePixelRatio);
      final image = await renderObject.toImage(pixelRatio: ratio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw StateError('Could not encode image.');
      }

      final appDir = await getApplicationDocumentsDirectory();
      final exportDir = Directory('${appDir.path}/gol_exports');
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      final stamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .replaceAll('.', '-');
      final file = File('${exportDir.path}/gol_initial_setup_$stamp.png');
      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Saved PNG to ${file.path}')));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save PNG.')));
    }
  }

  Color _cellColor(int index, ColorScheme scheme) {
    if (!_cells[index]) {
      return Color.lerp(scheme.surface, scheme.onSurface, 0.14)!;
    }

    switch (_ages[index]) {
      case 1:
        return Color.lerp(scheme.surface, scheme.primary, 0.42)!;
      case 2:
        return Color.lerp(scheme.surface, scheme.primary, 0.56)!;
      case 3:
        return Color.lerp(scheme.surface, scheme.primary, 0.7)!;
      default:
        return Color.lerp(scheme.surface, scheme.primary, 0.88)!;
    }
  }

  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        _syncBoardForSize(constraints.biggest);
        final scheme = Theme.of(context).colorScheme;
        final aspectRatio = _metrics == null
            ? 1.0
            : _metrics!.cellWidth / math.max(1.0, _metrics!.cellHeight);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _handleTap,
          onPanStart: (details) =>
              _paintStroke(details.localPosition, start: true),
          onPanUpdate: (details) => _paintStroke(details.localPosition),
          onPanEnd: (_) => _finishStroke(),
          onPanCancel: _finishStroke,
          child: Padding(
            padding: const EdgeInsets.all(_gridPadding),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cells.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _cols,
                mainAxisSpacing: _gap,
                crossAxisSpacing: _gap,
                childAspectRatio: aspectRatio,
              ),
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 110),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: _cellColor(index, scheme),
                    borderRadius: BorderRadius.circular(4.5),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pageBg = Theme.of(context).scaffoldBackgroundColor;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        child: Column(
          children: [
            _TopSummary(
              running: _running,
              generation: _generation,
              aliveCount: _aliveCount,
              speed: _speed,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleRunning,
                    icon: Icon(
                      _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    ),
                    label: Text(_running ? 'Pause' : 'Start'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                _SquareActionButton(
                  icon: Icons.shuffle_rounded,
                  tooltip: 'Random seed',
                  onTap: _running ? null : _seedRandom,
                ),
                const SizedBox(width: 6),
                _SquareActionButton(
                  icon: Icons.delete_outline_rounded,
                  tooltip: 'Clear board',
                  onTap: _clearBoard,
                ),
                const SizedBox(width: 6),
                _SquareActionButton(
                  icon: Icons.save_alt_rounded,
                  tooltip: 'Save initial setup as PNG',
                  onTap: (!_running && _generation == 0)
                      ? _saveInitialSetupAsPng
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Color.lerp(pageBg, scheme.surface, 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color.lerp(scheme.onSurface, scheme.surface, 0.78)!,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.speed_rounded, color: scheme.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Speed',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(value: _speed, onChanged: _setSpeed),
                  ),
                  Text(
                    '${(_speed * 100).round()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: Color.lerp(scheme.onSurface, scheme.surface, 0.52),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: RepaintBoundary(
                key: _gridExportKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.lerp(pageBg, scheme.surface, 0.38),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color.lerp(
                        scheme.onSurface,
                        scheme.surface,
                        0.77,
                      )!,
                      width: 1.3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                        child: Row(
                          children: [
                            Icon(
                              _running
                                  ? Icons.bolt_rounded
                                  : Icons.edit_rounded,
                              size: 14,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _running
                                    ? 'Simulation Grid'
                                    : 'Draw initial pattern and press Start',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontSize: 11,
                                      color: Color.lerp(
                                        scheme.onSurface,
                                        scheme.surface,
                                        0.56,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 1),
                      Expanded(child: _buildGrid()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopSummary extends StatelessWidget {
  const _TopSummary({
    required this.running,
    required this.generation,
    required this.aliveCount,
    required this.speed,
  });

  final bool running;
  final int generation;
  final int aliveCount;
  final double speed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dimmed = Color.lerp(scheme.onSurface, scheme.surface, 0.56)!;
    final statusColor = running
        ? scheme.primary
        : Color.lerp(scheme.onSurface, scheme.surface, 0.42)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
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
        borderRadius: BorderRadius.circular(16),
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
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Color.lerp(scheme.primary, scheme.surface, 0.72),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  Icons.blur_on_rounded,
                  size: 17,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Life Console',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      running
                          ? 'Simulating generation flow'
                          : 'Tap or drag to seed cells',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: dimmed,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Color.lerp(statusColor, scheme.surface, 0.82),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: Color.lerp(scheme.onSurface, scheme.surface, 0.76)!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: running
                            ? statusColor
                            : Color.lerp(statusColor, scheme.surface, 0.25),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      running ? 'Running' : 'Idle',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _MetricPill(
                icon: Icons.timeline_rounded,
                label: 'Generation',
                value: generation.toString(),
              ),
              _MetricPill(
                icon: Icons.grid_on_rounded,
                label: 'Alive',
                value: aliveCount.toString(),
              ),
              _MetricPill(
                icon: Icons.speed_rounded,
                label: 'Speed',
                value: '${(speed * 100).round()}%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Color.lerp(scheme.surface, scheme.primary, 0.82),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: Color.lerp(scheme.onSurface, scheme.surface, 0.76)!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Color.lerp(scheme.onSurface, scheme.surface, 0.54),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color.lerp(scheme.onSurface, scheme.surface, 0.58),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 11,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareActionButton extends StatelessWidget {
  const _SquareActionButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Color.lerp(
              Theme.of(context).scaffoldBackgroundColor,
              scheme.surface,
              0.38,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color.lerp(scheme.onSurface, scheme.surface, 0.76)!,
            ),
          ),
          child: Icon(
            icon,
            size: 19,
            color: onTap == null
                ? Color.lerp(scheme.onSurface, scheme.surface, 0.7)
                : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _GridDimensions {
  const _GridDimensions({required this.rows, required this.cols});

  final int rows;
  final int cols;
}

class _BoardMetrics {
  const _BoardMetrics({
    required this.rows,
    required this.cols,
    required this.cellWidth,
    required this.cellHeight,
    required this.padding,
    required this.gap,
  });

  final int rows;
  final int cols;
  final double cellWidth;
  final double cellHeight;
  final double padding;
  final double gap;
}
