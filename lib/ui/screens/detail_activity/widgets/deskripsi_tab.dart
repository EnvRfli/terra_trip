import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../theme/app_theme.dart';

class DeskripsiTab extends StatelessWidget {
  const DeskripsiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildTopCards(),
        const SizedBox(height: 16),
        _buildProgressCard(),
        const SizedBox(height: 16),
        _buildShareCard(),
        const SizedBox(height: 16),
        _buildCalendarCard(),
        const SizedBox(height: 16),
        _buildTimeCards(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTopCards() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: AppTheme.headerGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // SVG Background with gradient shader
                Positioned(
                  right: -135,
                  top: -30,
                  bottom: -30,
                  child: Transform.rotate(
                    angle: 0.1,
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [Color(0xFFFFD05D), Color(0xFFFF885D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: SvgPicture.asset(
                        'lib/assets/arrow_card_background.svg',
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Text Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Budget',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Rp 5.000.000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB700),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Sedang\nBerlangsung',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Kegiatan',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          // Custom Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(height: 12, color: AppTheme.statusSelesai),
                ),
                Expanded(
                  flex: 1,
                  child: Container(height: 12, color: AppTheme.statusBatal),
                ),
                Expanded(
                  flex: 4,
                  child: Container(height: 12, color: AppTheme.backgroundApp),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Legends
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegend(AppTheme.statusSelesai, 'Selesai'),
              _buildLegend(AppTheme.statusBatal, 'Dibatalkan'),
              _buildLegend(AppTheme.backgroundApp, 'Belum Terlaksana',
                  textColor: AppTheme.textGrey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label, {Color? textColor}) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: textColor ?? AppTheme.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildShareCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bagikan Jadwal dengan Tim',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avatar Stack
              SizedBox(
                height: 36,
                width: 160,
                child: Stack(
                  children: List.generate(
                    6, // Dummy count
                    (index) => Positioned(
                      left: index * 24.0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            image: AssetImage(
                                'lib/assets/State=\${(index % 4) + 1}.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Share Button
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundApp,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  PhosphorIconsRegular.shareNetwork,
                  size: 16,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    final days = ['MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Oktober 2026',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              Row(
                children: [
                  Icon(PhosphorIconsRegular.caretLeft,
                      color: AppTheme.textGrey.withValues(alpha: 0.5),
                      size: 20),
                  const SizedBox(width: 16),
                  const Icon(PhosphorIconsRegular.caretRight,
                      color: AppTheme.textDark, size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days
                .map((day) => Text(
                      day,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: day == 'MIN'
                            ? AppTheme.statusBatal
                            : AppTheme.textDark,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
          // Dummy Grid
          _buildCalendarRow(['29', '30', '1', '2', '3', '4', '5'],
              isPrevMonth: true),
          _buildCalendarRow(['6', '7', '8', '9', '10', '11', '12']),
          _buildCalendarRow(['13', '14', '15', '16', '17', '18', '19']),
          _buildCalendarRow(['20', '21', '22', '23', '24', '25', '26']),
          _buildCalendarRow(['27', '28', '29', '30', '31', '1', '2'],
              activeDate: '30', isNextMonthStart: 5),
        ],
      ),
    );
  }

  Widget _buildCalendarRow(List<String> dates,
      {bool isPrevMonth = false,
      String? activeDate,
      int isNextMonthStart = 99}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dates.asMap().entries.map((entry) {
          final idx = entry.key;
          final date = entry.value;
          final isSunday = idx == 0;
          final isActive = date == activeDate;
          final isFaded = isPrevMonth && (idx < 2) || (idx >= isNextMonthStart);

          return Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: isActive
                ? const BoxDecoration(
                    color: AppTheme.accentAmber,
                    shape: BoxShape.circle,
                  )
                : null,
            child: Text(
              date,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : (isFaded
                        ? (isSunday
                            ? AppTheme.statusBatal.withValues(alpha: 0.3)
                            : AppTheme.textGrey.withValues(alpha: 0.3))
                        : (isSunday
                            ? AppTheme.statusBatal
                            : AppTheme.textDark)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeCards() {
    return Row(
      children: [
        Expanded(
          child: _buildTimeCard(
            label: 'Waktu Mulai',
            time: '08:00',
            backgroundColor: const Color(0xFF00C3D0), // Cyan
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTimeCard(
            label: 'Waktu Selesai',
            time: '20:00',
            backgroundColor: const Color(0xFF5EC564), // Green
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCard(
      {required String label,
      required String time,
      required Color backgroundColor}) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Icon
          Positioned(
            right: -25,
            bottom: 15,
            child: Opacity(
              opacity: 0.15,
              child: const Icon(
                PhosphorIconsRegular.clock,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  PhosphorIconsRegular.clock,
                  color: Colors.white,
                  size: 20,
                ),
                const Spacer(),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
