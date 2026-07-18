import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/../theme/app_theme.dart';

class MemberSelector extends StatelessWidget {
  final List<String> memberImages; // URLs or asset paths
  final VoidCallback onAddMember;
  final Function(int) onMemberTap;

  const MemberSelector({
    super.key,
    required this.memberImages,
    required this.onAddMember,
    required this.onMemberTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anggota',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...memberImages.asMap().entries.map((entry) {
                final index = entry.key;
                final imageUrl = entry.value;
                return Align(
                  widthFactor: 0.75,
                  child: GestureDetector(
                    onTap: () => onMemberTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.backgroundApp,
                        child: ClipOval(
                          child: imageUrl.startsWith('http')
                              ? Image.network(imageUrl, fit: BoxFit.cover)
                              : imageUrl.endsWith('.svg')
                                  ? SvgPicture.asset(imageUrl, fit: BoxFit.cover)
                                  : Image.asset(imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onAddMember,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.plus,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
