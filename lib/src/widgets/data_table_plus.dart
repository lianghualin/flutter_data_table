import 'package:flutter/material.dart';
import '../models/column_definition.dart';
import '../theme/table_theme.dart';

/// A customizable data table widget with selection, pagination support.
class DataTablePlus<T> extends StatelessWidget {
  /// The list of items to display.
  final List<T> items;

  /// Column definitions for the table.
  final List<ColumnDefinition<T>> columns;

  /// Function to get unique ID for each item.
  final String Function(T item) idGetter;

  /// Set of selected item IDs.
  final Set<String> selectedIds;

  /// Callback when an item's selection is toggled.
  final void Function(String id)? onSelectionChanged;

  /// Callback when select all is toggled.
  final void Function()? onSelectAllChanged;

  /// Whether to show checkboxes for selection.
  final bool showCheckboxes;

  /// Whether all visible items are selected.
  final bool allSelected;

  /// Widget to show when there are no items.
  final Widget? emptyWidget;

  /// Optional action column builder.
  final Widget Function(T item)? actionBuilder;

  /// Action column label.
  final String actionLabel;

  /// Action column flex.
  final int actionFlex;

  /// Whether to show the column info/description row below the header.
  final bool showColumnInfo;

  /// Callback when the column info toggle button is pressed.
  /// If null, the info toggle button is not shown in the header.
  final VoidCallback? onToggleColumnInfo;

  const DataTablePlus({
    super.key,
    required this.items,
    required this.columns,
    required this.idGetter,
    this.selectedIds = const {},
    this.onSelectionChanged,
    this.onSelectAllChanged,
    this.showCheckboxes = true,
    this.allSelected = false,
    this.emptyWidget,
    this.actionBuilder,
    this.actionLabel = '操作',
    this.actionFlex = 1,
    this.showColumnInfo = false,
    this.onToggleColumnInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);

    final hasDescriptions = columns.any((col) => col.description != null);

    return Column(
      children: [
        // Header
        _TableHeader<T>(
          columns: columns,
          showCheckboxes: showCheckboxes,
          allSelected: allSelected,
          onSelectAllChanged: onSelectAllChanged,
          theme: theme,
          showActions: actionBuilder != null,
          actionLabel: actionLabel,
          actionFlex: actionFlex,
          showInfoToggle: hasDescriptions && onToggleColumnInfo != null,
          isInfoExpanded: showColumnInfo,
          onToggleInfo: onToggleColumnInfo,
        ),
        // Column info row
        if (hasDescriptions)
          _TableColumnInfoRow<T>(
            columns: columns,
            showCheckboxes: showCheckboxes,
            showActions: actionBuilder != null,
            actionFlex: actionFlex,
            isVisible: showColumnInfo,
            theme: theme,
          ),
        // Body
        if (items.isEmpty)
          emptyWidget ?? _DefaultEmptyWidget(theme: theme)
        else
          ...items.map(
            (item) => _TableRow<T>(
              item: item,
              columns: columns,
              isSelected: selectedIds.contains(idGetter(item)),
              showCheckboxes: showCheckboxes,
              onToggle: onSelectionChanged != null
                  ? () => onSelectionChanged!(idGetter(item))
                  : null,
              theme: theme,
              actionBuilder: actionBuilder,
              actionFlex: actionFlex,
            ),
          ),
      ],
    );
  }
}

class _TableHeader<T> extends StatelessWidget {
  final List<ColumnDefinition<T>> columns;
  final bool showCheckboxes;
  final bool allSelected;
  final VoidCallback? onSelectAllChanged;
  final DataTablePlusTheme theme;
  final bool showActions;
  final String actionLabel;
  final int actionFlex;
  final bool showInfoToggle;
  final bool isInfoExpanded;
  final VoidCallback? onToggleInfo;

  const _TableHeader({
    required this.columns,
    required this.showCheckboxes,
    required this.allSelected,
    required this.onSelectAllChanged,
    required this.theme,
    required this.showActions,
    required this.actionLabel,
    required this.actionFlex,
    this.showInfoToggle = false,
    this.isInfoExpanded = false,
    this.onToggleInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: theme.headerPadding,
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        border: Border(
          bottom: BorderSide(color: theme.borderColor),
        ),
      ),
      child: Row(
        children: [
          if (showCheckboxes)
            SizedBox(
              width: 40,
              child: Checkbox(
                value: allSelected,
                onChanged: onSelectAllChanged != null
                    ? (_) => onSelectAllChanged!()
                    : null,
                activeColor: theme.accentColor,
                side: BorderSide(color: theme.borderColor),
              ),
            ),
          ...columns.map(
            (col) => Expanded(
              flex: col.flex,
              child: col.headerBuilder != null
                  ? col.headerBuilder!(col.label)
                  : Text(col.label, style: theme.getHeaderTextStyle()),
            ),
          ),
          if (showActions)
            Expanded(
              flex: actionFlex,
              child: Text(actionLabel, style: theme.getHeaderTextStyle()),
            ),
          if (showInfoToggle)
            SizedBox(
              width: 28,
              height: 28,
              child: IconButton(
                onPressed: onToggleInfo,
                padding: EdgeInsets.zero,
                icon: Icon(
                  isInfoExpanded
                      ? Icons.info
                      : Icons.info_outline,
                  size: 18,
                  color: isInfoExpanded
                      ? theme.accentColor
                      : theme.textMutedColor,
                ),
                tooltip: isInfoExpanded
                    ? 'Hide column info'
                    : 'Show column info',
              ),
            ),
        ],
      ),
    );
  }
}

class _TableRow<T> extends StatelessWidget {
  final T item;
  final List<ColumnDefinition<T>> columns;
  final bool isSelected;
  final bool showCheckboxes;
  final VoidCallback? onToggle;
  final DataTablePlusTheme theme;
  final Widget Function(T item)? actionBuilder;
  final int actionFlex;

  const _TableRow({
    required this.item,
    required this.columns,
    required this.isSelected,
    required this.showCheckboxes,
    required this.onToggle,
    required this.theme,
    required this.actionBuilder,
    required this.actionFlex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: theme.cellPadding,
      decoration: BoxDecoration(
        color: isSelected ? theme.accentLightColor : theme.backgroundColor,
        border: Border(
          left: isSelected
              ? BorderSide(color: theme.accentColor, width: 3)
              : const BorderSide(color: Colors.transparent, width: 3),
          bottom: BorderSide(
            color: isSelected
                ? theme.accentColor.withValues(alpha: 0.2)
                : theme.borderLightColor,
          ),
        ),
      ),
      child: Row(
        children: [
          if (showCheckboxes)
            SizedBox(
              width: 40,
              child: Checkbox(
                value: isSelected,
                onChanged: onToggle != null ? (_) => onToggle!() : null,
                activeColor: theme.accentColor,
                side: BorderSide(color: theme.borderColor),
              ),
            ),
          ...columns.map(
            (col) => Expanded(
              flex: col.flex,
              child: DefaultTextStyle(
                style: col.cellStyle ?? theme.getCellTextStyle(),
                child: col.cellBuilder(item),
              ),
            ),
          ),
          if (actionBuilder != null)
            Expanded(
              flex: actionFlex,
              child: actionBuilder!(item),
            ),
        ],
      ),
    );
  }
}

class _TableColumnInfoRow<T> extends StatelessWidget {
  final List<ColumnDefinition<T>> columns;
  final bool showCheckboxes;
  final bool showActions;
  final int actionFlex;
  final bool isVisible;
  final DataTablePlusTheme theme;

  const _TableColumnInfoRow({
    required this.columns,
    required this.showCheckboxes,
    required this.showActions,
    required this.actionFlex,
    required this.isVisible,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.accentColor.withValues(alpha: 0.05),
          border: Border(
            bottom: BorderSide(
              color: theme.accentColor.withValues(alpha: 0.15),
            ),
          ),
        ),
        child: Row(
          children: [
            if (showCheckboxes) const SizedBox(width: 40),
            ...columns.map(
              (col) => Expanded(
                flex: col.flex,
                child: Text(
                  col.description ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: theme.textMutedColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (showActions)
              Expanded(flex: actionFlex, child: const SizedBox.shrink()),
          ],
        ),
      ),
      crossFadeState:
          isVisible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }
}

class _DefaultEmptyWidget extends StatelessWidget {
  final DataTablePlusTheme theme;

  const _DefaultEmptyWidget({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: theme.textMutedColor,
            ),
            const SizedBox(height: 12),
            Text(
              'No data available',
              style: TextStyle(
                fontSize: 14,
                color: theme.textMutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
