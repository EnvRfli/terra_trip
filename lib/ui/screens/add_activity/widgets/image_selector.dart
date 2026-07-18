import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../theme/app_theme.dart';

class ImageSelector extends StatelessWidget {
  final List<String> images;
  final VoidCallback onAddImage;

  const ImageSelector({
    super.key,
    required this.images,
    required this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gambar',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...images.map((imagePath) => _buildImageItem(imagePath)),
              _buildAddButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageItem(String imagePath) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddImage,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.textGrey.withValues(alpha: 0.2),
            width: 2,
            style: BorderStyle.solid, 
          ),
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              PhosphorIconsRegular.image,
              color: AppTheme.textGrey.withValues(alpha: 0.3),
              size: 40,
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppTheme.accentAmber,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIconsBold.plus,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
