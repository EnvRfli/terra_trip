import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../theme/app_theme.dart';
import '../add_schedule/widgets/custom_text_field.dart';
import '../add_schedule/widgets/member_selector.dart';
import '../add_schedule/widgets/add_member_bottom_sheet.dart';
import '../add_schedule/widgets/list_member_bottom_sheet.dart';
import 'widgets/status_selector.dart';
import 'widgets/image_selector.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuMulaiController = TextEditingController();
  final TextEditingController _waktuSelesaiController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  String _selectedStatus = 'Selesai';
  bool _isHidden = true;

  final List<Map<String, String>> _members = [
    {'name': 'User 1', 'image': 'lib/assets/State=1.jpg'},
    {'name': 'User 2', 'image': 'lib/assets/State=2.jpg'},
    {'name': 'User 3', 'image': 'lib/assets/State=3.jpg'},
    {'name': 'User 4', 'image': 'lib/assets/State=4.jpg'},
  ];

  final List<String> _images = [
    'lib/assets/detail_header_background.png',
    'lib/assets/detail_header_background.png',
  ];

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
      backgroundColor: AppTheme.backgroundCard,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppTheme.backgroundCard,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 8),
          icon: Container(
            padding: const EdgeInsets.all(10),
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
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tambah Aktivitas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                  ),
            ),
            const Text(
              "Jakarta's Date 🐠💞",
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.accentAmber,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
                    CustomTextField(
                      label: 'Judul Aktivitas',
                      hintText: 'eg : Jakarta\'s Date',
                      controller: _judulController,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Deskripsi Aktivitas',
                      hintText: 'Masukkan deskripsi',
                      controller: _deskripsiController,
                      maxLines: 4,
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
                    StatusSelector(
                      selectedStatus: _selectedStatus,
                      onStatusSelected: (status) {
                        setState(() => _selectedStatus = status);
                      },
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
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    ImageSelector(
                      images: _images,
                      onAddImage: () {
                        setState(() {
                          // Dummy add for now
                          _images
                              .add('lib/assets/detail_header_background.png');
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kegiatan disembunyikan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hanya disembunyikan di anggota',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textGrey,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isHidden,
                          onChanged: (value) {
                            setState(() {
                              _isHidden = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: AppTheme.statusSelesai,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor:
                              AppTheme.textGrey.withValues(alpha: 0.3),
                          trackOutlineColor: WidgetStateProperty.resolveWith(
                            (states) => Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
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
