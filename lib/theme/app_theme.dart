import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF5568F5);
  static const Color accentAmber = Color(0xFFFFB01D);
  static const Color weatherBlue = Color(0xFF4F68D9);
  
  // Background Colors
  static const Color backgroundApp = Color(0xFFF4F6FC);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  
  // Status & Badge Colors
  static const Color badgeLiburan = Color(0xFF00C9E0);
  static const Color badgeKencan = Color(0xFFFF65C3);
  static const Color statusSelesai = Color(0xFF4DDA9C);
  static const Color statusBatal = Color(0xFFFF4D4D);
  static const Color statusBerlangsung = Color(0xFFFFB01D);

  // Text Colors
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textGrey = Color(0xFF8A8A8E);
  static const Color textLight = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF647ED4),
      Color(0xFF4966D4),
    ],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentAmber,
        surface: backgroundApp,
        surfaceContainerLow: backgroundCard,
      ),
      scaffoldBackgroundColor: backgroundApp,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineSmall: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        titleMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          color: textGrey,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundApp,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentAmber,
        foregroundColor: Colors.white,
      ),
    );
  }
}
