import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../theme/app_theme.dart';
import 'widgets/theme_selector.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/category_selector.dart';
import 'widgets/member_selector.dart';
import 'widgets/add_category_bottom_sheet.dart';
import 'widgets/add_member_bottom_sheet.dart';
import 'widgets/list_member_bottom_sheet.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  Color _selectedTheme = const Color(0xFF5568F5);
  String _selectedCategory = 'Kencan';

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuMulaiController = TextEditingController();
  final TextEditingController _waktuSelesaiController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  final List<String> _categories = [
    'Liburan',
    'Kencan',
    'Hari Raya',
  ];

  final List<Map<String, String>> _members = [];

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _tanggalController.dispose();
    _waktuMulaiController.dispose();
    _waktuSelesaiController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundCard, // white background as in design
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.backgroundCard,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 8),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.backgroundApp,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              PhosphorIconsRegular.arrowLeft,
              color: AppTheme.textDark,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tambah Jadwal',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
              ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ThemeSelector(
                      selectedColor: _selectedTheme,
                      onColorSelected: (color) {
                        setState(() => _selectedTheme = color);
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Judul Kegiatan',
                      hintText: 'eg : Jakarta\'s Date',
                      controller: _judulController,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Deskripsi Kegiatan',
                      hintText: 'Masukkan deskripsi',
                      controller: _deskripsiController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    CategorySelector(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() => _selectedCategory = category);
                      },
                      onAddCategory: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddCategoryBottomSheet(
                            onAdd: (category) {
                              setState(() {
                                _categories.add(category);
                                _selectedCategory = category;
                              });
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Tanggal',
                      hintText: 'Pilih tanggal',
                      controller: _tanggalController,
                      readOnly: true,
                      prefixIcon: const Icon(
                        PhosphorIconsRegular.calendarBlank,
                        color: AppTheme.textDark,
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          _tanggalController.text =
                              "\${date.day}/\${date.month}/\${date.year}";
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Waktu Mulai',
                            hintText: 'Pilih waktu',
                            controller: _waktuMulaiController,
                            readOnly: true,
                            prefixIcon: const Icon(
                              PhosphorIconsRegular.clock,
                              color: AppTheme.textDark,
                            ),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                if (!context.mounted) return;
                                _waktuMulaiController.text =
                                    time.format(context);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: 'Waktu Selesai',
                            hintText: 'Pilih waktu',
                            controller: _waktuSelesaiController,
                            readOnly: true,
                            prefixIcon: const Icon(
                              PhosphorIconsRegular.clock,
                              color: AppTheme.textDark,
                            ),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                if (!context.mounted) return;
                                _waktuSelesaiController.text =
                                    time.format(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Budget',
                      hintText: 'Masukkan budget',
                      controller: _budgetController,
                    ),
                    const SizedBox(height: 24),
                    MemberSelector(
                      memberImages: _members.map((e) => e['image']!).toList(),
                      onAddMember: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddMemberBottomSheet(
                            onAdd: (name, imagePath) {
                              setState(() {
                                _members
                                    .add({'name': name, 'image': imagePath});
                              });
                            },
                          ),
                        );
                      },
                      onMemberTap: (index) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ListMemberBottomSheet(
                            members: _members,
                            onDelete: (idx) {
                              setState(() {
                                _members.removeAt(idx);
                              });
                              // Close and re-open to refresh the bottom sheet state,
                              // or just let it close since it might be simpler.
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40), // extra padding at bottom
                  ],
                ),
              ),
            ),
            // Bottom Save Button
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppTheme.backgroundCard,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.textGrey.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle save schedule
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: AppTheme.weatherBlue,
                    surfaceTintColor: AppTheme.weatherBlue,
                    backgroundColor: AppTheme.weatherBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
