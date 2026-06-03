import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:flutter/material.dart';

/// Full-screen gradient + soft orbs behind main content (glass-adjacent look).
class GlassicBackground extends StatelessWidget {
  const GlassicBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DupraColors.offBlack,
            DupraColors.offBlack,
            // DupraColors.tertiary.withValues(alpha: 0.15),
            // DupraColors.offBlack,
          ],
          stops: [0.0, 0.6],
        ),
      ),
      child: Stack(children: [_TopLeft(), _BottomRight(), _MiddleRight(), _MiddleLeft(), child]),
    );
  }
}

class _MiddleLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.sizeOf(context).height * 0.5,
      left: -210,
      child: Container(
        width: 430,
        height: 430,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              DupraColors.secondary.withValues(alpha: 0.34),
              DupraColors.tertiary.withValues(alpha: 0.12),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _MiddleRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 180,
      right: -200,
      child: Container(
        width: 430,
        height: 430,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              DupraColors.secondary.withValues(alpha: 0.34),
              DupraColors.tertiary.withValues(alpha: 0.12),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _TopLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: -110,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              DupraColors.secondary.withValues(alpha: 0.35),
              DupraColors.tertiary.withValues(alpha: 0.12),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -180,
      right: -160,
      child: Container(
        width: 450,
        height: 450,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              DupraColors.secondary.withValues(alpha: 0.35),
              DupraColors.tertiary.withValues(alpha: 0.12),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
