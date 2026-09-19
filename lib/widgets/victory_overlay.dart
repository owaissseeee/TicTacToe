import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/game_controller.dart';
import '../theme/toy_pop_theme.dart';
import 'confetti_painter.dart';
import 'toy_button.dart';

class VictoryOverlay extends StatefulWidget {
  final VoidCallback onPlayAgain;
  final VoidCallback onMainMenu;

  const VictoryOverlay({
    super.key,
    required this.onPlayAgain,
    required this.onMainMenu,
  });

  @override
  State<VictoryOverlay> createState() => _VictoryOverlayState();
}

class _VictoryOverlayState extends State<VictoryOverlay>
    with TickerProviderStateMixin {
  late AnimationController _popController;
  late Animation<double> _popScale;
  late Animation<double> _popFade;

  late AnimationController _sunburstController;

  late AnimationController _wiggleController;

  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();

    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _popScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _popController,
        curve: const Cubic(0.175, 0.885, 0.32, 1.275),
      ),
    );

    _popFade = CurvedAnimation(parent: _popController, curve: Curves.easeIn);

    _popController.forward();

    _sunburstController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 36),
    )..repeat();

    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _popController.dispose();
    _sunburstController.dispose();
    _wiggleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    final winner = game.winner;
    final isDraw = game.isDraw;

    final isP1Winner = winner == 'X';
    final isP2Winner = winner == 'O';

    final Color bannerBg = isP1Winner
        ? ToyPopTheme.primary
        : (isP2Winner ? ToyPopTheme.secondary : ToyPopTheme.accent);
    final Color bannerBorder = isP1Winner
        ? ToyPopTheme.primaryDark
        : (isP2Winner ? ToyPopTheme.secondaryDark : ToyPopTheme.accentDark);
    final Color bannerShadow = isP1Winner
        ? const Color(0xFF7A0026)
        : (isP2Winner ? const Color(0xFF004B65) : const Color(0xFFB38A00));

    final String bannerText = isDraw ? "IT'S A DRAW!" : 'VICTORY!';
    final String winnerTagline = isDraw
        ? '✨ Evenly Matched Duel! ✨'
        : (isP1Winner
              ? '✨ Player 1 Wins The Duel! ✨'
              : '✨ Player 2 Wins The Duel! ✨');
    final Color winnerTaglineColor = isDraw
        ? ToyPopTheme.accentDark
        : (isP1Winner ? ToyPopTheme.primary : ToyPopTheme.secondaryDark);

    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
          child: Container(color: ToyPopTheme.backdropScrim),
        ),

        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _sunburstController,
              builder: (context, child) {
                return CustomPaint(
                  painter: SunburstPainter(
                    angle: _sunburstController.value * 2 * math.pi,
                  ),
                );
              },
            ),
          ),
        ),

        Positioned.fill(
          child: AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return ConfettiOverlayWidget(
                animationProgress: _confettiController.value,
              );
            },
          ),
        ),

        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AnimatedBuilder(
                animation: _popController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _popFade,
                    child: Transform.scale(
                      scale: _popScale.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                      color: const Color(0xFFE9DFCE),
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFD3C3A9),
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMascotEmblem(isP1Winner, isP2Winner, isDraw),

                      const SizedBox(height: 6),

                      Transform.rotate(
                        angle: -0.02,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: bannerBg,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: bannerBorder, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: bannerShadow,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            bannerText,
                            style: ToyPopTheme.rubik(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        winnerTagline,
                        style: ToyPopTheme.rubik(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: winnerTaglineColor,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 14),

                      _buildMatchResultBox(game),

                      const SizedBox(height: 18),

                      ToyButton.accent(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        onPressed: widget.onPlayAgain,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.replay_rounded,
                              color: ToyPopTheme.accentTextDark,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'PLAY AGAIN',
                                style: ToyPopTheme.rubik(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: ToyPopTheme.accentTextDark,
                                  letterSpacing: 0.6,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      ToyButton.secondary(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        onPressed: widget.onMainMenu,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.home_rounded,
                              color: Color(0xFF5C4A3B),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'MAIN MENU',
                                style: ToyPopTheme.rubik(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF5C4A3B),
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMascotEmblem(bool isP1, bool isP2, bool isDraw) {
    return AnimatedBuilder(
      animation: _wiggleController,
      builder: (context, child) {
        final angle = math.sin(_wiggleController.value * math.pi) * 0.05 - 0.02;
        final yOffset = -math.sin(_wiggleController.value * math.pi) * 4.0;

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Transform.rotate(angle: angle, child: child),
        );
      },
      child: SizedBox(
        width: 84,
        height: isDraw ? 84 : 104,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: isP1
                    ? ToyPopTheme.primaryContainer
                    : (isP2
                          ? ToyPopTheme.secondaryContainer
                          : ToyPopTheme.surfaceSubtle),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isP1
                      ? ToyPopTheme.primary
                      : (isP2 ? ToyPopTheme.secondary : ToyPopTheme.accentDark),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isP1
                        ? const Color(0xFFAB093A)
                        : (isP2
                              ? const Color(0xFF007A9E)
                              : ToyPopTheme.accentDark),
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  isP1 ? '✕' : (isP2 ? '◯' : '🤝'),
                  style: ToyPopTheme.rubik(
                    fontSize: isDraw ? 36 : 46,
                    fontWeight: FontWeight.w900,
                    color: isP1
                        ? ToyPopTheme.primary
                        : (isP2
                              ? ToyPopTheme.secondary
                              : ToyPopTheme.onSurface),
                    height: 1.0,
                  ),
                ),
              ),
            ),

            if (!isDraw)
              Positioned(
                top: 0,
                child: Container(
                  width: 48,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD426),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFC99F00),
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFFB38A00), offset: Offset(0, 3)),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchResultBox(GameController game) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8F0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEBDCC4), width: 2.5),
        boxShadow: const [
          BoxShadow(color: Color(0xFFEBDCC4), offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'MATCH RESULT',
            style: ToyPopTheme.rubik(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C3F42),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _buildPlayerScoreCard(
                  'RED P1',
                  game.scoreX,
                  '✕',
                  ToyPopTheme.primary,
                  const Color(0xFFFFE8ED),
                  const Color(0xFFFFB3C1),
                ),
              ),
              const SizedBox(width: 6),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECE2D1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'VS',
                  style: ToyPopTheme.rubik(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF968271),
                  ),
                ),
              ),
              const SizedBox(width: 6),

              Expanded(
                child: _buildPlayerScoreCard(
                  'BLUE P2',
                  game.scoreO,
                  '◯',
                  ToyPopTheme.secondaryDark,
                  const Color(0xFFE8F7FF),
                  const Color(0xFFBEE8FF),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(color: Color(0xFFEBDCC4), height: 1),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timer_rounded,
                size: 14,
                color: Color(0xFFF5B800),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'COMPLETED IN ${game.turnsCount} TURNS',
                  style: ToyPopTheme.rubik(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF5C3F42),
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerScoreCard(
    String label,
    int score,
    String token,
    Color color,
    Color bg,
    Color border,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                token,
                style: ToyPopTheme.rubik(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: ToyPopTheme.rubik(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$score',
                  style: ToyPopTheme.rubik(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: color,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
