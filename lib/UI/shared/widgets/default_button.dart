import 'package:flutter/material.dart';

import '../../../utils/button_states.dart';

class DefaultButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final double? width;
  final ButtonState buttonState;
  final Color? backgroundColor;
  final double? contentSize;

  const DefaultButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.width,
    this.buttonState = ButtonState.enabled,
    this.backgroundColor,
    this.contentSize,
  });

  bool get _enabled => buttonState == ButtonState.enabled;
  bool get _loading => buttonState == ButtonState.loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? scheme.primary;
    final effectiveBg = _enabled ? bg : bg.withValues(alpha: 0.5);
    final onBg = _enabled ? scheme.onPrimary : scheme.onPrimary.withValues(alpha: 0.6);

    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: _enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBg,
          foregroundColor: onBg,
          disabledBackgroundColor: effectiveBg,
          disabledForegroundColor: onBg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: _loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(onBg),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: contentSize ?? 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
