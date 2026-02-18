import 'package:flutter/material.dart';

class FixedBoxImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;

  const FixedBoxImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    Widget img = Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }

    return img;
  }
}
