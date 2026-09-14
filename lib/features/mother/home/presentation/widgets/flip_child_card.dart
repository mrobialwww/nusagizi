import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:nusagizi/features/mother/home/domain/entities/child_summary_entity.dart';
import 'package:nusagizi/features/mother/home/presentation/widgets/front_child_card.dart';
import 'package:nusagizi/features/mother/home/presentation/widgets/back_child_card.dart';

class FlipChildCard extends StatefulWidget {
  final ChildSummaryEntity childData;

  const FlipChildCard({super.key, required this.childData});

  @override
  State<FlipChildCard> createState() => _FlipChildCardState();
}

class _FlipChildCardState extends State<FlipChildCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * math.pi;
        final isFrontVisible = angle <= math.pi / 2;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isFrontVisible
              ? FrontChildCard(childData: widget.childData, onFlip: _toggleCard)
              : Transform(
                  transform: Matrix4.identity()..rotateY(math.pi),
                  alignment: Alignment.center,
                  child: BackChildCard(
                    childData: widget.childData,
                    onFlip: _toggleCard,
                  ),
                ),
        );
      },
    );
  }
}
