import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PaginationDots extends StatelessWidget {
  final int currentIndex;
  final int totalDots;
  
  const PaginationDots({
    super.key,
    this.currentIndex = 0,
    this.totalDots = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex 
                ? AppTheme.primaryDarkBlue 
                : AppTheme.dotInactive,
          ),
        ),
      ),
    );
  }
}