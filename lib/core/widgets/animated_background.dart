import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final dx = 30 * (_controller.value - 0.5);
        final dy = 20 * (0.5 - _controller.value);
        return Stack(
          children: [
            Positioned(
              top: 40 + dy,
              left: -60 + dx,
              child: _glow(160, Colors.purpleAccent.withOpacity(0.08)),
            ),
            Positioned(
              bottom: -20 - dy,
              right: -40 - dx,
              child: _glow(140, Colors.blueAccent.withOpacity(0.08)),
            ),
            widget.child,
          ],
        );
      },
    );
  }

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 80,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}
