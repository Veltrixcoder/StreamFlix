
import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      radius: 0.5,
      surfaceOpacity: 0.1,
      brightness: Brightness.dark,
      colorScheme: ColorSchemes.darkZinc(),
      fontFamily: GoogleFonts.inter().fontFamily,
    );
  }
}
