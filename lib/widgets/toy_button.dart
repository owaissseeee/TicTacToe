import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/toy_pop_theme.dart';

class ToyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color shadowColor;
  final Color borderColor;
  final double borderWidth;
  final double shadowDepth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  const ToyButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor = ToyPopTheme.accent,
    this.shadowColor = ToyPopTheme.accentDark,
    this.borderColor = ToyPopTheme.accentDark,
    this.borderWidth = 3.0,
    this.shadowDepth = 6.0,
    this.borderRadius = ToyPopTheme.radiusMd,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.width,
    this.height,
  });

  factory ToyButton.play({
    required Widget child,
    VoidCallback? onPressed,
    double? width,
  }) {
    return ToyButton(
      backgroundColor: ToyPopTheme.accent,
      shadowColor: ToyPopTheme.accentDark,
      borderColor: ToyPopTheme.accentDark,
      borderWidth: 4.0,
      shadowDepth: 8.0,
      borderRadius: ToyPopTheme.radiusLg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      width: width,
      onPressed: onPressed,
      child: child,
    );
  }

  factory ToyButton.secondary({
    required Widget child,
    VoidCallback? onPressed,
    double? width,
    EdgeInsetsGeometry? padding,
  }) {
    return ToyButton(
      backgroundColor: ToyPopTheme.surfaceSubtle,
      shadowColor: const Color(0xFFCEBFAB),
      borderColor: const Color(0xFFE0D6C5),
      borderWidth: 2.5,
      shadowDepth: 4.0,
      borderRadius: ToyPopTheme.radiusMd,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: width,
      onPressed: onPressed,
      child: child,
    );
  }

  factory ToyButton.accent({
    required Widget child,
    VoidCallback? onPressed,
    double? width,
    EdgeInsetsGeometry? padding,
  }) {
    return ToyButton(
      backgroundColor: ToyPopTheme.accent,
      shadowColor: ToyPopTheme.accentDeepShadow,
      borderColor: const Color(0xFFCFA600),
      borderWidth: 3.0,
      shadowDepth: 6.0,
      borderRadius: ToyPopTheme.radiusMd,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      width: width,
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  State<ToyButton> createState() => _ToyButtonState();
}

class _ToyButtonState extends State<ToyButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = true);
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final double currentDepth = _isPressed ? 1.0 : widget.shadowDepth;
    final double topMargin = _isPressed ? (widget.shadowDepth - 1.0) : 0.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          margin: EdgeInsets.only(
            top: topMargin,
            bottom: widget.shadowDepth - currentDepth,
          ),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor,
                offset: Offset(0, currentDepth),
                blurRadius: 0,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class ToyIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color iconColor;
  final Color backgroundColor;
  final Color shadowColor;
  final Color borderColor;
  final double size;
  final double iconSize;

  const ToyIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor = ToyPopTheme.onSurface,
    this.backgroundColor = ToyPopTheme.surface,
    this.shadowColor = const Color(0xFFD5CBC8),
    this.borderColor = const Color(0xFFE7DECE),
    this.size = 48.0,
    this.iconSize = 24.0,
  });

  @override
  State<ToyIconButton> createState() => _ToyIconButtonState();
}

class _ToyIconButtonState extends State<ToyIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double shadowDepth = 4.0;
    final double currentDepth = _isPressed ? 1.0 : shadowDepth;
    final double topOffset = _isPressed ? 3.0 : 0.0;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed == null) return;
        setState(() => _isPressed = true);
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        if (widget.onPressed == null) return;
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () {
        if (widget.onPressed == null) return;
        setState(() => _isPressed = false);
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size + shadowDepth,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          margin: EdgeInsets.only(
            top: topOffset,
            bottom: shadowDepth - currentDepth,
          ),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: widget.borderColor, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor,
                offset: Offset(0, currentDepth),
                blurRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: widget.iconColor,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
