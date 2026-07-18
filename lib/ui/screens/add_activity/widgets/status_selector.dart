import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class StatusSelector extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusSelected;

  const StatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status Aktivitas',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildStatusButton('Selesai', AppTheme.statusSelesai),
            const SizedBox(width: 12),
            _buildStatusButton('Batal', AppTheme.backgroundApp, isBatal: true),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusButton(String status, Color activeColor,
      {bool isBatal = false}) {
    final isSelected = selectedStatus == status;
    return GestureDetector(
      onTap: () => onStatusSelected(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : AppTheme.backgroundApp,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected
                ? (isBatal ? AppTheme.textDark : Colors.white)
                : AppTheme.textGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
