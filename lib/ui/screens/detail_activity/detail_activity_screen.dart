import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/app_theme.dart';
import 'widgets/detail_header.dart';
import 'widgets/custom_tab_bar.dart';
import 'widgets/timeline_list.dart';

class DetailActivityScreen extends StatefulWidget {
  final String activityId;

  const DetailActivityScreen({
    super.key,
    required this.activityId,
  });

  @override
  State<DetailActivityScreen> createState() => _DetailActivityScreenState();
}

class _DetailActivityScreenState extends State<DetailActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundApp,
        body: Column(
          children: [
            Stack(
              children: [
                // 1. Bottom Layer: Solid Pink Gradient
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFF5EC2),
                          Color(0xFFFF85D4),
                        ],
                      ),
                    ),
                  ),
                ),
                // 2. Middle Layer: The SVG Pattern (faint white)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.05,
                    child: Image.asset(
                      'lib/assets/detail_header_background.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // 3. Top Layer: The content (Header + Tabs)
                Column(
                  children: [
                    const DetailHeader(
                      category: 'Kencan',
                      title: "Jakarta's Date 🐠💞",
                      subtitle:
                          'Melihat aquarium di Jakarta bersama ayang selama 3 hari',
                    ),
                    CustomTabBar(tabController: _tabController),
                  ],
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const TimelineList(),
                  const Center(
                      child: Text('Deskripsi')), // Placeholder for Tab 2
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.weatherBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: const Text(
                'Tambah Aktivitas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
