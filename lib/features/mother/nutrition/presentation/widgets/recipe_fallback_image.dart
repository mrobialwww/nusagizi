import 'package:flutter/material.dart';

class RecipeFallbackImage extends StatelessWidget {
  final double width;
  final double height;
  final double iconSize;

  const RecipeFallbackImage({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.restaurant, color: Colors.grey, size: iconSize),
      ),
    );
  }
}
