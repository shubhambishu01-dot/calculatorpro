import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool isDarkMode;
  final Color accentColor;

  const TopNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.isDarkMode,
    required this.accentColor,
  });

  static const _icons = [
    Icons.calculate_outlined,
    Icons.grid_view_rounded,
    Icons.description_outlined,
    Icons.more_vert,
  ];

  @override
  Widget build(BuildContext context) {
    final bg = isDarkMode ? const Color(0xFF0E0E10) : const Color(0xFFF3F4F6);
    final inactive = isDarkMode ? Colors.white38 : Colors.black38;

    return Container(
      color: bg,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_icons.length, (index) {
              final isSelected = index == selectedIndex;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  onSelect(index);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  child: Icon(
                    _icons[index],
                    color: isSelected ? accentColor : inactive,
                    size: 24,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52);
}
