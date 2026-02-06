import 'package:flutter/material.dart';

/// Defines a column in the DataTablePlus widget.
class ColumnDefinition<T> {
  /// The header label for this column.
  final String label;

  /// The flex value for this column's width.
  final int flex;

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
    this.headerBuilder,
    this.cellStyle,
    this.description,
    this.sortable = false,
    this.sortComparator,
  });
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
