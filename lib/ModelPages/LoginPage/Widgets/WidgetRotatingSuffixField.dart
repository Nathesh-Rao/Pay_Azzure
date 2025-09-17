import 'package:flutter/material.dart';

class WidgetRotatingSuffixField extends StatefulWidget {
  const WidgetRotatingSuffixField({
    super.key,
    this.width = 20,
  });
  final double width;
  @override
  State<WidgetRotatingSuffixField> createState() => _WidgetRotatingSuffixFieldState();
}

class _WidgetRotatingSuffixFieldState extends State<WidgetRotatingSuffixField> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // Loop animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        "assets/images/loading_circle.png",
        width: widget.width,
      ), // or Image.network
    );
  }
}
