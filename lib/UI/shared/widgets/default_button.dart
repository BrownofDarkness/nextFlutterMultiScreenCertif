import 'package:flutter/material.dart';
import 'package:next_flutter_recipe/utils/button_states.dart';
import 'package:next_flutter_recipe/utils/colors.dart';

class DefaultButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final double? width;
  final ButtonState buttonState;
  final Color backgroundColor;
  final double? contentSize;
  const DefaultButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.width,
    this.buttonState = ButtonState.enabled,
    this.backgroundColor = AppColors.primaryColor,
    this.contentSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = buttonState == ButtonState.enabled
        ? backgroundColor
        : backgroundColor.withOpacity(0.5);
    final effectiveContentColor = buttonState == ButtonState.enabled
        ? Colors.white
        : Colors.white.withOpacity(0.5);
    return SizedBox(
      width: width ?? double.maxFinite,
      child: ElevatedButton(
        onPressed: buttonState == ButtonState.enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveContentColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child:  buttonState == ButtonState.loading
            ? SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(effectiveContentColor),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: contentSize??16,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: 20),
              Icon(icon, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
