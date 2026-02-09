import 'package:flutter/material.dart';
import '../theme/table_theme.dart';

/// A toolbar container that animates between a normal toolbar and a contextual
/// action bar based on selection state.
///
/// When [selectedCount] is 0, shows [normalToolbar].
/// When [selectedCount] > 0, slides in a contextual bar with selection count,
/// optional select-all widget, and trailing action buttons.
///
/// ```dart
/// TableContextualBar(
///   selectedCount: _selectedIds.length,
///   normalToolbar: Row(children: [AddButton(), Spacer(), SearchField()]),
///   selectedCountTemplate: '{count} selected',
///   selectAllWidget: TextButton(onPressed: _toggleAll, child: Text('Select All')),
///   actions: [
///     IconButton(icon: Icon(Icons.delete), onPressed: _deleteSelected),
///   ],
/// )
/// ```
class TableContextualBar extends StatelessWidget {
  /// Number of currently selected items. When 0, [normalToolbar] is shown.
  final int selectedCount;

  /// The widget to display when nothing is selected (state 1).
  final Widget normalToolbar;

  /// Text template for selected count. Use {count} as placeholder.
  final String selectedCountTemplate;

  /// Optional widget placed after the selection count (e.g., "Select All" button).
  final Widget? selectAllWidget;

  /// Action widgets displayed at the trailing end of the contextual bar
  /// (e.g., Delete button, Export button).
  final List<Widget> actions;

  /// Duration of the crossfade animation between states.
  final Duration animationDuration;

  /// Padding for the contextual bar.
  final EdgeInsets? contextualBarPadding;

  /// Padding for the normal toolbar wrapper.
  /// If null, the [normalToolbar] is rendered without additional padding.
  final EdgeInsets? normalToolbarPadding;

  const TableContextualBar({
    super.key,
    required this.selectedCount,
    required this.normalToolbar,
    this.selectedCountTemplate = '{count} selected',
    this.selectAllWidget,
    this.actions = const [],
    this.animationDuration = const Duration(milliseconds: 200),
    this.contextualBarPadding,
    this.normalToolbarPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);
    final isSelecting = selectedCount > 0;

    // Use Stack + AnimatedOpacity instead of AnimatedCrossFade.
    // AnimatedCrossFade animates both opacity AND size, which causes the
    // table below to shift when the two toolbars have different heights.
    // Stack keeps both children rendered (sized to the larger one) and
    // only animates opacity — zero layout shift.
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: isSelecting ? 0.0 : 1.0,
          duration: animationDuration,
          curve: Curves.easeOut,
          child: IgnorePointer(
            ignoring: isSelecting,
            child: _buildNormalToolbar(theme),
          ),
        ),
        AnimatedOpacity(
          opacity: isSelecting ? 1.0 : 0.0,
          duration: animationDuration,
          curve: Curves.easeOut,
          child: IgnorePointer(
            ignoring: !isSelecting,
            child: _buildContextualBar(theme),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalToolbar(DataTablePlusTheme theme) {
    if (normalToolbarPadding != null) {
      return Container(
        padding: normalToolbarPadding,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.borderLightColor),
          ),
        ),
        child: normalToolbar,
      );
    }
    return normalToolbar;
  }

  Widget _buildContextualBar(DataTablePlusTheme theme) {
    final countText =
        selectedCountTemplate.replaceAll('{count}', selectedCount.toString());

    return Container(
      padding: contextualBarPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.accentLightColor,
        border: Border(
          bottom: BorderSide(
            color: theme.accentColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          // Checkmark badge
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.accentColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 10),

          // Selected count text
          Text(
            countText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: theme.accentColor,
            ),
          ),

          // Select all widget
          if (selectAllWidget != null) ...[
            const SizedBox(width: 12),
            selectAllWidget!,
          ],

          const Spacer(),

          // Trailing actions
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: action,
            ),
          ),
        ],
      ),
    );
  }
}
