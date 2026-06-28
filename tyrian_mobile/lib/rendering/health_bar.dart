import 'package:flutter/material.dart';

/// Reusable stat bar widget for HUD and ComCenter.
/// Renders as N discrete segments with an optional sprite icon on the left.
class HealthBar extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final Color color;
  final Color? backgroundColor;
  final double height;
  final Widget? icon;
  final int segments;
  final TextStyle? labelStyle;

  const HealthBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    this.backgroundColor,
    this.height = 10,
    this.icon,
    this.segments = 5,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;
    final filled = (ratio * segments).round();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          SizedBox(width: 16, height: 16, child: icon),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$label  ${value.toInt()} / ${maxValue.toInt()}',
                style: labelStyle ??
                    const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  for (int i = 0; i < segments; i++) ...[
                    Expanded(
                      child: Container(
                        height: height,
                        decoration: BoxDecoration(
                          color: i < filled
                              ? color
                              : (backgroundColor ?? color.withAlpha(35)),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                    if (i < segments - 1) const SizedBox(width: 2),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
