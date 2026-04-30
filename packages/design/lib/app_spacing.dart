/// Spacing scale and breakpoints for QuantumPips.
///
/// 4-pt baseline grid. Use these constants instead of magic numbers in
/// EdgeInsets/SizedBox so the rhythm stays consistent across screens.
class AppSpacing {
  AppSpacing._();

  // 4-pt scale
  static const double xs = 4;    // micro-gaps inside compact components
  static const double sm = 8;    // chip padding, small gaps
  static const double md = 12;   // tight content padding
  static const double lg = 16;   // standard content padding
  static const double xl = 24;   // section internal padding, card padding
  static const double xxl = 32;  // larger section gaps, card gaps
  static const double x3 = 48;   // section vertical padding
  static const double x4 = 64;   // major section gaps
  static const double x5 = 96;   // hero / large section gaps
  static const double x6 = 128;  // huge gaps, hero vertical padding (desktop)

  // ---- Border radii ----
  static const double radiusSm = 6;    // chips, small tags
  static const double radiusMd = 10;   // buttons, inputs
  static const double radiusLg = 16;   // cards
  static const double radiusXl = 24;   // dialogs, hero illustrations
  static const double radiusFull = 999; // pills

  // ---- Layout widths ----
  static const double maxContentWidth = 1200;
  static const double maxNarrowContentWidth = 720;  // for prose-only sections

  // ---- Breakpoints ----
  static const double mobileMax = 599;
  static const double tabletMin = 600;
  static const double tabletMax = 1023;
  static const double desktopMin = 1024;
}

/// Returns true if the given screen width is below the mobile breakpoint.
bool isMobile(double width) => width < AppSpacing.tabletMin;
bool isTablet(double width) =>
    width >= AppSpacing.tabletMin && width < AppSpacing.desktopMin;
bool isDesktop(double width) => width >= AppSpacing.desktopMin;
