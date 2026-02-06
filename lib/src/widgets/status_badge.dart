import 'package:flutter/material.dart';
import '../theme/table_theme.dart';

/// A pill-shaped status badge widget.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;
  final double borderRadius;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.borderRadius = 20,
  });

  /// Creates a success-styled badge.
  factory StatusBadge.success(String label, {BuildContext? context}) {
    final theme = context != null
        ? DataTablePlusThemeProvider.of(context)
        : DataTablePlusTheme.defaultTheme;
    return StatusBadge(
      label: label,
      backgroundColor: theme.successLightColor,
      textColor: theme.successColor,
    );
  }

  /// Creates a warning-styled badge.
  factory StatusBadge.warning(String label, {BuildContext? context}) {
    final theme = context != null
        ? DataTablePlusThemeProvider.of(context)
        : DataTablePlusTheme.defaultTheme;
    return StatusBadge(
      label: label,
      backgroundColor: theme.warningLightColor,
      textColor: theme.warningColor,
    );
  }

  /// Creates a danger-styled badge.
  factory StatusBadge.danger(String label, {BuildContext? context}) {
    final theme = context != null
        ? DataTablePlusThemeProvider.of(context)
        : DataTablePlusTheme.defaultTheme;
    return StatusBadge(
      label: label,
      backgroundColor: theme.dangerLightColor,
      textColor: theme.dangerColor,
    );
  }

  /// Creates an accent/info-styled badge.
  factory StatusBadge.info(String label, {BuildContext? context}) {
    final theme = context != null
        ? DataTablePlusThemeProvider.of(context)
        : DataTablePlusTheme.defaultTheme;
    return StatusBadge(
      label: label,
      backgroundColor: theme.accentLightColor,
      textColor: theme.accentColor,
    );
  }

  /// Creates a neutral/muted badge.
  factory StatusBadge.neutral(String label, {BuildContext? context}) {
    final theme = context != null
        ? DataTablePlusThemeProvider.of(context)
        : DataTablePlusTheme.defaultTheme;
    return StatusBadge(
      label: label,
      backgroundColor: theme.borderLightColor,
      textColor: theme.textSecondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

/// A small count badge, typically used for notifications.
class CountBadge extends StatelessWidget {
  final int count;
  final Color? backgroundColor;
  final Color? textColor;

  const CountBadge({
    super.key,
    required this.count,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.dangerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}
