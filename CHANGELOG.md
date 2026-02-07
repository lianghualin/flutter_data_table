## 0.1.0

- Initial release
- `DataTablePlus<T>` — generic data table with flex columns, row selection, action column, column info/description row
- `ColumnDefinition<T>` — column config with label, flex, cellBuilder, headerBuilder, cellStyle, description
- `TextCellBuilder` — predefined cell builders (`.text()`, `.monospace()`)
- `TablePagination` — page controls with size selector, page numbers, customizable templates
- `TableSelectionBar` — animated selection bar with select all page / clear selection
- `TableFilterToolbar` — two-row filter layout with collapsible advanced filters
- `FilterSearchField`, `FilterDropdown<T>`, `FilterDateRangePicker`, `FilterDatePresets`
- `FilterAdvancedToggle`, `FilterResetButton`, `FilterClearButton`
- `StatusBadge` — pill badge with 5 semantic factories (success, warning, danger, info, neutral)
- `CountBadge` — small numeric badge
- `DataTablePlusTheme` + `DataTablePlusThemeProvider` — full theming via InheritedWidget
