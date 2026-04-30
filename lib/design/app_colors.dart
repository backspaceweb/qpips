import 'package:flutter/material.dart';

/// QuantumPips brand color system.
///
/// Anchored on a deep forest/teal-green primary — chosen to differentiate
/// from the SaaS-blue field most copy-trading platforms occupy. The
/// palette balances "premium financial" trust with modern clarity.
///
/// Use these constants via `Theme.of(context).colorScheme` after the
/// theme is wired in `app_theme.dart`. Direct access (e.g.
/// `AppColors.primary`) is fine for static contexts like landing pages.
class AppColors {
  AppColors._();

  // ---- Brand ----
  /// Deep teal/forest. Primary brand color — used in dark hero/footer
  /// backgrounds, brand wordmarks, and large surfaces requiring presence.
  static const Color primary = Color(0xFF0F4C3A);

  /// Slightly brighter teal for primary CTAs, links, focus rings.
  static const Color primaryAccent = Color(0xFF1A8B6B);

  /// Even brighter — used for hover states on top of primaryAccent.
  static const Color primaryHover = Color(0xFF22A37D);

  /// Subtle teal tint — used for light backgrounds, hover surfaces, chips.
  static const Color primarySoft = Color(0xFFE8F5F0);

  // ---- Surfaces (light theme) ----
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF7F9F8);  // very light warm-gray
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceBorder = Color(0xFFE5E9E7);

  // ---- Surfaces (dark theme & dark hero/footer regions) ----
  static const Color surfaceDark = Color(0xFF0A1F18);   // near-black with teal undertone
  static const Color surfaceDarkRaised = Color(0xFF112A22);
  static const Color surfaceDarkBorder = Color(0xFF1F3A30);

  // ---- Text ----
  static const Color textPrimary = Color(0xFF0F1714);   // near-black with cool warmth
  static const Color textSecondary = Color(0xFF4A5C55);
  static const Color textMuted = Color(0xFF8A9690);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkMuted = Color(0xFFB6C8C0);

  // ---- Semantic (financial conventions) ----
  static const Color profit = Color(0xFF10B981);   // a clearer trade-green than the brand teal
  static const Color loss = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ---- Misc ----
  static const Color shadow = Color(0x1A0F1714);
  static const Color overlay = Color(0xCC0A1F18);

  // ---- Gradients ----
  /// Hero / dark-section background. Subtle vertical gradient adds depth
  /// vs flat dark color.
  static const LinearGradient heroBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A1F18), Color(0xFF0F4C3A), Color(0xFF0A2820)],
    stops: [0.0, 0.55, 1.0],
  );

  /// Subtle accent gradient for primary buttons in their default state.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A8B6B), Color(0xFF22A37D)],
  );

  /// Decorative — for hero illustration backgrounds, feature-block accents.
  static const LinearGradient softMint = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8F5F0), Color(0xFFD4ECE2)],
  );
}
