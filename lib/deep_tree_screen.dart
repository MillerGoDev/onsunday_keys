import 'package:flutter/material.dart';

class DeepTreeScreen extends StatefulWidget {
  const DeepTreeScreen({super.key});

  @override
  State<DeepTreeScreen> createState() => _DeepTreeScreenState();
}

class _DeepTreeScreenState extends State<DeepTreeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            setState(() {});
          });
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Circle child = Circle(width: _controller.value * 200, color: Colors.black);
    for (var i = 0; i < 300; i++) {
      child = Circle(
        width: child.width + 2,
        color: i % 2 == 0 ? Colors.black : Colors.white,
        child: child,
      );
    }
    return Scaffold(
      body: Center(
        child: child,
      ),
    );
  }
}

class Circle extends StatelessWidget {
  const Circle(
      {super.key, required this.width, required this.color, this.child});

  final double width;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
