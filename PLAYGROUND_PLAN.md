# DataTablePlus Playground Plan

## Layout: Tab Navigation + Content

```
+====================================================================+
|  DataTablePlus Playground                    [Light/Dark Toggle]    |
+====================================================================+
| [Full Demo] [Table] [Badges] [Filters] [Pagination] [Selection]   |
+--------------------------------------------------------------------+
|                                                                    |
|   Content area changes per tab                                     |
|                                                                    |
+--------------------------------------------------------------------+
```

## Tab 1: Full Demo (integrated showcase)

The current example kept as a real-world user management table with all features working together.

```
+--------------------------------------------------------------------+
|  User Management          Total: 300  Filtered: 300  Selected: 0   |
+--------------------------------------------------------------------+
|  [Search...] [Status v] Created [__|__] LastLogin [__|__] [R] [F]  |
|  +-- Advanced: [Role v] [Department v]  Clear                      |
+--------------------------------------------------------------------+
|  [Select All Page (10)]                          [Clear Selection]  |
+--------------------------------------------------------------------+
|  [x] ID       Name      Email    Dept   Role   Status  ...  Act   |
|  [i] desc...  desc...   desc...  ...    ...    ...     ...  ...   |
+--------------------------------------------------------------------+
|  [ ] USR001   James S.  james@.. Eng    Admin  Active  ...  V E D |
|  ...                                                               |
+--------------------------------------------------------------------+
|  Showing 1-10 of 300 users        [10/page v]  [< 1 2 3 4 5 >]   |
+--------------------------------------------------------------------+
```

## Tab 2: Table Options (interactive toggles)

```
+--------------------------------------------------------------------+
|  OPTIONS PANEL                    |  LIVE PREVIEW                  |
|  ================================|  ==============================|
|  [x] Show checkboxes             |  [x] ID   Name    Email  Act  |
|  [x] Show action column          |  [i] uid  name..  email..     |
|  [x] Show column info            |  [ ] 001  James   ja@e.. V E  |
|  [x] Use custom header builder   |  [ ] 002  Mary    ma@e.. V E  |
|  [x] Use TextCellBuilder         |                                |
|  [ ] Show empty state            |                                |
|  Rows: [5 v]                     |                                |
+--------------------------------------------------------------------+
```

Demonstrates:
- `DataTablePlus` with toggleable options
- `ColumnDefinition` with all properties
- `TextCellBuilder.text()` and `TextCellBuilder.monospace()`
- Custom `headerBuilder`
- Custom `cellStyle`
- Empty state widget

## Tab 3: Badges (all variants)

```
+--------------------------------------------------------------------+
|  StatusBadge                        CountBadge                     |
|  ================================   ==============                 |
|  [Active]  .success()               (3)  default                  |
|  [Pending] .warning()               (12) custom color             |
|  [Error]   .danger()                (99) custom bg                |
|  [Info]    .info()                                                |
|  [Muted]   .neutral()                                            |
|                                                                    |
|  Custom StatusBadge                                               |
|  [Custom] with manual colors                                      |
+--------------------------------------------------------------------+
```

Demonstrates:
- `StatusBadge.success()`, `.warning()`, `.danger()`, `.info()`, `.neutral()`
- `StatusBadge` with custom colors
- `CountBadge` with default and custom colors

## Tab 4: Filters (all filter widgets)

```
+--------------------------------------------------------------------+
|  FilterSearchField                                                 |
|  [Search users, emails, IDs...]                                    |
|                                                                    |
|  FilterDropdown                                                    |
|  [Status v]  [Role v]  [Department v]                             |
|                                                                    |
|  FilterDateRangePicker                                            |
|  Created [Jan 1, 2024 -> Dec 31, 2024]  [x]                      |
|                                                                    |
|  FilterDatePresets                                                |
|  [Today] [Last 7 days] [Last 30 days] [This month]               |
|  [Yesterday] [This week] [Last month] [This year]                 |
|                                                                    |
|  FilterAdvancedToggle    FilterResetButton    FilterClearButton    |
|  [F v] (with badge)     [Spin icon]          [x Clear]            |
+--------------------------------------------------------------------+
```

Demonstrates:
- `FilterSearchField`
- `FilterDropdown`
- `FilterDateRangePicker` (with and without label)
- `FilterDatePresets` (all 8 presets)
- `FilterAdvancedToggle` (with active filter badge)
- `FilterResetButton` (with spin animation)
- `FilterClearButton`

## Tab 5: Pagination (adjustable)

```
+--------------------------------------------------------------------+
|  OPTIONS                          |  LIVE PREVIEW                  |
|  ================================|  ==============================|
|  Total items: [___300___]        |                                |
|  Page size options: 10,20,50,100 |  Showing 1-10 of 300 items    |
|  Template: [{start}-{end}/{total}]| [10/page v] [< 1 2 3 4 5 >]  |
|  Max visible pages: [5 v]        |                                |
+--------------------------------------------------------------------+
```

Demonstrates:
- `TablePagination` with customizable properties
- `currentPage`, `totalPages`, `totalItems`, `pageSize`
- `pageSizeOptions`, `maxVisiblePages`
- Custom `itemRangeTemplate` and `pageSizeTemplate`

## Tab 6: Selection Bar (adjustable)

```
+--------------------------------------------------------------------+
|  OPTIONS                          |  LIVE PREVIEW                  |
|  ================================|  ==============================|
|  Selected count: [___3___]       |  v 3 selected                  |
|  Page item count: [___10___]     |  [Select All Page (10)] Clear  |
|  [x] All page selected           |                                |
|  [x] Always visible              |                                |
|  Template: [{count} items sel.]  |                                |
+--------------------------------------------------------------------+
```

Demonstrates:
- `TableSelectionBar` with adjustable properties
- `selectedCount`, `pageItemCount`, `allPageSelected`
- `alwaysVisible` toggle
- Custom `selectedCountTemplate`

## Features Showcased Per Tab

| Tab | Widgets Demonstrated |
|-----|---------------------|
| Full Demo | `DataTablePlus`, `TablePagination`, `TableFilterToolbar`, `TableSelectionBar`, all filter widgets, `StatusBadge`, column info, actions, themes |
| Table | `DataTablePlus`, `ColumnDefinition`, `TextCellBuilder.text()`, `TextCellBuilder.monospace()`, `headerBuilder`, `cellStyle`, empty state |
| Badges | `StatusBadge` (5 factories + custom), `CountBadge` |
| Filters | `FilterSearchField`, `FilterDropdown`, `FilterDateRangePicker`, `FilterDatePresets`, `FilterAdvancedToggle`, `FilterResetButton`, `FilterClearButton` |
| Pagination | `TablePagination` with customizable props |
| Selection | `TableSelectionBar` with adjustable props |

## Theme Switcher (global, in AppBar)

Available theme presets:
- **Light** (default)
- **Dark**
- **Blue**
- **Green**
- **Purple**

The theme switcher is accessible from the AppBar and affects all tabs globally.

## Files to Change

| File | Action |
|------|--------|
| `example/lib/main.dart` | Rewrite as playground app |
