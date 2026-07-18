import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class CustomTabBar extends StatefulWidget {
  final TabController tabController;

  const CustomTabBar({
    super.key,
    required this.tabController,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() {
    if (widget.tabController.indexIsChanging ||
        widget.tabController.index == widget.tabController.animation?.value) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = widget.tabController.index;

    return Container(
      color: const Color(0xFFFF5EC2).withValues(alpha: 0.0), // Transparent to show header gradient
      child: Row(
        children: [
          _buildTab(
            index: 0,
            title: 'Jadwal',
            isSelected: currentIndex == 0,
            onTap: () => widget.tabController.animateTo(0),
          ),
          _buildTab(
            index: 1,
            title: 'Deskripsi',
            isSelected: currentIndex == 1,
            onTap: () => widget.tabController.animateTo(1),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.backgroundApp : Colors.transparent,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFFFF5EC2) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
