import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/game_controller.dart';
import '../theme/toy_pop_theme.dart';
import '../widgets/toy_button.dart';
import 'active_match_screen.dart';

class StartMenuScreen extends StatefulWidget {
  const StartMenuScreen({super.key});

  @override
  State<StartMenuScreen> createState() => _StartMenuScreenState();
}

class _StartMenuScreenState extends State<StartMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _mascotsScale;
  late Animation<double> _titleSlide;
  late Animation<double> _cardScale;
  late Animation<double> _buttonScale;

  late AnimationController _wiggleController;

  late AnimationController _pulseController;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _mascotsScale = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    );

    _titleSlide = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
    );

    _cardScale = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOutBack),
    );

    _buttonScale = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
    );

    _entranceController.forward();

    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 1.0, end: 1.035).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _wiggleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToMatch() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ActiveMatchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          );
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    return Scaffold(
      backgroundColor: ToyPopTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),

            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 12.0,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildTopHeader(game),

                                const Spacer(flex: 1),

                                ScaleTransition(
                                  scale: _mascotsScale,
                                  child: _buildMascotsHero(),
                                ),

                                const SizedBox(height: 12),

                                SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.2),
                                    end: Offset.zero,
                                  ).animate(_titleSlide),
                                  child: FadeTransition(
                                    opacity: _titleSlide,
                                    child: _buildTitleBlock(),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                ScaleTransition(
                                  scale: _cardScale,
                                  child: _buildMiniGridPreview(),
                                ),

                                const Spacer(flex: 1),

                                ScaleTransition(
                                  scale: _buttonScale,
                                  child: AnimatedBuilder(
                                    animation: _pulseScale,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _pulseScale.value,
                                        child: child,
                                      );
                                    },
                                    child: ToyButton.play(
                                      onPressed: _navigateToMatch,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 52,
                                            height: 52,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: ToyPopTheme.accentDark,
                                                width: 2.5,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0xFFE0B300),
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.play_arrow_rounded,
                                              color: ToyPopTheme.primary,
                                              size: 38,
                                            ),
                                          ),
                                          const SizedBox(width: 14),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'PLAY DUEL',
                                                  style: ToyPopTheme.rubik(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w900,
                                                    color: ToyPopTheme
                                                        .accentTextDark,
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '2 PLAYERS • PASS & PLAY',
                                                  style: ToyPopTheme.quicksand(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                      0xFF6D5300,
                                                    ),
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: ToyPopTheme.accentLight,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_forward_rounded,
                                              color: ToyPopTheme.accentText,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  'Ready to tap? Choose X or O and fight!',
                                  style: ToyPopTheme.quicksand(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: ToyPopTheme.onSurfaceMuted,
                                  ),
                                ),

                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(GameController game) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(ToyPopTheme.radiusPill),
            border: Border.all(color: ToyPopTheme.border, width: 2),
            boxShadow: const [
              BoxShadow(color: ToyPopTheme.neutralShadow, offset: Offset(0, 3)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: ToyPopTheme.mint,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ToyPopTheme.mint.withValues(
                            alpha: 0.4 + 0.5 * _pulseController.value,
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
              Text(
                'LOCAL PARTY',
                style: ToyPopTheme.rubik(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: ToyPopTheme.onSurface,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToyIconButton(
              icon: game.isSoundMuted
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
              iconColor: game.isSoundMuted
                  ? ToyPopTheme.onSurfaceMuted
                  : ToyPopTheme.accentDark,
              onPressed: game.toggleSound,
            ),
            const SizedBox(width: 8),
            ToyIconButton(
              icon: Icons.tune_rounded,
              iconColor: ToyPopTheme.onSurfaceMuted,
              onPressed: () {
                _showHowToPlayDialog();
                Provider.of<GameController>(
                  context,
                  listen: false,
                ).audioService.playClick();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMascotsHero() {
    return AnimatedBuilder(
      animation: _wiggleController,
      builder: (context, child) {
        final progress = _wiggleController.value * 2 * math.pi;
        final xTilt = math.sin(progress) * 0.07 - 0.10;
        final yTilt = -math.sin(progress) * 0.07 + 0.10;
        final xBounce = math.sin(progress) * 6.0;
        final oBounce = -math.sin(progress) * 6.0;
        final vsPulse = 1.0 + 0.08 * math.sin(progress * 1.5);

        return SizedBox(
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 30,
                child: Transform.translate(
                  offset: Offset(0, xBounce),
                  child: Transform.rotate(angle: xTilt, child: _buildMascotX()),
                ),
              ),

              Positioned(
                right: 30,
                child: Transform.translate(
                  offset: Offset(0, oBounce),
                  child: Transform.rotate(angle: yTilt, child: _buildMascotO()),
                ),
              ),

              Transform.scale(
                scale: vsPulse,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ToyPopTheme.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: ToyPopTheme.accentDark, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: ToyPopTheme.accentDark,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'VS',
                      style: ToyPopTheme.rubik(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMascotX() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: ToyPopTheme.primary,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: ToyPopTheme.primaryDark, width: 4),
            boxShadow: const [
              BoxShadow(color: ToyPopTheme.primaryDark, offset: Offset(0, 8)),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 10,
                child: Transform.rotate(
                  angle: -0.4,
                  child: Container(
                    width: 14,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCartoonEye(true),
                        const SizedBox(width: 8),
                        _buildCartoonEye(true),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 14,
                      height: 7,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: ToyPopTheme.primaryDark,
                            width: 2.5,
                          ),
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 12,
                left: 10,
                child: Container(
                  width: 8,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ToyPopTheme.primaryBlush,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 10,
                child: Container(
                  width: 8,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ToyPopTheme.primaryBlush,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: ToyPopTheme.border, width: 2),
            boxShadow: const [
              BoxShadow(color: ToyPopTheme.neutralShadow, offset: Offset(0, 3)),
            ],
          ),
          child: Text(
            'PLAYER 1',
            style: ToyPopTheme.rubik(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: ToyPopTheme.primary,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMascotO() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: ToyPopTheme.secondary,
            shape: BoxShape.circle,
            border: Border.all(color: ToyPopTheme.secondaryDark, width: 4),
            boxShadow: const [
              BoxShadow(color: ToyPopTheme.secondaryDark, offset: Offset(0, 8)),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                left: 12,
                child: Transform.rotate(
                  angle: -0.4,
                  child: Container(
                    width: 14,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ToyPopTheme.secondaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ToyPopTheme.secondaryDark,
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildSmallEye(),
                            const SizedBox(width: 6),
                            _buildSmallEye(),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Container(
                          width: 8,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B8B),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: ToyPopTheme.border, width: 2),
            boxShadow: const [
              BoxShadow(color: ToyPopTheme.neutralShadow, offset: Offset(0, 3)),
            ],
          ),
          child: Text(
            'PLAYER 2',
            style: ToyPopTheme.rubik(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: ToyPopTheme.secondaryDark,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartoonEye(bool glanceRight) {
    return Container(
      width: 11,
      height: 15,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: glanceRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: ToyPopTheme.onSurface,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildSmallEye() {
    return Container(
      width: 8,
      height: 11,
      decoration: BoxDecoration(
        color: ToyPopTheme.onSurface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 3.5,
          height: 3.5,
          margin: const EdgeInsets.all(1.5),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBlock() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'TIC TAC',
          style: ToyPopTheme.rubik(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: ToyPopTheme.onSurface,
            letterSpacing: 0.5,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 2),
        Transform.rotate(
          angle: -0.02,
          child: Text(
            'TOE!',
            style: ToyPopTheme.rubik(
              fontSize: 50,
              fontWeight: FontWeight.w900,
              color: ToyPopTheme.primary,
              letterSpacing: 1.5,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Classic 2-Player Battle on One Screen',
          style: ToyPopTheme.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: ToyPopTheme.onSurfaceMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniGridPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: ToyPopTheme.border, width: 4),
        boxShadow: const [
          BoxShadow(color: ToyPopTheme.neutralShadow, offset: Offset(0, 8)),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 190,
          height: 190,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildMiniTokenCell(
                '✕',
                ToyPopTheme.primary,
                const Color(0xFFFFE6EB),
                ToyPopTheme.primaryShadow,
              ),
              _buildMiniEmptyCell(),
              _buildMiniTokenCell(
                '◯',
                ToyPopTheme.secondary,
                const Color(0xFFE0F7FE),
                ToyPopTheme.secondaryShadow,
              ),
              _buildMiniEmptyCell(),
              _buildMiniHighlightedCell('✕'),
              _buildMiniEmptyCell(),
              _buildMiniTokenCell(
                '◯',
                ToyPopTheme.secondary,
                const Color(0xFFE0F7FE),
                ToyPopTheme.secondaryShadow,
              ),
              _buildMiniEmptyCell(),
              _buildMiniEmptyCell(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniTokenCell(
    String symbol,
    Color color,
    Color bg,
    Color shadow,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 2.5),
        boxShadow: [BoxShadow(color: shadow, offset: const Offset(0, 3))],
      ),
      child: Center(
        child: Text(
          symbol,
          style: ToyPopTheme.rubik(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildMiniHighlightedCell(String symbol) {
    return Container(
      decoration: BoxDecoration(
        color: ToyPopTheme.primary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ToyPopTheme.primaryDark, width: 2.5),
        boxShadow: const [
          BoxShadow(color: ToyPopTheme.primaryDark, offset: Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Text(
          symbol,
          style: ToyPopTheme.rubik(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMiniEmptyCell() {
    return Container(
      decoration: BoxDecoration(
        color: ToyPopTheme.surfaceSubtle,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ToyPopTheme.borderSubtle, width: 1.5),
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: ToyPopTheme.borderSubtle,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  void _showHowToPlayDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: ToyPopTheme.border, width: 3),
        ),
        title: Text(
          'HOW TO PLAY',
          style: ToyPopTheme.rubik(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: ToyPopTheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• Player 1 plays as Red (✕)',
              style: ToyPopTheme.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ToyPopTheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '• Player 2 plays as Cyan (◯)',
              style: ToyPopTheme.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: ToyPopTheme.secondaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '• Take turns placing your mark on the 3x3 grid.',
              style: ToyPopTheme.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ToyPopTheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '• Get 3 in a row horizontally, vertically, or diagonally to win!',
              style: ToyPopTheme.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ToyPopTheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          ToyButton.accent(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'GOT IT!',
              style: ToyPopTheme.rubik(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: ToyPopTheme.accentTextDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8DFD0)
      ..style = PaintingStyle.fill;

    const spacing = 20.0;
    const radius = 1.25;

    for (double x = 10; x < size.width; x += spacing) {
      for (double y = 10; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
