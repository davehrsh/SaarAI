import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class ArcadePanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const ArcadePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.border,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}