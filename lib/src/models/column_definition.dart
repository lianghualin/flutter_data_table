import 'package:flutter/material.dart';

/// Defines the sizing mode for a table column.
sealed class ColumnSize {
  const ColumnSize();

  /// Column automatically sizes to fit its widest content.
  const factory ColumnSize.auto() = ColumnSizeAuto;

  /// Column takes proportional remaining space. Default flex is 1.
  const factory ColumnSize.flex([int flex]) = ColumnSizeFlex;

  /// Column has an exact pixel width.
  const factory ColumnSize.fixed(double width) = ColumnSizeFixed;
}

/// Sizes the column to fit the widest cell content.
class ColumnSizeAuto extends ColumnSize {
  const ColumnSizeAuto();
}

/// Sizes the column proportionally using remaining space.
class ColumnSizeFlex extends ColumnSize {
  final int flex;
  const ColumnSizeFlex([this.flex = 1]);
}

/// Sizes the column to an exact pixel width.
class ColumnSizeFixed extends ColumnSize {
  final double width;
  const ColumnSizeFixed(this.width);
}

/// Defines a column in the DataTablePlus widget.
class ColumnDefinition<T> {
  /// The header label for this column.
  final String label;

  /// The flex value for this column's width (shorthand for [ColumnSize.flex]).
  /// Ignored when [size] is provided.
  final int flex;

  /// Column sizing mode. When provided, overrides [flex].
  final ColumnSize? _explicitSize;

  /// Effective column size — uses [_explicitSize] if set, otherwise [ColumnSize.flex(flex)].
  ColumnSize get size => _explicitSize ?? ColumnSizeFlex(flex);

  /// Builder function to create the cell widget for this column.
  final Widget Function(T item) cellBuilder;

  /// Optional custom header widget builder.
  final Widget Function(String label)? headerBuilder;

  /// Optional text style for cells in this column.
  final TextStyle? cellStyle;

  /// Optional description explaining what this column's data represents.
  final String? description;

  /// Whether this column is sortable.
  final bool sortable;

  /// Sort comparator for this column.
  final int Function(T a, T b)? sortComparator;

  const ColumnDefinition({
    required this.label,
    required this.cellBuilder,
    this.flex = 1,
    ColumnSize? size,
    this.headerBuilder,
    this.cellStyle,
    this.description,
    this.sortable = false,
    this.sortComparator,
  }) : _explicitSize = size;
}

/// Predefined cell builder for text cells.
class TextCellBuilder {
  /// Creates a simple text cell.
  static Widget Function(T) text<T>(
    String Function(T item) getText, {
    TextStyle? style,
    TextOverflow overflow = TextOverflow.ellipsis,
    int? maxLines,
  }) {
    return (T item) => Text(
          getText(item),
          style: style,
          overflow: overflow,
          maxLines: maxLines,
        );
  }

  /// Creates a monospace text cell (useful for codes, IDs, MAC addresses).
  static Widget Function(T) monospace<T>(
    String Function(T item) getText, {
    Color? color,
  }) {
    return (T item) => Text(
          getText(item),
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'monospace',
            color: color ?? const Color(0xFF1F2937),
          ),
          overflow: TextOverflow.ellipsis,
        );
  }
}
