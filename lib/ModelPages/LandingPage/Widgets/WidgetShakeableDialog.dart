import 'dart:math';

import 'package:flutter/material.dart';

class WidgetShakeableDialog extends StatefulWidget {
  final Duration duration; // how fast to shake
  final double distance; // how far to shake
  var child;
  WidgetShakeableDialog({
    super.key,
    this.child,
    this.duration = const Duration(milliseconds: 300),
    this.distance = 24.0,
  });

  @override
  State<WidgetShakeableDialog> createState() => _WidgetShakeableDialogState();
}

class _WidgetShakeableDialogState extends State<WidgetShakeableDialog> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await _controller.forward(from: 0.0);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final dx = sin(_controller.value * 2 * pi) * widget.distance;
          return Transform.translate(
            offset: Offset(dx, 0),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
