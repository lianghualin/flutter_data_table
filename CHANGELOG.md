## 0.2.0

- `TableContextualBar` — toolbar container that swaps between a custom normal toolbar and a contextual action bar based on selection state
  - Uses `Stack` + `AnimatedOpacity` for zero-shift crossfade (no layout jump)
  - Fully customizable `normalToolbar` slot, `selectAllWidget`, and trailing `actions`
- Updated playground: new "Context Bar" tab, Full Demo now uses `TableContextualBar`

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
