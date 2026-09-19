import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/game_controller.dart';
import '../theme/toy_pop_theme.dart';
import '../widgets/toy_button.dart';
import '../widgets/victory_overlay.dart';

class ActiveMatchScreen extends StatefulWidget {
  const ActiveMatchScreen({super.key});

  @override
  State<ActiveMatchScreen> createState() => _ActiveMatchScreenState();
}

class _ActiveMatchScreenState extends State<ActiveMatchScreen>
    with TickerProviderStateMixin {
  late AnimationController _turnBounceController;

  late AnimationController _pulseDotController;

  late AnimationController _winPulseController;

  @override
  void initState() {
    super.initState();

    _turnBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseDotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _winPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _turnBounceController.dispose();
    _pulseDotController.dispose();
    _winPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Scaffold(
      backgroundColor: ToyPopTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _ActiveDotGridPainter()),
            ),

            Column(
              children: [
                _buildTopAppBar(game),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 360),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildPlayerCard(
                                      player: 'O',
                                      name: 'PLAYER 2',
                                      subtitle: 'Player O',
                                      score: game.scoreO,
                                      isActive:
                                          game.currentPlayer == 'O' &&
                                          !game.isGameOver,
                                      avatarIcon: Icons.bolt_rounded,
                                      color: ToyPopTheme.secondary,
                                      darkColor: ToyPopTheme.secondaryDark,
                                      containerColor:
                                          ToyPopTheme.secondaryContainer,
                                      shadowColor: ToyPopTheme.secondaryShadow,
                                      badgeBg: const Color(0xFFF0F9FD),
                                    ),
                                    const SizedBox(height: 8),

                                    _buildTurnIndicatorPill(game),
                                    const SizedBox(height: 8),

                                    _buildTactileGrid(game),
                                    const SizedBox(height: 8),

                                    _buildPlayerCard(
                                      player: 'X',
                                      name: 'PLAYER 1',
                                      subtitle: 'Player X',
                                      score: game.scoreX,
                                      isActive:
                                          game.currentPlayer == 'X' &&
                                          !game.isGameOver,
                                      avatarIcon: Icons
                                          .sentiment_very_satisfied_rounded,
                                      color: ToyPopTheme.primary,
                                      darkColor: ToyPopTheme.primaryDark,
                                      containerColor:
                                          ToyPopTheme.primaryContainer,
                                      shadowColor: ToyPopTheme.primaryShadow,
                                      badgeBg: const Color(0xFFFFF2F4),
                                    ),
                                    const SizedBox(height: 8),

                                    _buildBottomControls(game),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            if (game.isGameOver)
              Positioned.fill(
                child: VictoryOverlay(
                  onPlayAgain: () {
                    game.resetMatch();
                  },
                  onMainMenu: () {
                    game.resetMatch();
                    Navigator.of(context).pop();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(GameController game) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        border: const Border(
          bottom: BorderSide(color: ToyPopTheme.surfaceContainerHigh, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ToyIconButton(
            icon: Icons.arrow_back_rounded,
            iconColor: ToyPopTheme.primary,
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<GameController>(
                context,
                listen: false,
              ).audioService.playClick();
            },
          ),
          Text(
            'TIC TAC TOE',
            style: ToyPopTheme.rubik(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: ToyPopTheme.primary,
              letterSpacing: 1.5,
            ),
          ),
          ToyIconButton(
            icon: game.isSoundMuted
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded,
            iconColor: ToyPopTheme.primary,
            onPressed: game.toggleSound,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard({
    required String player,
    required String name,
    required String subtitle,
    required int score,
    required bool isActive,
    required IconData avatarIcon,
    required Color color,
    required Color darkColor,
    required Color containerColor,
    required Color shadowColor,
    required Color badgeBg,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isActive ? 1.0 : 0.65,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? color : color.withValues(alpha: 0.3),
            width: isActive ? 3.5 : 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: color, width: 2),
                        ),
                        child: Icon(avatarIcon, color: color, size: 26),
                      ),
                      Positioned(
                        right: -3,
                        bottom: -3,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              player,
                              style: ToyPopTheme.rubik(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: ToyPopTheme.rubik(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: darkColor,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          subtitle,
                          style: ToyPopTheme.quicksand(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: darkColor.withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SCORE ',
                    style: ToyPopTheme.rubik(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: darkColor.withValues(alpha: 0.7),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '$score',
                    style: ToyPopTheme.rubik(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: darkColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurnIndicatorPill(GameController game) {
    final isXTurn = game.currentPlayer == 'X';
    final Color pillColor = isXTurn
        ? ToyPopTheme.primary
        : ToyPopTheme.secondary;
    final Color pillDark = isXTurn
        ? ToyPopTheme.primaryDark
        : ToyPopTheme.secondaryDark;
    final String label = isXTurn
        ? "RED PLAYER'S TURN (X)"
        : "BLUE PLAYER'S TURN (O)";

    return AnimatedBuilder(
      animation: _turnBounceController,
      builder: (context, child) {
        final bounce = math.sin(_turnBounceController.value * math.pi) * 3.0;
        return Transform.translate(offset: Offset(0, bounce), child: child);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          );
        },
        child: Container(
          key: ValueKey(label),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(ToyPopTheme.radiusPill),
            border: Border.all(color: pillDark, width: 2.5),
            boxShadow: [BoxShadow(color: pillDark, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseDotController,
                builder: (context, _) {
                  return Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(
                            alpha: 0.5 + 0.5 * _pulseDotController.value,
                          ),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: ToyPopTheme.rubik(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTactileGrid(GameController game) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 330),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: ToyPopTheme.surfaceContainerHigh,
              width: 4,
            ),
            boxShadow: const [
              BoxShadow(color: Color(0xFFDDDAD1), offset: Offset(0, 8)),
            ],
          ),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 9,
            itemBuilder: (context, index) {
              final mark = game.board[index];
              final isWinningCell = game.winningLine?.contains(index) ?? false;
              final isInvalid = game.invalidCellIndex == index;

              return _ToyGridCell(
                index: index,
                mark: mark,
                isWinningCell: isWinningCell,
                isDimmed: game.winner != null && !isWinningCell,
                isInvalid: isInvalid,
                winPulseController: _winPulseController,
                onTap: () {
                  game.makeMove(index);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls(GameController game) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: ToyButton.secondary(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
              onPressed: () {
                game.resetMatch();
                Provider.of<GameController>(
                  context,
                  listen: false,
                ).audioService.playClick();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.replay_rounded,
                    color: ToyPopTheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'RESTART',
                      style: ToyPopTheme.rubik(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: ToyPopTheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ToyButton.secondary(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
              onPressed: () {
                _showPauseMenuDialog(game);
                Provider.of<GameController>(
                  context,
                  listen: false,
                ).audioService.playClick();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.pause_rounded,
                    color: ToyPopTheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'PAUSE',
                      style: ToyPopTheme.rubik(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: ToyPopTheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPauseMenuDialog(GameController game) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: ToyPopTheme.border, width: 3),
        ),
        title: Center(
          child: Text(
            'MATCH PAUSED',
            style: ToyPopTheme.rubik(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: ToyPopTheme.onSurface,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToyButton.accent(
              width: double.infinity,
              onPressed: () => Navigator.of(context).pop(),
              child: Center(
                child: Text(
                  'RESUME GAME',
                  style: ToyPopTheme.rubik(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: ToyPopTheme.accentTextDark,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ToyButton.secondary(
              width: double.infinity,
              onPressed: () {
                Provider.of<GameController>(
                  context,
                  listen: false,
                ).audioService.playClick();
                game.resetAll();
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  'RESET SCORES',
                  style: ToyPopTheme.rubik(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: ToyPopTheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ToyButton.secondary(
              width: double.infinity,
              onPressed: () {
                Provider.of<GameController>(
                  context,
                  listen: false,
                ).audioService.playClick();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text(
                  'QUIT TO MENU',
                  style: ToyPopTheme.rubik(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: ToyPopTheme.primary,
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

class _ToyGridCell extends StatefulWidget {
  final int index;
  final String mark;
  final bool isWinningCell;
  final bool isDimmed;
  final bool isInvalid;
  final AnimationController winPulseController;
  final VoidCallback onTap;

  const _ToyGridCell({
    required this.index,
    required this.mark,
    required this.isWinningCell,
    required this.isDimmed,
    required this.isInvalid,
    required this.winPulseController,
    required this.onTap,
  });

  @override
  State<_ToyGridCell> createState() => _ToyGridCellState();
}

class _ToyGridCellState extends State<_ToyGridCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _popController;
  late Animation<double> _popScale;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _popScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _popController, curve: Curves.elasticOut),
    );

    if (widget.mark.isNotEmpty) {
      _popController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant _ToyGridCell oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mark.isEmpty && widget.mark.isNotEmpty) {
      _popController.forward(from: 0.0);
    } else if (widget.mark.isEmpty) {
      _popController.reset();
    }
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = widget.mark.isEmpty;
    final isX = widget.mark == 'X';

    Color cellBg;
    Color borderColor;
    Color shadowColor;

    if (isEmpty) {
      cellBg = const Color(0xFFF7F3EA);
      borderColor = const Color(0xFFECE8DF);
      shadowColor = const Color(0xFFE6E2D9);
    } else if (isX) {
      cellBg = const Color(0xFFFFF2F4);
      borderColor = ToyPopTheme.primary.withValues(alpha: 0.4);
      shadowColor = ToyPopTheme.primaryShadow;
    } else {
      cellBg = const Color(0xFFF0F9FD);
      borderColor = ToyPopTheme.secondary.withValues(alpha: 0.4);
      shadowColor = ToyPopTheme.secondaryShadow;
    }

    if (widget.isWinningCell) {
      borderColor = isX ? ToyPopTheme.primary : ToyPopTheme.secondary;
      shadowColor = isX ? ToyPopTheme.primaryDark : ToyPopTheme.secondaryDark;
    }

    final double shadowDepth = 4.0;
    final double currentDepth = _isPressed ? 1.0 : shadowDepth;
    final double topMargin = _isPressed ? 3.0 : 0.0;

    double shakeOffset = 0.0;
    if (widget.isInvalid) {
      shakeOffset = 6.0;
    }

    Widget content = GestureDetector(
      onTapDown: (_) {
        if (isEmpty) setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        if (isEmpty) setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        if (isEmpty) setState(() => _isPressed = false);
      },
      child: Transform.translate(
        offset: Offset(shakeOffset, 0),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: widget.isDimmed ? 0.35 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 60),
            margin: EdgeInsets.only(
              top: topMargin,
              bottom: shadowDepth - currentDepth,
            ),
            decoration: BoxDecoration(
              color: widget.isInvalid ? const Color(0xFFFFE0E4) : cellBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isInvalid ? ToyPopTheme.primary : borderColor,
                width: widget.isWinningCell ? 3.5 : 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(0, currentDepth),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: isEmpty
                  ? Icon(
                      Icons.add_rounded,
                      color: ToyPopTheme.primary.withValues(alpha: 0.18),
                      size: 26,
                    )
                  : ScaleTransition(
                      scale: _popScale,
                      child: Text(
                        isX ? '✕' : '◯',
                        style: ToyPopTheme.rubik(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: isX
                              ? ToyPopTheme.primary
                              : ToyPopTheme.secondary,
                          height: 1.0,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );

    if (widget.isWinningCell) {
      content = AnimatedBuilder(
        animation: widget.winPulseController,
        builder: (context, child) {
          final scale = 1.0 + 0.05 * widget.winPulseController.value;
          return Transform.scale(scale: scale, child: child);
        },
        child: content,
      );
    }

    return content;
  }
}

class _ActiveDotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8DFD0).withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    const spacing = 22.0;
    const radius = 1.2;

    for (double x = 11; x < size.width; x += spacing) {
      for (double y = 11; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
