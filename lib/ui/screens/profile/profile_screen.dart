import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../theme/app_theme.dart';
import 'widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Gradient & Pattern
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.headerGradient,
              ),
              child: Opacity(
                opacity: 0.05,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Image.asset(
                    'lib/assets/detail_header_background.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // AppBar replacement
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          PhosphorIconsRegular.arrowLeft,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Profile Card Container
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // Avatar and White Card
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 60),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 70, 20, 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Trio Dwi Pratama',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF344054),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Stats Card
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFB700),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFFB700)
                                              .withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildStatItem(
                                            icon: PhosphorIconsRegular.target,
                                            label: 'Total Kegiatan',
                                            value: '246',
                                          ),
                                        ),
                                        Container(
                                          height: 70,
                                          width: 2,
                                          color: Colors.white
                                              .withValues(alpha: 0.3),
                                        ),
                                        Expanded(
                                          child: _buildStatItem(
                                            icon: PhosphorIconsRegular.money,
                                            label: 'Total Budget',
                                            value: 'Rp 1.000.000',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Avatar
                            Positioned(
                              top: 0,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 4),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'lib/assets/State=1.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFB700),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                      ),
                                      child: const Icon(
                                        PhosphorIconsFill.pencilSimple,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Menus
                        ProfileMenuItem(
                          icon: PhosphorIconsRegular.gearSix,
                          title: 'Pengaturan Akun',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: PhosphorIconsRegular.clockCounterClockwise,
                          title: 'Riwayat Kegiatan',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: PhosphorIconsRegular.globe,
                          title: 'Bahasa',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: PhosphorIconsRegular.signOut,
                          title: 'Keluar Aplikasi',
                          isDestructive: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
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
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
