import 'package:flutter/material.dart';
import '../theme/table_theme.dart';

/// A selection action bar for DataTablePlus.
///
/// Displays the current selection count and provides buttons to
/// select all items on the current page or clear the selection.
class TableSelectionBar extends StatelessWidget {
  /// Number of currently selected items.
  final int selectedCount;

  /// Total number of items on the current page.
  final int pageItemCount;

  /// Whether all items on the current page are selected.
  final bool allPageSelected;

  /// Callback to select all items on the current page.
  final VoidCallback? onSelectAllPage;

  /// Callback to clear the entire selection.
  final VoidCallback? onClearSelection;

  /// Text template for the selected count. Use {count} placeholder.
  final String selectedCountTemplate;

  /// Label for the select-all-page button.
  final String selectAllLabel;

  /// Label shown when all page items are already selected.
  final String deselectAllLabel;

  /// Label for the clear selection button.
  final String clearLabel;

  /// Whether to always show the bar, or only when items are selected.
  final bool alwaysVisible;

  /// Duration of the show/hide animation.
  final Duration animationDuration;

  const TableSelectionBar({
    super.key,
    required this.selectedCount,
    required this.pageItemCount,
    this.allPageSelected = false,
    this.onSelectAllPage,
    this.onClearSelection,
    this.selectedCountTemplate = '{count} selected',
    this.selectAllLabel = 'Select All Page',
    this.deselectAllLabel = 'Deselect All Page',
    this.clearLabel = 'Clear Selection',
    this.alwaysVisible = false,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);
    final isVisible = alwaysVisible || selectedCount > 0;

    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: _buildBar(theme),
      crossFadeState:
          isVisible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: animationDuration,
    );
  }

  Widget _buildBar(DataTablePlusTheme theme) {
    final countText =
        selectedCountTemplate.replaceAll('{count}', selectedCount.toString());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.accentColor.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(
            color: theme.accentColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // Checkmark icon + selected count
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: theme.accentColor,
          ),
          const SizedBox(width: 8),
          Text(
            countText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.accentColor,
            ),
          ),
          const SizedBox(width: 16),

          // Select All Page / Deselect All Page button
          if (onSelectAllPage != null)
            _SelectAllPageButton(
              allPageSelected: allPageSelected,
              pageItemCount: pageItemCount,
              selectAllLabel: selectAllLabel,
              deselectAllLabel: deselectAllLabel,
              onPressed: onSelectAllPage!,
              theme: theme,
            ),

          const Spacer(),

          // Clear Selection button
          if (onClearSelection != null && selectedCount > 0)
            _ClearSelectionButton(
              label: clearLabel,
              onPressed: onClearSelection!,
              theme: theme,
            ),
        ],
      ),
    );
  }
}

class _SelectAllPageButton extends StatelessWidget {
  final bool allPageSelected;
  final int pageItemCount;
  final String selectAllLabel;
  final String deselectAllLabel;
  final VoidCallback onPressed;
  final DataTablePlusTheme theme;

  const _SelectAllPageButton({
    required this.allPageSelected,
    required this.pageItemCount,
    required this.selectAllLabel,
    required this.deselectAllLabel,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final label = allPageSelected
        ? deselectAllLabel
        : '$selectAllLabel ($pageItemCount)';

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        allPageSelected ? Icons.deselect : Icons.select_all,
        size: 16,
      ),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.accentColor,
        side: BorderSide(color: theme.accentColor.withValues(alpha: 0.4)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
        ),
      ),
    );
  }
}

class _ClearSelectionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final DataTablePlusTheme theme;

  const _ClearSelectionButton({
    required this.label,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.clear, size: 14, color: theme.textSecondaryColor),
      label: Text(
        label,
        style: TextStyle(fontSize: 12, color: theme.textSecondaryColor),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: Size.zero,
      ),
    );
  }
}
