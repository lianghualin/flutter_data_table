import 'package:flutter/material.dart';
import '../theme/table_theme.dart';

/// Pagination controls for DataTablePlus.
class TablePagination extends StatelessWidget {
  /// Current page number (1-indexed).
  final int currentPage;

  /// Total number of pages.
  final int totalPages;

  /// Total number of items.
  final int totalItems;

  /// Number of items per page.
  final int pageSize;

  /// Callback when page changes.
  final void Function(int page)? onPageChanged;

  /// Available page size options for the dropdown.
  final List<int> pageSizeOptions;

  /// Callback when page size changes.
  final void Function(int pageSize) onPageSizeChanged;

  /// Maximum number of page buttons to show.
  final int maxVisiblePages;

  /// Text template for showing item range. Use {start}, {end}, {total} placeholders.
  final String itemRangeTemplate;

  /// Text template for page size selector. Use {size} placeholder.
  final String pageSizeTemplate;

  const TablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.pageSizeOptions,
    required this.onPageSizeChanged,
    this.onPageChanged,
    this.maxVisiblePages = 5,
    this.itemRangeTemplate = '显示 {start}-{end} 条，共 {total} 条',
    this.pageSizeTemplate = '{size}/page',
  });

  @override
  Widget build(BuildContext context) {
    final theme = DataTablePlusThemeProvider.of(context);

    final startItem = totalItems == 0 ? 0 : (currentPage - 1) * pageSize + 1;
    final endItem = (currentPage * pageSize).clamp(0, totalItems);

    final rangeText = itemRangeTemplate
        .replaceAll('{start}', startItem.toString())
        .replaceAll('{end}', endItem.toString())
        .replaceAll('{total}', totalItems.toString());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.borderColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rangeText,
            style: TextStyle(
              fontSize: 13,
              color: theme.textSecondaryColor,
            ),
          ),
          Row(
            children: [
              _PageSizeSelector(
                pageSize: pageSize,
                options: pageSizeOptions,
                onChanged: onPageSizeChanged,
                template: pageSizeTemplate,
                theme: theme,
              ),
              const SizedBox(width: 16),
              _PageButton(
                icon: Icons.chevron_left,
                onPressed: currentPage > 1
                    ? () => onPageChanged?.call(currentPage - 1)
                    : null,
                theme: theme,
              ),
              const SizedBox(width: 8),
              ..._buildPageNumbers(theme),
              const SizedBox(width: 8),
              _PageButton(
                icon: Icons.chevron_right,
                onPressed: currentPage < totalPages
                    ? () => onPageChanged?.call(currentPage + 1)
                    : null,
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(DataTablePlusTheme theme) {
    final pages = <Widget>[];
    final visiblePages = totalPages.clamp(0, maxVisiblePages);

    int startPage = 1;
    if (totalPages > maxVisiblePages) {
      startPage = (currentPage - maxVisiblePages ~/ 2).clamp(1, totalPages - maxVisiblePages + 1);
    }

    for (int i = 0; i < visiblePages; i++) {
      final page = startPage + i;
      pages.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: _PageNumberButton(
            page: page,
            isActive: page == currentPage,
            onPressed: () => onPageChanged?.call(page),
            theme: theme,
          ),
        ),
      );
    }

    return pages;
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final DataTablePlusTheme theme;

  const _PageButton({
    required this.icon,
    this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide(color: theme.borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
          ),
          foregroundColor: theme.textSecondaryColor,
          disabledForegroundColor: theme.textMutedColor,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onPressed;
  final DataTablePlusTheme theme;

  const _PageNumberButton({
    required this.page,
    required this.isActive,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: isActive
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: theme.accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
                ),
              ),
              child: Text(
                page.toString(),
                style: const TextStyle(fontSize: 13),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: BorderSide(color: theme.borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
                ),
                foregroundColor: theme.textSecondaryColor,
              ),
              child: Text(
                page.toString(),
                style: const TextStyle(fontSize: 13),
              ),
            ),
    );
  }
}

class _PageSizeSelector extends StatelessWidget {
  final int pageSize;
  final List<int> options;
  final void Function(int) onChanged;
  final String template;
  final DataTablePlusTheme theme;

  const _PageSizeSelector({
    required this.pageSize,
    required this.options,
    required this.onChanged,
    required this.template,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.borderColor),
        borderRadius: BorderRadius.circular(theme.borderRadiusSmall),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: pageSize,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: theme.textSecondaryColor,
          ),
          style: TextStyle(
            fontSize: 13,
            color: theme.textSecondaryColor,
          ),
          dropdownColor: theme.backgroundColor,
          items: options.map((size) {
            return DropdownMenuItem<int>(
              value: size,
              child: Text(
                template.replaceAll('{size}', size.toString()),
                style: TextStyle(
                  fontSize: 13,
                  color: theme.textSecondaryColor,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}
