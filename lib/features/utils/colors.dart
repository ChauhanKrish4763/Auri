import 'package:flutter/material.dart';

/// App color palette - Kid-friendly yet professional (Duolingo-inspired)
class AppColors {
  // Core Brand Colors
  static const Color primaryIndigo = Color(0xFF4F46E5);    // Your specified primary
  static const Color pureWhite = Color(0xFFFFFFFF);        // Your specified white
  
  // Primary Palette
  static const Color vibrantBlue = Color(0xFF1CB0F6);      // Duolingo-style blue
  static const Color friendlyGreen = Color(0xFF58CC02);    // Success/positive green
  static const Color warmOrange = Color(0xFFFF9600);       // Attention/warning orange
  static const Color playfulPurple = Color(0xFF8B5CF6);    // Secondary purple
  
  // Accent Colors
  static const Color sunnyYellow = Color(0xFFFFC800);      // Highlights/achievements
  static const Color coralPink = Color(0xFFFF6B6B);        // Error/important
  static const Color mintGreen = Color(0xFF4ECDC4);        // Cool accent
  static const Color lavender = Color(0xFFB794F6);         // Soft accent
  
  // Neutral Palette
  static const Color snowWhite = Color(0xFFFBFBFB);        // Background white
  static const Color cloudGray = Color(0xFFF7F7F7);        // Light background
  static const Color silverMist = Color(0xFFE5E7EB);       // Borders/dividers
  static const Color coolGray = Color(0xFF9CA3AF);         // Secondary text
  static const Color slateGray = Color(0xFF6B7280);        // Body text
  static const Color charcoalGray = Color(0xFF374151);     // Primary text
  static const Color deepGray = Color(0xFF1F2937);         // Headers/emphasis
  
  // Semantic Colors
  static const Color successGreen = Color(0xFF10B981);     // Success states
  static const Color warningAmber = Color(0xFFF59E0B);     // Warning states
  static const Color errorRed = Color(0xFFEF4444);         // Error states
  static const Color infoBlue = Color(0xFF3B82F6);         // Info states
  
  // Surface Colors
  static const Color cardWhite = Color(0xFFFFFFFF);        // ✅ FIXED: Card backgrounds (was missing a digit)
  static const Color overlayWhite = Color(0xFFFEFEFE);     // Modal backgrounds
  static const Color inputBackground = Color(0xFFF9FAFB);  // Input fields
  static const Color hoverGray = Color(0xFFF3F4F6);        // Hover states
  
  // Fun Gradient Colors (for kid-friendly elements)
  static const List<Color> rainbowGradient = [
    Color(0xFFFF6B6B),  // Coral
    Color(0xFFFFE66D),  // Yellow
    Color(0xFF4ECDC4),  // Mint
    Color(0xFF45B7D1),  // Sky blue
    Color(0xFF96CEB4),  // Light green
    Color(0xFFFECA57),  // Orange
  ];
  
  static const List<Color> primaryGradient = [
    primaryIndigo,
    playfulPurple,
  ];
  
  static const List<Color> successGradient = [
    friendlyGreen,
    Color(0xFF48BB78),
  ];
  
  // Shadow Colors
  static const Color lightShadow = Color(0x0D000000);      // Subtle shadows
  static const Color mediumShadow = Color(0x1A000000);     // Card shadows
  static const Color darkShadow = Color(0x26000000);       // Strong shadows
}

/// Extension for easy access to gradients
extension AppGradients on AppColors {
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.primaryGradient,
  );
  
  static LinearGradient get successGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: AppColors.successGradient,
  );
  
  static LinearGradient get rainbowGradient => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: AppColors.rainbowGradient,
  );
}
