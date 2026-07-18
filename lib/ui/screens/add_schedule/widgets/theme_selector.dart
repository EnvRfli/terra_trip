import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ThemeSelector extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ThemeSelector({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  static const List<Color> _themeColors = [
    Color(0xFF5568F5), // primaryBlue
    Color(0xFFFFB01D), // accentAmber
    Color(0xFFFF4D4D), // statusBatal
    Color(0xFF00C9E0), // badgeLiburan
    Color(0xFFFF65C3), // badgeKencan
    Color(0xFF4DDA9C), // statusSelesai
    Color(0xFFFF8A65), // orange
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tema',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _themeColors.map((color) {
              final isSelected = selectedColor == color;
              return GestureDetector(
                onTap: () => onColorSelected(color),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(
                          PhosphorIconsRegular.check,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
