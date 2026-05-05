import 'package:dupra/engine/theme/dupra_colors.dart';
import 'package:flutter/material.dart';

/// Full-screen gradient + soft orbs behind main content (glass-adjacent look).
class GlassicBackground extends StatelessWidget {
  const GlassicBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DupraColors.scaffoldBackground,
            DupraColors.scaffoldBackground.withValues(alpha: 0.95),
            DupraColors.tertiary.withValues(alpha: 0.15),
            DupraColors.scaffoldBackground,
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DupraColors.secondary.withValues(alpha: 0.15),
                    DupraColors.tertiary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -180,
            right: -120,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DupraColors.tertiary.withValues(alpha: 0.22),
                    DupraColors.tertiary.withValues(alpha: 0.12),
                    DupraColors.success.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.35,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DupraColors.secondary.withValues(alpha: 0.1),
                    DupraColors.tertiary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.5,
            left: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DupraColors.tertiary.withValues(alpha: 0.18),
                    DupraColors.tertiary.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.sizeOf(context).height * 0.2,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DupraColors.success.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
