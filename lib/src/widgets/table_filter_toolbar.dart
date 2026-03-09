import 'package:flutter/material.dart';
import 'package:modern_date_picker/modern_date_picker.dart';
import '../theme/table_theme.dart';

/// A configurable two-row filter toolbar widget.
///
/// Provides a main filter row and an optional collapsible advanced filter row.
/// Users can pass any widgets as filter items, and the toolbar handles layout
/// and the expand/collapse animation for advanced filters.
class TableFilterToolbar extends StatelessWidget {
  /// Widgets to display in the main filter row (Row 1).
  /// These will wrap to next line if space is insufficient.
  final List<Widget> mainFilters;

  /// Widgets to display fixed on the right side of the main row.
  /// These do NOT wrap - they stay in place regardless of mainFilters.
  /// Use this for action buttons like "Reset".
  final List<Widget> trailingActions;

  /// Widget fixed at the rightmost position of the filter row.
  /// Use this for the "More" toggle button to ensure it's always at the end.
  final Widget? fixedEndAction;

  /// Widgets to display in the advanced filter row (Row 2).
  /// If empty, no advanced filters section is shown.
  final List<Widget> advancedFilters;

  /// Whether the advanced filters row is expanded.
  final bool showAdvancedFilters;

  /// Callback when advanced filters visibility changes.
  final ValueChanged<bool>? onAdvancedFiltersChanged;

  /// Spacing between filter items in the main row.
  final double mainFilterSpacing;

  /// Spacing between trailing action items.
  final double trailingActionSpacing;

  /// Spacing between filter items in the advanced row.
  final double advancedFilterSpacing;

  /// Run spacing for wrapped items.
  final double runSpacing;

  /// Padding around the entire toolbar.
  final EdgeInsets padding;

  /// Label for the advanced filters section.
  final String advancedFiltersLabel;

  /// Duration of the expand/collapse animation.
  final Duration animationDuration;

  /// Optional trailing widget for the advanced filters row (e.g., clear button).
  final Widget? advancedFiltersTrailing;

  const TableFilterToolbar({
    super.key,
    required this.mainFilters,
    this.trailingActions = const [],
    this.fixedEndAction,
    this.advancedFilters = const [],
    this.showAdvancedFilters = false,
    this.onAdvancedFiltersChanged,
    this.mainFilterSpacing = 12,
    this.trailingActionSpacing = 12,
    this.advancedFilterSpacing = 12,
    this.runSpacing = 12,
    this.padding = const EdgeInsets.all(16),
    this.advancedFiltersLabel = 'Advanced',
    this.animationDuration = const Duration(milliseconds: 200),
    this.advancedFiltersTrailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);

    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Main filters + fixed trailing actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flexible area for main filters (can wrap)
              Expanded(
                child: Wrap(
                  spacing: mainFilterSpacing,
                  runSpacing: runSpacing,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: mainFilters,
                ),
              ),

              // Fixed trailing actions (do not wrap)
              if (trailingActions.isNotEmpty) ...[
                const SizedBox(width: 12),
                Wrap(
                  spacing: trailingActionSpacing,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: trailingActions,
                ),
              ],

              // Fixed end action (always rightmost)
              if (fixedEndAction != null) ...[
                const SizedBox(width: 12),
                fixedEndAction!,
              ],
            ],
          ),

          // Row 2: Advanced filters (collapsible)
          if (advancedFilters.isNotEmpty)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildAdvancedFiltersRow(theme),
              crossFadeState: showAdvancedFilters
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: animationDuration,
            ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFiltersRow(DataTablePlusTheme theme) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
        border: Border.all(
          color: theme.borderColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune, size: 14, color: theme.accentColor),
                const SizedBox(width: 4),
                Text(
                  advancedFiltersLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.accentColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Advanced filter items
          Expanded(
            child: Wrap(
              spacing: advancedFilterSpacing,
              runSpacing: runSpacing,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: advancedFilters,
            ),
          ),

          // Trailing widget (e.g., clear button)
          if (advancedFiltersTrailing != null) advancedFiltersTrailing!,
        ],
      ),
    );
  }
}

/// A styled search field for use in [TableFilterToolbar].
class FilterSearchField extends StatelessWidget {
  /// Current search value.
  final String value;

  /// Callback when search text changes.
  final ValueChanged<String> onChanged;

  /// Placeholder text.
  final String hint;

  /// Width of the search field.
  final double width;

  /// Height of the search field.
  final double height;

  /// Optional text editing controller.
  final TextEditingController? controller;

  /// Keyboard type for the text field (e.g., TextInputType.number).
  final TextInputType? keyboardType;

  /// Optional input action for the keyboard (e.g., TextInputAction.search).
  final TextInputAction? textInputAction;

  const FilterSearchField({
    super.key,
    this.value = '',
    required this.onChanged,
    this.hint = 'Search...',
    this.width = 280,
    this.height = 40,
    this.controller,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: TextStyle(fontSize: 13, color: theme.textPrimaryColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: theme.textMutedColor),
          prefixIcon: Icon(Icons.search, size: 18, color: theme.textMutedColor),
          filled: true,
          fillColor: theme.backgroundColor,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
            borderSide: BorderSide(color: theme.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
            borderSide: BorderSide(color: theme.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
            borderSide: BorderSide(color: theme.accentColor),
          ),
        ),
      ),
    );
  }
}

/// A styled dropdown for use in [TableFilterToolbar].
class FilterDropdown<T> extends StatelessWidget {
  /// Current selected value.
  final T? value;

  /// Placeholder text when no value is selected.
  final String hint;

  /// Optional persistent label prefix displayed inside the container (e.g., "Status: ").
  final String? label;

  /// Dropdown items.
  final List<DropdownMenuItem<T>> items;

  /// Callback when selection changes.
  final ValueChanged<T?> onChanged;

  /// Height of the dropdown.
  final double height;

  const FilterDropdown({
    super.key,
    required this.value,
    required this.hint,
    this.label,
    required this.items,
    required this.onChanged,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        border: Border.all(color: theme.borderColor),
        borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Text(
              '$label: ',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: theme.textSecondaryColor,
              ),
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: Text(
                hint,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.textMutedColor,
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: theme.textMutedColor,
              ),
              style: TextStyle(fontSize: 13, color: theme.textPrimaryColor),
              dropdownColor: theme.backgroundColor,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// A styled date range picker for use in [TableFilterToolbar].
class FilterDateRangePicker extends StatelessWidget {
  /// Optional label displayed before the date picker (e.g., "Created Date", "Last Login").
  final String? label;

  /// Start date of the range.
  final DateTime? fromDate;

  /// End date of the range.
  final DateTime? toDate;

  /// Callback when start date changes.
  final ValueChanged<DateTime?> onFromDateChanged;

  /// Callback when end date changes.
  final ValueChanged<DateTime?> onToDateChanged;

  /// Placeholder for start date.
  final String fromPlaceholder;

  /// Placeholder for end date.
  final String toPlaceholder;

  /// First selectable date.
  final DateTime? firstDate;

  /// Last selectable date.
  final DateTime? lastDate;

  /// Height of the picker.
  final double height;

  /// Custom date formatter.
  final String Function(DateTime)? dateFormatter;

  /// Whether to show the time picker alongside the date picker.
  final bool showTimePicker;

  const FilterDateRangePicker({
    super.key,
    this.label,
    this.fromDate,
    this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    this.fromPlaceholder = 'Start date',
    this.toPlaceholder = 'End date',
    this.firstDate,
    this.lastDate,
    this.height = 40,
    this.dateFormatter,
    this.showTimePicker = false,
  });

  String _formatDate(DateTime date) {
    if (dateFormatter != null) return dateFormatter!(date);
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateStr = '${months[date.month - 1]} ${date.day}, ${date.year}';
    if (showTimePicker) {
      final h = date.hour.toString().padLeft(2, '0');
      final m = date.minute.toString().padLeft(2, '0');
      return '$dateStr $h:$m';
    }
    return dateStr;
  }

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);
    final hasDateRange = fromDate != null || toDate != null;

    final datePickerWidget = Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        border: Border.all(
          color: hasDateRange
              ? theme.accentColor.withValues(alpha: 0.5)
              : theme.borderColor,
        ),
        borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
        boxShadow: hasDateRange
            ? [
                BoxShadow(
                  color: theme.accentColor.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Calendar icon
          Container(
            width: 40,
            height: height,
            decoration: BoxDecoration(
              color: hasDateRange
                  ? theme.accentColor.withValues(alpha: 0.1)
                  : theme.headerBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                bottomLeft: Radius.circular(7),
              ),
            ),
            child: Icon(
              Icons.date_range_rounded,
              size: 18,
              color: hasDateRange
                  ? theme.accentColor
                  : theme.textMutedColor,
            ),
          ),

          // From date
          _buildDateCell(
            context: context,
            theme: theme,
            date: fromDate,
            placeholder: fromPlaceholder,
            onTap: () => _showDatePicker(
              context: context,
              theme: theme,
              initialDate: fromDate ?? DateTime.now(),
              firstDate: firstDate ?? DateTime(2020),
              lastDate: toDate ?? lastDate ?? DateTime(2030),
              onDateSelected: onFromDateChanged,
            ),
          ),

          // Separator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: theme.textMutedColor.withValues(alpha: 0.5),
            ),
          ),

          // To date
          _buildDateCell(
            context: context,
            theme: theme,
            date: toDate,
            placeholder: toPlaceholder,
            onTap: () => _showDatePicker(
              context: context,
              theme: theme,
              initialDate: toDate ?? fromDate ?? DateTime.now(),
              firstDate: fromDate ?? firstDate ?? DateTime(2020),
              lastDate: lastDate ?? DateTime(2030),
              onDateSelected: onToDateChanged,
            ),
          ),

          // Clear button
          if (hasDateRange)
            InkWell(
              onTap: () {
                onFromDateChanged(null);
                onToDateChanged(null);
              },
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(7),
                bottomRight: Radius.circular(7),
              ),
              child: Container(
                width: 32,
                height: height,
                decoration: BoxDecoration(
                  color: theme.headerBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: theme.textMutedColor,
                ),
              ),
            )
          else
            const SizedBox(width: 8),
        ],
      ),
    );

    // If no label, return just the date picker
    if (label == null) {
      return datePickerWidget;
    }

    // With label, wrap in a row
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label!,
          style: TextStyle(
            fontSize: 13,
            color: theme.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        datePickerWidget,
      ],
    );
  }

  Widget _buildDateCell({
    required BuildContext context,
    required DataTablePlusTheme theme,
    required DateTime? date,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    final hasDate = date != null;
    final displayText = hasDate ? _formatDate(date) : placeholder;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          child: Text(
            displayText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: hasDate ? FontWeight.w500 : FontWeight.normal,
              color: hasDate
                  ? theme.textPrimaryColor
                  : theme.textMutedColor,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker({
    required BuildContext context,
    required DataTablePlusTheme theme,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required ValueChanged<DateTime?> onDateSelected,
  }) async {
    final brightness = Theme.of(context).brightness;
    final pickerTheme = CustomDatePickerTheme.fromBrightness(brightness).copyWith(
      accentColor: theme.accentColor,
      backgroundColor: theme.backgroundColor,
      textColor: theme.textPrimaryColor,
      mutedColor: theme.textMutedColor,
    );

    final date = await CustomDatePickerDialog.show(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      theme: pickerTheme,
      showTimePicker: showTimePicker,
    );
    if (date != null) {
      onDateSelected(date);
    }
  }
}

/// A compact toggle button for showing/hiding advanced filters.
class FilterAdvancedToggle extends StatefulWidget {
  /// Whether advanced filters are currently shown.
  final bool isExpanded;

  /// Callback when toggle is pressed.
  final VoidCallback onToggle;

  /// Number of active advanced filters (shown as badge).
  final int activeFilterCount;

  /// Animation duration for the arrow rotation.
  final Duration animationDuration;

  const FilterAdvancedToggle({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    this.activeFilterCount = 0,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<FilterAdvancedToggle> createState() => _FilterAdvancedToggleState();
}

class _FilterAdvancedToggleState extends State<FilterAdvancedToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FilterAdvancedToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);
    final hasActiveFilters = widget.activeFilterCount > 0;

    return InkWell(
      onTap: widget.onToggle,
      borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
      child: Container(
        height: 40,
        width: 48,
        decoration: BoxDecoration(
          color: hasActiveFilters
              ? theme.accentColor.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: hasActiveFilters
                ? theme.accentColor.withValues(alpha: 0.5)
                : theme.borderColor,
          ),
          borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list,
                  size: 18,
                  color: hasActiveFilters
                      ? theme.accentColor
                      : theme.textSecondaryColor,
                ),
                const SizedBox(width: 2),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: hasActiveFilters
                        ? theme.accentColor
                        : theme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            // Badge for active filter count
            if (hasActiveFilters)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.activeFilterCount.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
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

/// A compact icon-only reset button for clearing filters.
class FilterResetButton extends StatefulWidget {
  /// Callback when reset is pressed.
  final VoidCallback onReset;

  /// Tooltip text.
  final String tooltip;

  /// Icon to display.
  final IconData icon;

  /// Animation duration for the spin effect.
  final Duration animationDuration;

  const FilterResetButton({
    super.key,
    required this.onReset,
    this.tooltip = 'Reset filters',
    this.icon = Icons.refresh,
    this.animationDuration = const Duration(milliseconds: 400),
  });

  @override
  State<FilterResetButton> createState() => _FilterResetButtonState();
}

class _FilterResetButtonState extends State<FilterResetButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);

    return Tooltip(
      message: widget.tooltip,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            border: Border.all(color: theme.borderColor),
            borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
          ),
          child: Center(
            child: RotationTransition(
              turns: _rotationAnimation,
              child: Icon(
                widget.icon,
                size: 18,
                color: theme.textSecondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A styled clear button for the advanced filters row.
class FilterClearButton extends StatelessWidget {
  /// Callback when clear is pressed.
  final VoidCallback onClear;

  /// Label text for the button.
  final String label;

  const FilterClearButton({
    super.key,
    required this.onClear,
    this.label = 'Clear',
  });

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);

    return TextButton.icon(
      onPressed: onClear,
      icon: Icon(
        Icons.clear,
        size: 14,
        color: theme.textSecondaryColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: theme.textSecondaryColor,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}

/// Quick date preset buttons for common date ranges.
class FilterDatePresets extends StatelessWidget {
  /// Callback when a preset is selected with (fromDate, toDate).
  final void Function(DateTime? from, DateTime? to) onPresetSelected;

  /// Available presets to show.
  final List<DatePreset> presets;

  const FilterDatePresets({
    super.key,
    required this.onPresetSelected,
    this.presets = const [
      DatePreset.today,
      DatePreset.last7Days,
      DatePreset.last30Days,
      DatePreset.thisMonth,
    ],
  });

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);

    return Wrap(
      spacing: 4,
      children: presets.map((preset) {
        return InkWell(
          onTap: () {
            final range = preset.getDateRange();
            onPresetSelected(range.$1, range.$2);
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: theme.headerBackgroundColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: theme.borderColor.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              preset.label,
              style: TextStyle(
                fontSize: 11,
                color: theme.textSecondaryColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Predefined date preset options.
enum DatePreset {
  today('Today'),
  yesterday('Yesterday'),
  last7Days('Last 7 days'),
  last30Days('Last 30 days'),
  thisWeek('This week'),
  thisMonth('This month'),
  lastMonth('Last month'),
  thisYear('This year');

  final String label;
  const DatePreset(this.label);

  /// Returns (fromDate, toDate) for this preset.
  (DateTime?, DateTime?) getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (this) {
      case DatePreset.today:
        return (today, today);
      case DatePreset.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        return (yesterday, yesterday);
      case DatePreset.last7Days:
        return (today.subtract(const Duration(days: 6)), today);
      case DatePreset.last30Days:
        return (today.subtract(const Duration(days: 29)), today);
      case DatePreset.thisWeek:
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        return (startOfWeek, today);
      case DatePreset.thisMonth:
        return (DateTime(now.year, now.month, 1), today);
      case DatePreset.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        final lastDayOfLastMonth = DateTime(now.year, now.month, 0);
        return (lastMonth, lastDayOfLastMonth);
      case DatePreset.thisYear:
        return (DateTime(now.year, 1, 1), today);
    }
  }
}
