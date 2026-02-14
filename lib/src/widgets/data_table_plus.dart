import 'package:flutter/material.dart';
import '../models/column_definition.dart';
import '../theme/table_theme.dart';

/// A customizable data table widget with selection, pagination support.
///
/// Columns support three sizing modes via [ColumnSize]:
/// - [ColumnSize.flex] — proportional (default, same as the old `flex` param)
/// - [ColumnSize.auto] — shrinks to fit the widest cell content
/// - [ColumnSize.fixed] — exact pixel width
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
    final showInfoToggle = hasDescriptions && onToggleColumnInfo != null;

    return Column(
      children: [
        Table(
          columnWidths: _columnWidths(showInfoToggle),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _headerRow(theme, showInfoToggle),
            if (hasDescriptions && showColumnInfo)
              _infoRow(theme, showInfoToggle),
            if (items.isNotEmpty)
              ...items.map((item) => _dataRow(item, theme, showInfoToggle)),
          ],
        ),
        if (items.isEmpty) emptyWidget ?? _DefaultEmptyWidget(theme: theme),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Column widths
  // ---------------------------------------------------------------------------

  Map<int, TableColumnWidth> _columnWidths(bool showInfoToggle) {
    final map = <int, TableColumnWidth>{};
    int i = 0;

    if (showCheckboxes) {
      map[i++] = const FixedColumnWidth(56);
    }

    for (final col in columns) {
      map[i++] = switch (col.size) {
        ColumnSizeAuto() => const IntrinsicColumnWidth(),
        ColumnSizeFlex(:final flex) => FlexColumnWidth(flex.toDouble()),
        ColumnSizeFixed(:final width) => FixedColumnWidth(width),
      };
    }

    if (actionBuilder != null) {
      map[i++] = FlexColumnWidth(actionFlex.toDouble());
    }

    if (showInfoToggle) {
      map[i++] = const FixedColumnWidth(44);
    }

    return map;
  }

  // ---------------------------------------------------------------------------
  // Cell padding helper
  // ---------------------------------------------------------------------------

  /// Wraps [cells] with consistent padding.
  /// First cell gets left edge padding, last cell gets right edge padding,
  /// in-between cells get [gap] on their left side.
  List<Widget> _padCells(
    List<Widget> cells,
    EdgeInsets outer, {
    double gap = 12,
  }) {
    return List.generate(cells.length, (i) {
      return Padding(
        padding: EdgeInsets.only(
          left: i == 0 ? outer.left : gap,
          right: i == cells.length - 1 ? outer.right : 0,
          top: outer.top,
          bottom: outer.bottom,
        ),
        child: cells[i],
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Header row
  // ---------------------------------------------------------------------------

  TableRow _headerRow(DataTablePlusTheme theme, bool showInfoToggle) {
    final cells = <Widget>[
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
      ...columns.map((col) => col.headerBuilder != null
          ? col.headerBuilder!(col.label)
          : Text(col.label, style: theme.getHeaderTextStyle())),
      if (actionBuilder != null)
        Text(actionLabel, style: theme.getHeaderTextStyle()),
      if (showInfoToggle)
        SizedBox(
          width: 28,
          height: 28,
          child: IconButton(
            onPressed: onToggleColumnInfo,
            padding: EdgeInsets.zero,
            icon: Icon(
              showColumnInfo ? Icons.info : Icons.info_outline,
              size: 18,
              color: showColumnInfo ? theme.accentColor : theme.textMutedColor,
            ),
            tooltip:
                showColumnInfo ? 'Hide column info' : 'Show column info',
          ),
        ),
    ];

    return TableRow(
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        border: Border(bottom: BorderSide(color: theme.borderColor)),
      ),
      children: _padCells(cells, theme.headerPadding),
    );
  }

  // ---------------------------------------------------------------------------
  // Column info row
  // ---------------------------------------------------------------------------

  TableRow _infoRow(DataTablePlusTheme theme, bool showInfoToggle) {
    final cells = <Widget>[
      if (showCheckboxes) const SizedBox.shrink(),
      ...columns.map((col) => Text(
            col.description ?? '',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: theme.textMutedColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
      if (actionBuilder != null) const SizedBox.shrink(),
      if (showInfoToggle) const SizedBox.shrink(),
    ];

    return TableRow(
      decoration: BoxDecoration(
        color: theme.accentColor.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: theme.accentColor.withValues(alpha: 0.15),
          ),
        ),
      ),
      children: _padCells(
        cells,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Data rows
  // ---------------------------------------------------------------------------

  TableRow _dataRow(T item, DataTablePlusTheme theme, bool showInfoToggle) {
    final isSelected = selectedIds.contains(idGetter(item));

    final cells = <Widget>[
      if (showCheckboxes)
        SizedBox(
          width: 40,
          child: Checkbox(
            value: isSelected,
            onChanged: onSelectionChanged != null
                ? (_) => onSelectionChanged!(idGetter(item))
                : null,
            activeColor: theme.accentColor,
            side: BorderSide(color: theme.borderColor),
          ),
        ),
      ...columns.map((col) => DefaultTextStyle(
            style: col.cellStyle ?? theme.getCellTextStyle(),
            child: col.cellBuilder(item),
          )),
      if (actionBuilder != null) actionBuilder!(item),
      if (showInfoToggle) const SizedBox.shrink(),
    ];

    return TableRow(
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
      children: _padCells(cells, theme.cellPadding),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

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
