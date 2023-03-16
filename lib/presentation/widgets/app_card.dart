import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: child,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class AppMaterial extends StatelessWidget {
  final Clip clipBehavior;
  final Color color;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final child;
  final double radius;
  final double? height;
  final double? width;
  final double elevation;
  final AlignmentGeometry? alignment;
  final double blurRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final BoxDecoration? decoration;

  const AppMaterial({
    Key? key,
    this.color = Colors.white,
    this.child,
    this.radius = 16.0,
    this.blurRadius = 16.0,
    this.boxShadow,
    this.border,
    this.margin = EdgeInsets.zero,
    this.height,
    this.alignment,
    this.padding,
    this.width,
    this.onTap,
    this.elevation = 13.0,
    this.clipBehavior = Clip.none,
    this.decoration,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        type: MaterialType.card,
        elevation: elevation,
        clipBehavior: clipBehavior,
        shadowColor: AppColors.offset,
        borderRadius: BorderRadius.circular(radius),
        color: color,
        child: Ink(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              padding: padding,
              height: height,
              width: width,
              alignment: alignment,
              decoration: decoration,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
