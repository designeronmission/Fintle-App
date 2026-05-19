import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isPrimary ? AppTheme.primaryDarkBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(190),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: AppTheme.buttonTextStyle.copyWith(
              color: isPrimary ? Colors.white : AppTheme.primaryDarkBlue,
            ),
          ),
        ),
      ),
    );
  }
}