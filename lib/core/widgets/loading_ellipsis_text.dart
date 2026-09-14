import 'dart:async';
import 'package:flutter/material.dart';

class LoadingEllipsisText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const LoadingEllipsisText({super.key, required this.text, this.style});

  @override
  State<LoadingEllipsisText> createState() => _LoadingEllipsisTextState();
}

class _LoadingEllipsisTextState extends State<LoadingEllipsisText> {
  int _dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4; // 0, 1, 2, 3
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = '.' * _dotCount;
    // Add spaces to maintain consistent width so layout doesn't jump
    final paddedDots = dots.padRight(3, ' ');
    return Text('${widget.text}$paddedDots', style: widget.style);
  }
}
