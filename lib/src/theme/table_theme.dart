import 'package:flutter/material.dart';

/// Theme configuration for DataTablePlus widgets.
class DataTablePlusTheme {
  final Color backgroundColor;
  final Color headerBackgroundColor;
  final Color borderColor;
  final Color borderLightColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color textMutedColor;
  final Color accentColor;
  final Color accentLightColor;
  final Color successColor;
  final Color successLightColor;
  final Color warningColor;
  final Color warningLightColor;
  final Color dangerColor;
  final Color dangerLightColor;
  final double borderRadius;
  final double borderRadiusSmall;
  final EdgeInsets headerPadding;
  final EdgeInsets cellPadding;
  final TextStyle? headerTextStyle;
  final TextStyle? cellTextStyle;

  const DataTablePlusTheme({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.headerBackgroundColor = const Color(0xFFF3F4F6),
    this.borderColor = const Color(0xFFE5E7EB),
    this.borderLightColor = const Color(0xFFF3F4F6),
    this.textPrimaryColor = const Color(0xFF1F2937),
    this.textSecondaryColor = const Color(0xFF6B7280),
    this.textMutedColor = const Color(0xFF9CA3AF),
    this.accentColor = const Color(0xFF3B82F6),
    this.accentLightColor = const Color(0xFFEFF6FF),
    this.successColor = const Color(0xFF10B981),
    this.successLightColor = const Color(0xFFECFDF5),
    this.warningColor = const Color(0xFFF59E0B),
    this.warningLightColor = const Color(0xFFFEF3C7),
    this.dangerColor = const Color(0xFFEF4444),
    this.dangerLightColor = const Color(0xFFFEF2F2),
    this.borderRadius = 12.0,
    this.borderRadiusSmall = 8.0,
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.headerTextStyle,
    this.cellTextStyle,
  });

  /// Default theme with standard colors.
  static const DataTablePlusTheme defaultTheme = DataTablePlusTheme();

  /// Get effective header text style.
  TextStyle getHeaderTextStyle() {
    return headerTextStyle ??
        TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textSecondaryColor,
        );
  }

  /// Get effective cell text style.
  TextStyle getCellTextStyle() {
    return cellTextStyle ??
        TextStyle(
          fontSize: 13,
          color: textPrimaryColor,
        );
  }

  DataTablePlusTheme copyWith({
    Color? backgroundColor,
    Color? headerBackgroundColor,
    Color? borderColor,
    Color? borderLightColor,
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? textMutedColor,
    Color? accentColor,
    Color? accentLightColor,
    Color? successColor,
    Color? successLightColor,
    Color? warningColor,
    Color? warningLightColor,
    Color? dangerColor,
    Color? dangerLightColor,
    double? borderRadius,
    double? borderRadiusSmall,
    EdgeInsets? headerPadding,
    EdgeInsets? cellPadding,
    TextStyle? headerTextStyle,
    TextStyle? cellTextStyle,
  }) {
    return DataTablePlusTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderLightColor: borderLightColor ?? this.borderLightColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      textMutedColor: textMutedColor ?? this.textMutedColor,
      accentColor: accentColor ?? this.accentColor,
      accentLightColor: accentLightColor ?? this.accentLightColor,
      successColor: successColor ?? this.successColor,
      successLightColor: successLightColor ?? this.successLightColor,
      warningColor: warningColor ?? this.warningColor,
      warningLightColor: warningLightColor ?? this.warningLightColor,
      dangerColor: dangerColor ?? this.dangerColor,
      dangerLightColor: dangerLightColor ?? this.dangerLightColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderRadiusSmall: borderRadiusSmall ?? this.borderRadiusSmall,
      headerPadding: headerPadding ?? this.headerPadding,
      cellPadding: cellPadding ?? this.cellPadding,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      cellTextStyle: cellTextStyle ?? this.cellTextStyle,
    );
  }
}

/// InheritedWidget to provide theme down the widget tree.
class DataTablePlusThemeProvider extends InheritedWidget {
  final DataTablePlusTheme theme;

  const DataTablePlusThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  static DataTablePlusTheme of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<DataTablePlusThemeProvider>();
    return provider?.theme ?? DataTablePlusTheme.defaultTheme;
  }

  @override
  bool updateShouldNotify(DataTablePlusThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
