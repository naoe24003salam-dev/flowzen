import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../constants/animation_constants.dart';
import '../utils/haptic_utils.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Colors.white),
        ),
      ],
    );

    return AnimatedScale(
      duration: AnimationConstants.short,
      scale: onPressed != null ? 1 : 0.98,
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () {
                HapticUtils.lightImpact();
                onPressed?.call();
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
          backgroundColor:
              isPrimary ? null : AppColors.textSecondary.withOpacity(0.15),
          foregroundColor: Colors.white,
          shadowColor: Colors.black12,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (!isPrimary) return AppColors.textSecondary.withOpacity(0.15);
            if (states.contains(WidgetState.disabled)) {
              return AppColors.primary.withOpacity(0.5);
            }
            return null;
          }),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: isPrimary ? AppColors.gradientPrimary : null,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: child,
          ),
        ),
      ),
    );
  }
}
