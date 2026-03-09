import 'package:flutter/material.dart';
import 'package:composable_data_table/composable_data_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DataTablePlus Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const PlaygroundPage(),
    );
  }
}

// =============================================================================
// THEME PRESETS
// =============================================================================

enum ThemePreset { light, dark, blue, green, purple }

DataTablePlusTheme getThemePreset(ThemePreset preset) {
  switch (preset) {
    case ThemePreset.light:
      return DataTablePlusTheme.defaultTheme;
    case ThemePreset.dark:
      return const DataTablePlusTheme(
        backgroundColor: Color(0xFF1E1E1E),
        headerBackgroundColor: Color(0xFF2D2D2D),
        borderColor: Color(0xFF404040),
        borderLightColor: Color(0xFF333333),
        textPrimaryColor: Color(0xFFE0E0E0),
        textSecondaryColor: Color(0xFFB0B0B0),
        textMutedColor: Color(0xFF808080),
        accentColor: Color(0xFF64B5F6),
        accentLightColor: Color(0xFF1E3A5F),
        successColor: Color(0xFF81C784),
        successLightColor: Color(0xFF1B3D1B),
        warningColor: Color(0xFFFFB74D),
        warningLightColor: Color(0xFF4D3800),
        dangerColor: Color(0xFFE57373),
        dangerLightColor: Color(0xFF4D1F1F),
      );
    case ThemePreset.blue:
      return const DataTablePlusTheme(
        backgroundColor: Color(0xFFF0F7FF),
        headerBackgroundColor: Color(0xFFDBEAFE),
        borderColor: Color(0xFFBFDBFE),
        borderLightColor: Color(0xFFE0EFFE),
        textPrimaryColor: Color(0xFF1E3A5F),
        textSecondaryColor: Color(0xFF3B6BA5),
        textMutedColor: Color(0xFF7BA4CC),
        accentColor: Color(0xFF2563EB),
        accentLightColor: Color(0xFFDBEAFE),
        successColor: Color(0xFF059669),
        successLightColor: Color(0xFFD1FAE5),
        warningColor: Color(0xFFD97706),
        warningLightColor: Color(0xFFFEF3C7),
        dangerColor: Color(0xFFDC2626),
        dangerLightColor: Color(0xFFFEE2E2),
      );
    case ThemePreset.green:
      return const DataTablePlusTheme(
        backgroundColor: Color(0xFFF0FDF4),
        headerBackgroundColor: Color(0xFFDCFCE7),
        borderColor: Color(0xFFBBF7D0),
        borderLightColor: Color(0xFFD1FAE5),
        textPrimaryColor: Color(0xFF14532D),
        textSecondaryColor: Color(0xFF166534),
        textMutedColor: Color(0xFF6DA88A),
        accentColor: Color(0xFF16A34A),
        accentLightColor: Color(0xFFDCFCE7),
        successColor: Color(0xFF16A34A),
        successLightColor: Color(0xFFDCFCE7),
        warningColor: Color(0xFFCA8A04),
        warningLightColor: Color(0xFFFEF9C3),
        dangerColor: Color(0xFFDC2626),
        dangerLightColor: Color(0xFFFEE2E2),
      );
    case ThemePreset.purple:
      return const DataTablePlusTheme(
        backgroundColor: Color(0xFFFAF5FF),
        headerBackgroundColor: Color(0xFFF3E8FF),
        borderColor: Color(0xFFE9D5FF),
        borderLightColor: Color(0xFFF3E8FF),
        textPrimaryColor: Color(0xFF3B0764),
        textSecondaryColor: Color(0xFF6B21A8),
        textMutedColor: Color(0xFFA78BFA),
        accentColor: Color(0xFF9333EA),
        accentLightColor: Color(0xFFF3E8FF),
        successColor: Color(0xFF059669),
        successLightColor: Color(0xFFD1FAE5),
        warningColor: Color(0xFFD97706),
        warningLightColor: Color(0xFFFEF3C7),
        dangerColor: Color(0xFFDC2626),
        dangerLightColor: Color(0xFFFEE2E2),
      );
  }
}

Color getScaffoldBg(ThemePreset preset) {
  switch (preset) {
    case ThemePreset.dark:
      return const Color(0xFF121212);
    case ThemePreset.blue:
      return const Color(0xFFE8F0FE);
    case ThemePreset.green:
      return const Color(0xFFE8F5E9);
    case ThemePreset.purple:
      return const Color(0xFFF3E5F5);
    default:
      return const Color(0xFFF5F5F5);
  }
}

// =============================================================================
// DATA MODEL
// =============================================================================

enum UserStatus { active, inactive, pending, suspended }

enum UserRole { admin, editor, viewer, guest }

class User {
  final String id;
  final String name;
  final String email;
  final String department;
  final UserRole role;
  final UserStatus status;
  final DateTime createdAt;
  final DateTime lastLogin;
  final int loginCount;
  final double score;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.lastLogin,
    required this.loginCount,
    required this.score,
  });

  String get formattedCreatedAt =>
      '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';

  String get formattedLastLogin =>
      '${lastLogin.year}-${lastLogin.month.toString().padLeft(2, '0')}-${lastLogin.day.toString().padLeft(2, '0')} '
      '${lastLogin.hour.toString().padLeft(2, '0')}:${lastLogin.minute.toString().padLeft(2, '0')}';

  String get roleLabel {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.editor:
        return 'Editor';
      case UserRole.viewer:
        return 'Viewer';
      case UserRole.guest:
        return 'Guest';
    }
  }

  String get statusLabel {
    switch (status) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
      case UserStatus.pending:
        return 'Pending';
      case UserStatus.suspended:
        return 'Suspended';
    }
  }
}

List<User> generateUsers(int count) {
  final firstNames = [
    'James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael',
    'Linda', 'William', 'Elizabeth', 'David', 'Barbara', 'Richard', 'Susan',
    'Joseph', 'Jessica', 'Thomas', 'Sarah', 'Charles', 'Karen', 'Wei', 'Fang',
    'Ming', 'Li', 'Chen', 'Wang', 'Zhang', 'Liu', 'Yang', 'Huang',
  ];

  final lastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller',
    'Davis', 'Rodriguez', 'Martinez', 'Anderson', 'Taylor', 'Thomas', 'Moore',
    'Jackson', 'Martin', 'Lee', 'Thompson', 'White', 'Harris', 'Chen', 'Wang',
    'Li', 'Zhang', 'Liu', 'Yang', 'Huang', 'Wu', 'Zhou', 'Xu',
  ];

  final departments = [
    'Engineering', 'Marketing', 'Sales', 'Finance', 'HR', 'Operations',
    'Product', 'Design', 'Legal', 'Support', 'Research', 'IT',
  ];

  final baseDate = DateTime(2024, 1, 1);

  return List.generate(count, (index) {
    final firstName = firstNames[index % firstNames.length];
    final lastName = lastNames[(index * 7) % lastNames.length];
    final name = '$firstName $lastName';
    final email =
        '${firstName.toLowerCase()}.${lastName.toLowerCase()}$index@example.com';

    return User(
      id: 'USR${(index + 1).toString().padLeft(5, '0')}',
      name: name,
      email: email,
      department: departments[index % departments.length],
      role: UserRole.values[index % UserRole.values.length],
      status: UserStatus.values[index % UserStatus.values.length],
      createdAt: baseDate.subtract(Duration(days: index * 3)),
      lastLogin: baseDate.subtract(
        Duration(hours: index * 5, minutes: index * 17),
      ),
      loginCount: (index * 13 + 5) % 500,
      score: ((index * 17 + 30) % 100) + (index % 10) / 10,
    );
  });
}

// =============================================================================
// PLAYGROUND PAGE
// =============================================================================

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ThemePreset _themePreset = ThemePreset.light;

  DataTablePlusTheme get _theme => getThemePreset(_themePreset);
  bool get _isDark => _themePreset == ThemePreset.dark;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getScaffoldBg(_themePreset),
      appBar: AppBar(
        title: const Text('DataTablePlus Playground'),
        backgroundColor: _isDark ? const Color(0xFF1E1E1E) : null,
        foregroundColor: _isDark ? Colors.white : null,
        actions: [
          // Theme preset selector
          PopupMenuButton<ThemePreset>(
            icon: Icon(
              Icons.palette_outlined,
              color: _isDark ? Colors.white : null,
            ),
            tooltip: 'Theme',
            onSelected: (preset) => setState(() => _themePreset = preset),
            itemBuilder: (_) => ThemePreset.values
                .map(
                  (p) => PopupMenuItem(
                    value: p,
                    child: Row(
                      children: [
                        Icon(
                          _themePreset == p
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 18,
                          color: _themePreset == p ? Colors.blue : null,
                        ),
                        const SizedBox(width: 8),
                        Text(p.name[0].toUpperCase() + p.name.substring(1)),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: _isDark ? Colors.white : null,
          unselectedLabelColor: _isDark ? Colors.grey : null,
          indicatorColor: _theme.accentColor,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Full Demo'),
            Tab(text: 'Table'),
            Tab(text: 'Badges'),
            Tab(text: 'Filters'),
            Tab(text: 'Pagination'),
            Tab(text: 'Selection'),
            Tab(text: 'Context Bar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FullDemoTab(theme: _theme, themePreset: _themePreset),
          TableOptionsTab(theme: _theme, isDark: _isDark),
          BadgesTab(theme: _theme, isDark: _isDark),
          FiltersTab(theme: _theme, isDark: _isDark),
          PaginationTab(theme: _theme, isDark: _isDark),
          SelectionBarTab(theme: _theme, isDark: _isDark),
          ContextBarTab(theme: _theme, isDark: _isDark),
        ],
      ),
    );
  }
}

// =============================================================================
// SHARED HELPERS
// =============================================================================

Widget buildSectionCard({
  required String title,
  required Widget child,
  required bool isDark,
  String? subtitle,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

Widget buildStatusBadge(UserStatus status) {
  switch (status) {
    case UserStatus.active:
      return StatusBadge.success('Active');
    case UserStatus.inactive:
      return StatusBadge.neutral('Inactive');
    case UserStatus.pending:
      return StatusBadge.warning('Pending');
    case UserStatus.suspended:
      return StatusBadge.danger('Suspended');
  }
}

Widget buildRoleBadge(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return StatusBadge.danger('Admin');
    case UserRole.editor:
      return StatusBadge.warning('Editor');
    case UserRole.viewer:
      return StatusBadge.info('Viewer');
    case UserRole.guest:
      return StatusBadge.neutral('Guest');
  }
}

Widget buildScoreIndicator(double score) {
  Color color;
  if (score >= 80) {
    color = Colors.green;
  } else if (score >= 60) {
    color = Colors.orange;
  } else {
    color = Colors.red;
  }
  return Row(
    children: [
      Container(
        width: 40,
        height: 6,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(3),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: score / 100,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        score.toStringAsFixed(1),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    ],
  );
}

// =============================================================================
// TAB 1: FULL DEMO
// =============================================================================

class FullDemoTab extends StatefulWidget {
  final DataTablePlusTheme theme;
  final ThemePreset themePreset;

  const FullDemoTab({super.key, required this.theme, required this.themePreset});

  @override
  State<FullDemoTab> createState() => _FullDemoTabState();
}

class _FullDemoTabState extends State<FullDemoTab>
    with AutomaticKeepAliveClientMixin {
  late List<User> _allUsers;
  List<User> _filteredUsers = [];
  final Set<String> _selectedIds = {};

  int _currentPage = 1;
  int _pageSize = 10;

  String _searchQuery = '';
  UserStatus? _statusFilter;
  UserRole? _roleFilter;
  String? _departmentFilter;
  DateTime? _createdFromDate;
  DateTime? _createdToDate;
  DateTime? _lastLoginFromDate;
  DateTime? _lastLoginToDate;

  bool _showCheckboxes = true;
  bool _showAdvancedFilters = false;
  bool _showColumnInfo = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _allUsers = generateUsers(300);
    _applyFilters();
  }

  bool get _isDark => widget.themePreset == ThemePreset.dark;

  void _applyFilters() {
    _filteredUsers = _allUsers.where((user) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!user.name.toLowerCase().contains(query) &&
            !user.email.toLowerCase().contains(query) &&
            !user.id.toLowerCase().contains(query) &&
            !user.department.toLowerCase().contains(query)) {
          return false;
        }
      }
      if (_statusFilter != null && user.status != _statusFilter) return false;
      if (_roleFilter != null && user.role != _roleFilter) return false;
      if (_departmentFilter != null && user.department != _departmentFilter) {
        return false;
      }
      if (_createdFromDate != null &&
          user.createdAt.isBefore(_createdFromDate!)) {
        return false;
      }
      if (_createdToDate != null) {
        final endOfDay = _createdToDate!.add(const Duration(days: 1));
        if (user.createdAt.isAfter(endOfDay)) return false;
      }
      if (_lastLoginFromDate != null &&
          user.lastLogin.isBefore(_lastLoginFromDate!)) {
        return false;
      }
      if (_lastLoginToDate != null) {
        final endOfDay = _lastLoginToDate!.add(const Duration(days: 1));
        if (user.lastLogin.isAfter(endOfDay)) return false;
      }
      return true;
    }).toList();
    _currentPage = 1;
  }

  List<User> get _paginatedUsers {
    final startIndex = (_currentPage - 1) * _pageSize;
    if (startIndex >= _filteredUsers.length) return [];
    final endIndex = (startIndex + _pageSize).clamp(0, _filteredUsers.length);
    return _filteredUsers.sublist(startIndex, endIndex);
  }

  int get _totalPages =>
      (_filteredUsers.length / _pageSize).ceil().clamp(1, 999);

  bool get _allSelected {
    final current = _paginatedUsers;
    if (current.isEmpty) return false;
    return current.every((u) => _selectedIds.contains(u.id));
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      final current = _paginatedUsers;
      if (_allSelected) {
        for (final user in current) {
          _selectedIds.remove(user.id);
        }
      } else {
        for (final user in current) {
          _selectedIds.add(user.id);
        }
      }
    });
  }

  void _clearSelection() {
    setState(() => _selectedIds.clear());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: _isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildStatsBar(),
            DataTablePlusThemeProvider(
              theme: widget.theme,
              child: TableContextualBar(
                selectedCount: _selectedIds.length,
                normalToolbar: _buildToolbar(),
                selectedCountTemplate: '{count} selected',
                selectAllWidget: OutlinedButton(
                  onPressed: _toggleSelectAll,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.theme.accentColor,
                    side: BorderSide(
                      color: widget.theme.accentColor.withValues(alpha: 0.4),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _allSelected
                        ? 'Deselect All'
                        : 'Select All (${_paginatedUsers.length})',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                actions: [
                  OutlinedButton.icon(
                    onPressed: _clearSelection,
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: widget.theme.textSecondaryColor,
                    ),
                    label: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.theme.textSecondaryColor,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      side: BorderSide(color: widget.theme.borderColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  FilledButton.icon(
                    onPressed: () {
                      // Demo: just clear selection
                      _clearSelection();
                    },
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: Text('Delete (${_selectedIds.length})'),
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.theme.dangerColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: DataTablePlusThemeProvider(
                  theme: widget.theme,
                  child: DataTablePlus<User>(
                    items: _paginatedUsers,
                    idGetter: (user) => user.id,
                    selectedIds: _selectedIds,
                    allSelected: _allSelected,
                    showCheckboxes: _showCheckboxes,
                    onSelectionChanged: _toggleSelection,
                    onSelectAllChanged: _toggleSelectAll,
                    columns: _buildColumns(),
                    actionBuilder: _buildActionCell,
                    actionLabel: 'Actions',
                    emptyWidget: _buildEmptyWidget(),
                    showColumnInfo: _showColumnInfo,
                    onToggleColumnInfo: () =>
                        setState(() => _showColumnInfo = !_showColumnInfo),
                  ),
                ),
              ),
            ),
            DataTablePlusThemeProvider(
              theme: widget.theme,
              child: TablePagination(
                currentPage: _currentPage,
                totalPages: _totalPages,
                totalItems: _filteredUsers.length,
                pageSize: _pageSize,
                pageSizeOptions: const [10, 20, 50, 100],
                onPageSizeChanged: (size) => setState(() {
                  _pageSize = size;
                  _currentPage = 1;
                }),
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemRangeTemplate: 'Showing {start}-{end} of {total} users',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    final textColor = _isDark ? Colors.white : Colors.black87;
    final mutedColor = _isDark ? Colors.grey[400] : Colors.grey[600];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _isDark ? const Color(0xFF404040) : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'User Management',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const Spacer(),
          _buildStatItem(
            'Total', _allUsers.length.toString(), textColor, mutedColor,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            'Filtered', _filteredUsers.length.toString(), Colors.blue,
            mutedColor,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            'Selected', _selectedIds.length.toString(), Colors.green,
            mutedColor,
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(
              _showCheckboxes ? Icons.check_box : Icons.check_box_outline_blank,
              color: mutedColor,
            ),
            tooltip: 'Toggle Checkboxes',
            onPressed: () =>
                setState(() => _showCheckboxes = !_showCheckboxes),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label, String value, Color valueColor, Color? labelColor,
  ) {
    return Row(
      children: [
        Text('$label: ', style: TextStyle(fontSize: 13, color: labelColor)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    final hasAdvancedFilters =
        _roleFilter != null || _departmentFilter != null;
    final advancedFilterCount =
        (_roleFilter != null ? 1 : 0) + (_departmentFilter != null ? 1 : 0);

    return TableFilterToolbar(
      mainFilters: [
        FilterSearchField(
          hint: 'Search by name, email, ID...',
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _applyFilters();
            });
          },
        ),
        FilterDropdown<UserStatus?>(
          value: _statusFilter,
          label: 'Status',
          hint: 'All',
          items: [
            const DropdownMenuItem(value: null, child: Text('All')),
            ...UserStatus.values.map(
              (s) => DropdownMenuItem(
                value: s,
                child: Text(
                  s.name[0].toUpperCase() + s.name.substring(1),
                ),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _statusFilter = value;
              _applyFilters();
            });
          },
        ),
        FilterDateRangePicker(
          label: 'Created',
          fromDate: _createdFromDate,
          toDate: _createdToDate,
          showTimePicker: true,
          onFromDateChanged: (date) {
            setState(() {
              _createdFromDate = date;
              _applyFilters();
            });
          },
          onToDateChanged: (date) {
            setState(() {
              _createdToDate = date;
              _applyFilters();
            });
          },
        ),
        FilterDateRangePicker(
          label: 'Last Login',
          fromDate: _lastLoginFromDate,
          toDate: _lastLoginToDate,
          showTimePicker: true,
          onFromDateChanged: (date) {
            setState(() {
              _lastLoginFromDate = date;
              _applyFilters();
            });
          },
          onToDateChanged: (date) {
            setState(() {
              _lastLoginToDate = date;
              _applyFilters();
            });
          },
        ),
      ],
      trailingActions: [
        FilterResetButton(
          onReset: () {
            setState(() {
              _searchQuery = '';
              _statusFilter = null;
              _roleFilter = null;
              _departmentFilter = null;
              _createdFromDate = null;
              _createdToDate = null;
              _lastLoginFromDate = null;
              _lastLoginToDate = null;
              _showAdvancedFilters = false;
              _applyFilters();
            });
          },
        ),
      ],
      fixedEndAction: FilterAdvancedToggle(
        isExpanded: _showAdvancedFilters,
        activeFilterCount: advancedFilterCount,
        onToggle: () =>
            setState(() => _showAdvancedFilters = !_showAdvancedFilters),
      ),
      showAdvancedFilters: _showAdvancedFilters,
      advancedFilters: [
        FilterDropdown<UserRole?>(
          value: _roleFilter,
          label: 'Role',
          hint: 'All',
          items: [
            const DropdownMenuItem(value: null, child: Text('All')),
            ...UserRole.values.map(
              (r) => DropdownMenuItem(
                value: r,
                child: Text(
                  r.name[0].toUpperCase() + r.name.substring(1),
                ),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _roleFilter = value;
              _applyFilters();
            });
          },
        ),
        FilterDropdown<String?>(
          value: _departmentFilter,
          label: 'Dept',
          hint: 'All',
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('All'),
            ),
            ...[
              'Engineering', 'Marketing', 'Sales', 'Finance', 'HR',
              'Operations', 'Product', 'Design', 'Legal', 'Support',
              'Research', 'IT',
            ].map((d) => DropdownMenuItem(value: d, child: Text(d))),
          ],
          onChanged: (value) {
            setState(() {
              _departmentFilter = value;
              _applyFilters();
            });
          },
        ),
      ],
      advancedFiltersTrailing: hasAdvancedFilters
          ? FilterClearButton(
              onClear: () {
                setState(() {
                  _roleFilter = null;
                  _departmentFilter = null;
                  _applyFilters();
                });
              },
            )
          : null,
    );
  }

  List<ColumnDefinition<User>> _buildColumns() {
    return [
      ColumnDefinition<User>(
        label: 'ID',
        description: 'Unique user identifier',
        size: const ColumnSize.auto(),
        cellBuilder: TextCellBuilder.monospace<User>((u) => u.id),
      ),
      ColumnDefinition<User>(
        label: 'Name',
        description: 'Full name of the user',
        flex: 2,
        cellBuilder: (user) => Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      ColumnDefinition<User>(
        label: 'Email',
        description: 'Work email address',
        flex: 3,
        cellBuilder: TextCellBuilder.text<User>(
          (u) => u.email,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ColumnDefinition<User>(
        label: 'Dept',
        description: 'Organizational department',
        size: const ColumnSize.auto(),
        cellBuilder: TextCellBuilder.text<User>((u) => u.department),
      ),
      ColumnDefinition<User>(
        label: 'Role',
        description: 'Permission level',
        size: const ColumnSize.auto(),
        cellBuilder: (user) => buildRoleBadge(user.role),
      ),
      ColumnDefinition<User>(
        label: 'Status',
        description: 'Account status',
        size: const ColumnSize.auto(),
        cellBuilder: (user) => buildStatusBadge(user.status),
      ),
      ColumnDefinition<User>(
        label: 'Created',
        description: 'Account creation date',
        size: const ColumnSize.auto(),
        cellBuilder: TextCellBuilder.text<User>((u) => u.formattedCreatedAt),
      ),
      ColumnDefinition<User>(
        label: 'Last Login',
        description: 'Most recent login time',
        flex: 2,
        cellBuilder: TextCellBuilder.text<User>((u) => u.formattedLastLogin),
      ),
      ColumnDefinition<User>(
        label: 'Logins',
        description: 'Total login count',
        size: const ColumnSize.auto(),
        cellBuilder: TextCellBuilder.monospace<User>(
          (u) => u.loginCount.toString(),
        ),
      ),
      ColumnDefinition<User>(
        label: 'Score',
        description: 'Performance score (0-100)',
        size: const ColumnSize.auto(),
        cellBuilder: (user) => buildScoreIndicator(user.score),
      ),
    ];
  }

  Widget _buildActionCell(User user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.visibility_outlined, size: 18, color: _isDark ? Colors.blue[300] : Colors.blue),
          tooltip: 'View',
          onPressed: () => _showUserDialog(user, 'View'),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.edit_outlined, size: 18, color: _isDark ? Colors.orange[300] : Colors.orange),
          tooltip: 'Edit',
          onPressed: () => _showUserDialog(user, 'Edit'),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.delete_outline, size: 18, color: _isDark ? Colors.red[300] : Colors.red),
          tooltip: 'Delete',
          onPressed: () => _showUserDialog(user, 'Delete'),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  void _showUserDialog(User user, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$action User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user.id}'),
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
            Text('Department: ${user.department}'),
            Text('Role: ${user.roleLabel}'),
            Text('Status: ${user.statusLabel}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off, size: 48, color: _isDark ? Colors.grey[600] : Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No users found',
              style: TextStyle(fontSize: 14, color: _isDark ? Colors.grey[500] : Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(fontSize: 12, color: _isDark ? Colors.grey[600] : Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TAB 2: TABLE OPTIONS
// =============================================================================

class TableOptionsTab extends StatefulWidget {
  final DataTablePlusTheme theme;
  final bool isDark;

  const TableOptionsTab({
    super.key,
    required this.theme,
    required this.isDark,
  });

  @override
  State<TableOptionsTab> createState() => _TableOptionsTabState();
}

class _TableOptionsTabState extends State<TableOptionsTab>
    with AutomaticKeepAliveClientMixin {
  bool _showCheckboxes = true;
  bool _showActions = true;
  bool _showColumnInfo = false;
  bool _useCustomHeaders = false;
  bool _useTextCellBuilder = true;
  bool _showEmptyState = false;
  int _rowCount = 5;

  final Set<String> _selectedIds = {};
  late List<User> _users;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _users = generateUsers(20);
  }

  List<User> get _displayUsers =>
      _showEmptyState ? [] : _users.take(_rowCount).toList();

  bool get _allSelected {
    final items = _displayUsers;
    if (items.isEmpty) return false;
    return items.every((u) => _selectedIds.contains(u.id));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Options panel
          SizedBox(
            width: 260,
            child: buildSectionCard(
              title: 'Table Options',
              subtitle: 'Toggle features to see changes',
              isDark: widget.isDark,
              child: Column(
                children: [
                  _buildSwitch('Show checkboxes', _showCheckboxes,
                      (v) => setState(() => _showCheckboxes = v)),
                  _buildSwitch('Show action column', _showActions,
                      (v) => setState(() => _showActions = v)),
                  _buildSwitch('Show column info', _showColumnInfo,
                      (v) => setState(() => _showColumnInfo = v)),
                  _buildSwitch('Custom header builder', _useCustomHeaders,
                      (v) => setState(() => _useCustomHeaders = v)),
                  _buildSwitch('Use TextCellBuilder', _useTextCellBuilder,
                      (v) => setState(() => _useTextCellBuilder = v)),
                  _buildSwitch('Show empty state', _showEmptyState,
                      (v) => setState(() => _showEmptyState = v)),
                  const Divider(),
                  Row(
                    children: [
                      Text(
                        'Rows: $_rowCount',
                        style: TextStyle(
                          fontSize: 13,
                          color: widget.isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _rowCount.toDouble(),
                          min: 1,
                          max: 20,
                          divisions: 19,
                          onChanged: (v) =>
                              setState(() => _rowCount = v.toInt()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Live preview
          Expanded(
            child: buildSectionCard(
              title: 'Live Preview',
              isDark: widget.isDark,
              child: DataTablePlusThemeProvider(
                theme: widget.theme,
                child: DataTablePlus<User>(
                  items: _displayUsers,
                  idGetter: (u) => u.id,
                  selectedIds: _selectedIds,
                  allSelected: _allSelected,
                  showCheckboxes: _showCheckboxes,
                  onSelectionChanged: (id) {
                    setState(() {
                      if (_selectedIds.contains(id)) {
                        _selectedIds.remove(id);
                      } else {
                        _selectedIds.add(id);
                      }
                    });
                  },
                  onSelectAllChanged: () {
                    setState(() {
                      if (_allSelected) {
                        for (final u in _displayUsers) {
                          _selectedIds.remove(u.id);
                        }
                      } else {
                        for (final u in _displayUsers) {
                          _selectedIds.add(u.id);
                        }
                      }
                    });
                  },
                  showColumnInfo: _showColumnInfo,
                  onToggleColumnInfo: () =>
                      setState(() => _showColumnInfo = !_showColumnInfo),
                  actionBuilder: _showActions ? _buildAction : null,
                  actionLabel: 'Actions',
                  columns: _buildColumns(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ColumnDefinition<User>> _buildColumns() {
    Widget Function(String label)? headerBuilder;
    if (_useCustomHeaders) {
      headerBuilder = (label) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.theme.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: widget.theme.accentColor,
              ),
            ),
          );
    }

    if (_useTextCellBuilder) {
      return [
        ColumnDefinition<User>(
          label: 'ID',
          description: 'User identifier',
          flex: 1,
          headerBuilder: headerBuilder,
          cellBuilder: TextCellBuilder.monospace<User>((u) => u.id),
        ),
        ColumnDefinition<User>(
          label: 'Name',
          description: 'Full name',
          flex: 2,
          headerBuilder: headerBuilder,
          cellBuilder: TextCellBuilder.text<User>(
            (u) => u.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        ColumnDefinition<User>(
          label: 'Email',
          description: 'Email address',
          flex: 3,
          headerBuilder: headerBuilder,
          cellBuilder: TextCellBuilder.text<User>((u) => u.email),
        ),
        ColumnDefinition<User>(
          label: 'Status',
          description: 'Account status',
          flex: 1,
          headerBuilder: headerBuilder,
          cellBuilder: (user) => buildStatusBadge(user.status),
        ),
      ];
    }

    return [
      ColumnDefinition<User>(
        label: 'ID',
        description: 'User identifier',
        flex: 1,
        headerBuilder: headerBuilder,
        cellBuilder: (user) => Text(
          user.id,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      ),
      ColumnDefinition<User>(
        label: 'Name',
        description: 'Full name',
        flex: 2,
        headerBuilder: headerBuilder,
        cellBuilder: (user) => Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      ColumnDefinition<User>(
        label: 'Email',
        description: 'Email address',
        flex: 3,
        headerBuilder: headerBuilder,
        cellStyle: TextStyle(
          fontSize: 12,
          color: widget.isDark ? Colors.blue[300] : Colors.blue[700],
          decoration: TextDecoration.underline,
        ),
        cellBuilder: (user) => Text(user.email),
      ),
      ColumnDefinition<User>(
        label: 'Status',
        description: 'Account status',
        flex: 1,
        headerBuilder: headerBuilder,
        cellBuilder: (user) => buildStatusBadge(user.status),
      ),
    ];
  }

  Widget _buildAction(User user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility_outlined, size: 18),
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: 'View',
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 18),
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: 'Edit',
        ),
      ],
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: widget.isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

// =============================================================================
// TAB 3: BADGES
// =============================================================================

class BadgesTab extends StatelessWidget {
  final DataTablePlusTheme theme;
  final bool isDark;

  const BadgesTab({super.key, required this.theme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DataTablePlusThemeProvider(
        theme: theme,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // StatusBadge
                Expanded(
                  child: buildSectionCard(
                    title: 'StatusBadge',
                    subtitle: 'Pill-shaped status badges with factory constructors',
                    isDark: isDark,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 16,
                      children: [
                        _badgeItem('StatusBadge.success()', StatusBadge.success('Active')),
                        _badgeItem('StatusBadge.warning()', StatusBadge.warning('Pending')),
                        _badgeItem('StatusBadge.danger()', StatusBadge.danger('Error')),
                        _badgeItem('StatusBadge.info()', StatusBadge.info('Info')),
                        _badgeItem('StatusBadge.neutral()', StatusBadge.neutral('Muted')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // CountBadge
                Expanded(
                  child: buildSectionCard(
                    title: 'CountBadge',
                    subtitle: 'Small count indicators for notifications',
                    isDark: isDark,
                    child: Builder(
                      builder: (context) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 16,
                          children: [
                            _badgeItem('Default', const CountBadge(count: 3)),
                            _badgeItem(
                              'Custom color',
                              const CountBadge(
                                count: 12,
                                backgroundColor: Colors.orange,
                              ),
                            ),
                            _badgeItem(
                              'Custom bg + text',
                              const CountBadge(
                                count: 99,
                                backgroundColor: Colors.purple,
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            // Custom StatusBadge
            buildSectionCard(
              title: 'Custom StatusBadge',
              subtitle: 'StatusBadge with manual color configuration',
              isDark: isDark,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  const StatusBadge(
                    label: 'Teal Custom',
                    backgroundColor: Color(0xFFE0F2F1),
                    textColor: Color(0xFF00897B),
                  ),
                  const StatusBadge(
                    label: 'Pink Custom',
                    backgroundColor: Color(0xFFFCE4EC),
                    textColor: Color(0xFFE91E63),
                  ),
                  const StatusBadge(
                    label: 'Indigo Custom',
                    backgroundColor: Color(0xFFE8EAF6),
                    textColor: Color(0xFF3F51B5),
                  ),
                  const StatusBadge(
                    label: 'Wide Padding',
                    backgroundColor: Color(0xFFFFF3E0),
                    textColor: Color(0xFFFF9800),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  const StatusBadge(
                    label: 'Square',
                    backgroundColor: Color(0xFFE3F2FD),
                    textColor: Color(0xFF2196F3),
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
            // Real-world usage
            buildSectionCard(
              title: 'Real-world Usage',
              subtitle: 'How badges look in typical table contexts',
              isDark: isDark,
              child: Column(
                children: [
                  _usageRow('User Status', [
                    StatusBadge.success('Active'),
                    StatusBadge.warning('Pending'),
                    StatusBadge.danger('Suspended'),
                    StatusBadge.neutral('Inactive'),
                  ]),
                  const Divider(),
                  _usageRow('User Roles', [
                    StatusBadge.danger('Admin'),
                    StatusBadge.warning('Editor'),
                    StatusBadge.info('Viewer'),
                    StatusBadge.neutral('Guest'),
                  ]),
                  const Divider(),
                  _usageRow('Priority Levels', [
                    StatusBadge.danger('Critical'),
                    StatusBadge.warning('High'),
                    StatusBadge.info('Medium'),
                    StatusBadge.neutral('Low'),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badgeItem(String code, Widget badge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        badge,
        const SizedBox(height: 4),
        Text(
          code,
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'monospace',
            color: isDark ? Colors.grey[500] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _usageRow(String label, List<Widget> badges) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          ...badges.map(
            (b) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: b,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TAB 4: FILTERS
// =============================================================================

class FiltersTab extends StatefulWidget {
  final DataTablePlusTheme theme;
  final bool isDark;

  const FiltersTab({super.key, required this.theme, required this.isDark});

  @override
  State<FiltersTab> createState() => _FiltersTabState();
}

class _FiltersTabState extends State<FiltersTab>
    with AutomaticKeepAliveClientMixin {
  String _searchValue = '';
  String? _dropdownValue;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _advancedExpanded = false;
  int _advancedFilterCount = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DataTablePlusThemeProvider(
        theme: widget.theme,
        child: Column(
          children: [
            // FilterSearchField
            buildSectionCard(
              title: 'FilterSearchField',
              subtitle: 'Styled search input with icon and border highlighting',
              isDark: widget.isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterSearchField(
                    hint: 'Search users, emails, IDs...',
                    onChanged: (v) => setState(() => _searchValue = v),
                  ),
                  const SizedBox(height: 12),
                  FilterSearchField(
                    hint: 'Port number...',
                    width: 180,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.search,
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current value: "${_searchValue.isEmpty ? '(empty)' : _searchValue}"',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: widget.isDark ? Colors.grey[500] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // FilterDropdown
            buildSectionCard(
              title: 'FilterDropdown',
              subtitle: 'Styled dropdown selector with optional inline label prefix',
              isDark: widget.isDark,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilterDropdown<String?>(
                    value: _dropdownValue,
                    hint: 'Select Status',
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Status'),
                      ),
                      ...['Active', 'Inactive', 'Pending', 'Suspended'].map(
                        (s) => DropdownMenuItem(value: s, child: Text(s)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _dropdownValue = v),
                  ),
                  FilterDropdown<String?>(
                    value: _dropdownValue,
                    label: 'Status',
                    hint: 'All',
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All'),
                      ),
                      ...['Active', 'Inactive', 'Pending', 'Suspended'].map(
                        (s) => DropdownMenuItem(value: s, child: Text(s)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _dropdownValue = v),
                  ),
                  Text(
                    'Selected: ${_dropdownValue ?? "(none)"}',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: widget.isDark ? Colors.grey[500] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // FilterDateRangePicker
            buildSectionCard(
              title: 'FilterDateRangePicker',
              subtitle: 'Date range selector with calendar icon and clear button',
              isDark: widget.isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      FilterDateRangePicker(
                        label: 'With label',
                        fromDate: _fromDate,
                        toDate: _toDate,
                        onFromDateChanged: (d) =>
                            setState(() => _fromDate = d),
                        onToDateChanged: (d) => setState(() => _toDate = d),
                      ),
                      FilterDateRangePicker(
                        fromDate: _fromDate,
                        toDate: _toDate,
                        fromPlaceholder: 'From',
                        toPlaceholder: 'To',
                        onFromDateChanged: (d) =>
                            setState(() => _fromDate = d),
                        onToDateChanged: (d) => setState(() => _toDate = d),
                      ),
                      FilterDateRangePicker(
                        label: 'With time',
                        fromDate: _fromDate,
                        toDate: _toDate,
                        showTimePicker: true,
                        onFromDateChanged: (d) =>
                            setState(() => _fromDate = d),
                        onToDateChanged: (d) => setState(() => _toDate = d),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'From: ${_fromDate?.toString().split(' ').first ?? "(none)"}  '
                    'To: ${_toDate?.toString().split(' ').first ?? "(none)"}',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: widget.isDark ? Colors.grey[500] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // FilterDatePresets
            buildSectionCard(
              title: 'FilterDatePresets',
              subtitle: 'Quick date preset buttons for common ranges',
              isDark: widget.isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterDatePresets(
                    presets: DatePreset.values.toList(),
                    onPresetSelected: (from, to) {
                      setState(() {
                        _fromDate = from;
                        _toDate = to;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All 8 presets: Today, Yesterday, Last 7 days, Last 30 days, This week, This month, Last month, This year',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.isDark ? Colors.grey[500] : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: buildSectionCard(
                    title: 'FilterAdvancedToggle',
                    subtitle: 'Toggle with rotation animation and active badge',
                    isDark: widget.isDark,
                    child: Row(
                      children: [
                        FilterAdvancedToggle(
                          isExpanded: _advancedExpanded,
                          activeFilterCount: _advancedFilterCount,
                          onToggle: () => setState(
                            () => _advancedExpanded = !_advancedExpanded,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expanded: $_advancedExpanded',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                                color: widget.isDark
                                    ? Colors.grey[500]
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Badge count: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: widget.isDark
                                        ? Colors.grey[500]
                                        : Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Slider(
                                    value: _advancedFilterCount.toDouble(),
                                    min: 0,
                                    max: 5,
                                    divisions: 5,
                                    onChanged: (v) => setState(
                                      () => _advancedFilterCount = v.toInt(),
                                    ),
                                  ),
                                ),
                                Text(
                                  '$_advancedFilterCount',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    color: widget.isDark
                                        ? Colors.grey[500]
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildSectionCard(
                    title: 'FilterResetButton & FilterClearButton',
                    subtitle: 'Action buttons with spin animation and clear',
                    isDark: widget.isDark,
                    child: Row(
                      children: [
                        FilterResetButton(onReset: () {}),
                        const SizedBox(width: 12),
                        FilterClearButton(onClear: () {}),
                        const SizedBox(width: 12),
                        FilterClearButton(
                          onClear: () {},
                          label: 'Reset Advanced',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Full TableFilterToolbar
            buildSectionCard(
              title: 'TableFilterToolbar (Complete)',
              subtitle: 'Full two-row filter toolbar with main + advanced filters',
              isDark: widget.isDark,
              child: TableFilterToolbar(
                mainFilters: [
                  FilterSearchField(
                    hint: 'Search...',
                    onChanged: (_) {},
                  ),
                  FilterDropdown<String?>(
                    value: null,
                    hint: 'Status',
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(
                        value: 'active',
                        child: Text('Active'),
                      ),
                    ],
                    onChanged: (_) {},
                  ),
                  FilterDateRangePicker(
                    label: 'Date',
                    onFromDateChanged: (_) {},
                    onToDateChanged: (_) {},
                  ),
                ],
                trailingActions: [
                  FilterResetButton(onReset: () {}),
                ],
                fixedEndAction: FilterAdvancedToggle(
                  isExpanded: _advancedExpanded,
                  onToggle: () => setState(
                    () => _advancedExpanded = !_advancedExpanded,
                  ),
                ),
                showAdvancedFilters: _advancedExpanded,
                advancedFilters: [
                  FilterDropdown<String?>(
                    value: null,
                    hint: 'Role',
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All Roles')),
                    ],
                    onChanged: (_) {},
                  ),
                  FilterDropdown<String?>(
                    value: null,
                    hint: 'Department',
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All Depts')),
                    ],
                    onChanged: (_) {},
                  ),
                ],
                advancedFiltersTrailing: FilterClearButton(onClear: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TAB 5: PAGINATION
// =============================================================================

class PaginationTab extends StatefulWidget {
  final DataTablePlusTheme theme;
  final bool isDark;

  const PaginationTab({super.key, required this.theme, required this.isDark});

  @override
  State<PaginationTab> createState() => _PaginationTabState();
}

class _PaginationTabState extends State<PaginationTab>
    with AutomaticKeepAliveClientMixin {
  int _totalItems = 300;
  int _pageSize = 10;
  int _currentPage = 1;
  int _maxVisiblePages = 5;
  String _rangeTemplate = 'Showing {start}-{end} of {total} items';
  String _sizeTemplate = '{size}/page';

  static const List<int> _pageSizeOptions = [5, 10, 20, 50, 100];

  @override
  bool get wantKeepAlive => true;

  int get _totalPages => (_totalItems / _pageSize).ceil().clamp(1, 999);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Options
          SizedBox(
            width: 320,
            child: buildSectionCard(
              title: 'Pagination Options',
              subtitle: 'Adjust properties to see live changes',
              isDark: widget.isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSlider('Total items', _totalItems, 0, 1000,
                      (v) => setState(() {
                            _totalItems = v;
                            if (_currentPage > _totalPages) {
                              _currentPage = _totalPages;
                            }
                          })),
                  _buildPageSizeSelector(),
                  _buildSlider('Current page', _currentPage, 1, _totalPages,
                      (v) => setState(() => _currentPage = v)),
                  _buildSlider('Max visible pages', _maxVisiblePages, 3, 10,
                      (v) => setState(() => _maxVisiblePages = v)),
                  const Divider(),
                  _buildTemplateField(
                    'Range template',
                    _rangeTemplate,
                    '{start}, {end}, {total}',
                    (v) => setState(() => _rangeTemplate = v),
                  ),
                  const SizedBox(height: 8),
                  _buildTemplateField(
                    'Size template',
                    _sizeTemplate,
                    '{size}',
                    (v) => setState(() => _sizeTemplate = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Preview
          Expanded(
            child: Column(
              children: [
                buildSectionCard(
                  title: 'Live Preview',
                  isDark: widget.isDark,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.isDark
                            ? const Color(0xFF404040)
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DataTablePlusThemeProvider(
                      theme: widget.theme,
                      child: TablePagination(
                        currentPage: _currentPage,
                        totalPages: _totalPages,
                        totalItems: _totalItems,
                        pageSize: _pageSize,
                        pageSizeOptions: _pageSizeOptions,
                        maxVisiblePages: _maxVisiblePages,
                        onPageSizeChanged: (size) => setState(() {
                          _pageSize = size;
                          _currentPage = 1;
                        }),
                        onPageChanged: (page) =>
                            setState(() => _currentPage = page),
                        itemRangeTemplate: _rangeTemplate,
                        pageSizeTemplate: _sizeTemplate,
                      ),
                    ),
                  ),
                ),
                buildSectionCard(
                  title: 'Current State',
                  isDark: widget.isDark,
                  child: Text(
                    'Page $_currentPage of $_totalPages  |  '
                    'Items: $_totalItems  |  '
                    'Page size: $_pageSize  |  '
                    'Max visible: $_maxVisiblePages',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color:
                          widget.isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageSizeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Page size: $_pageSize',
              style: TextStyle(
                fontSize: 13,
                color: widget.isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 6,
              children: _pageSizeOptions.map((size) {
                final isSelected = size == _pageSize;
                return ChoiceChip(
                  label: Text('$size'),
                  selected: isSelected,
                  onSelected: (_) => setState(() {
                    _pageSize = size;
                    _currentPage = 1;
                  }),
                  labelStyle: TextStyle(fontSize: 12, color: isSelected ? Colors.white : null),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label, int value, int min, int max, ValueChanged<int> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 13,
                color: widget.isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: (max - min).clamp(1, 100),
              onChanged: (v) => onChanged(v.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateField(
    String label, String value, String hint, ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: widget.isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            color: widget.isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: widget.isDark ? Colors.grey[600] : Colors.grey,
            ),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: widget.isDark
                    ? const Color(0xFF404040)
                    : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: widget.isDark
                    ? const Color(0xFF404040)
                    : Colors.grey[300]!,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// TAB 6: SELECTION BAR
// =============================================================================

class SelectionBarTab extends StatefulWidget {
  final DataTablePlusTheme theme;
  final bool isDark;

  const SelectionBarTab({
    super.key,
    required this.theme,
    required this.isDark,
  });

  @override
  State<SelectionBarTab> createState() => _SelectionBarTabState();
}

class _SelectionBarTabState extends State<SelectionBarTab>
    with AutomaticKeepAliveClientMixin {
  int _selectedCount = 3;
  int _pageItemCount = 10;
  bool _allPageSelected = false;
  bool _alwaysVisible = false;
  String _template = '{count} selected';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Options
          SizedBox(
            width: 300,
            child: buildSectionCard(
              title: 'Selection Bar Options',
              subtitle: 'Adjust properties to see live changes',
              isDark: widget.isDark,
              child: Column(
                children: [
                  _buildSlider('Selected count', _selectedCount, 0, 50,
                      (v) => setState(() => _selectedCount = v)),
                  _buildSlider('Page item count', _pageItemCount, 1, 100,
                      (v) => setState(() => _pageItemCount = v)),
                  _buildSwitch('All page selected', _allPageSelected,
                      (v) => setState(() => _allPageSelected = v)),
                  _buildSwitch('Always visible', _alwaysVisible,
                      (v) => setState(() => _alwaysVisible = v)),
                  const Divider(),
                  _buildTemplateField(
                    'Template',
                    _template,
                    '{count}',
                    (v) => setState(() => _template = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Preview
          Expanded(
            child: Column(
              children: [
                buildSectionCard(
                  title: 'Live Preview',
                  isDark: widget.isDark,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.isDark
                            ? const Color(0xFF404040)
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: DataTablePlusThemeProvider(
                        theme: widget.theme,
                        child: TableSelectionBar(
                          selectedCount: _selectedCount,
                          pageItemCount: _pageItemCount,
                          allPageSelected: _allPageSelected,
                          alwaysVisible: _alwaysVisible,
                          selectedCountTemplate: _template,
                          onSelectAllPage: () => setState(
                            () => _allPageSelected = !_allPageSelected,
                          ),
                          onClearSelection: () =>
                              setState(() => _selectedCount = 0),
                        ),
                      ),
                    ),
                  ),
                ),
                buildSectionCard(
                  title: 'Current State',
                  isDark: widget.isDark,
                  child: Text(
                    'Selected: $_selectedCount  |  '
                    'Page items: $_pageItemCount  |  '
                    'All selected: $_allPageSelected  |  '
                    'Always visible: $_alwaysVisible',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color:
                          widget.isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label, int value, int min, int max, ValueChanged<int> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 13,
                color: widget.isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: (max - min).clamp(1, 100),
              onChanged: (v) => onChanged(v.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: widget.isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildTemplateField(
    String label, String value, String hint, ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: widget.isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            color: widget.isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: widget.isDark
                    ? const Color(0xFF404040)
                    : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: widget.isDark
                    ? const Color(0xFF404040)
                    : Colors.grey[300]!,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// TAB 7: CONTEXT BAR
// =============================================================================

class ContextBarTab extends StatefulWidget {
  final DataTablePlusTheme theme;
  final bool isDark;

  const ContextBarTab({super.key, required this.theme, required this.isDark});

  @override
  State<ContextBarTab> createState() => _ContextBarTabState();
}

class _ContextBarTabState extends State<ContextBarTab>
    with AutomaticKeepAliveClientMixin {
  final Set<String> _selectedIds = {};
  late List<User> _users;
  String _deleteLog = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _users = generateUsers(8);
  }

  bool get _allSelected =>
      _users.isNotEmpty && _users.every((u) => _selectedIds.contains(u.id));

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_allSelected) {
        _selectedIds.clear();
      } else {
        for (final u in _users) {
          _selectedIds.add(u.id);
        }
      }
    });
  }

  void _deleteSelected() {
    final count = _selectedIds.length;
    setState(() {
      _users.removeWhere((u) => _selectedIds.contains(u.id));
      _deleteLog = 'Deleted $count item(s). ${_users.length} remaining.';
      _selectedIds.clear();
    });
  }

  void _resetData() {
    setState(() {
      _users = generateUsers(8);
      _selectedIds.clear();
      _deleteLog = 'Data reset to 8 users.';
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DataTablePlusThemeProvider(
        theme: widget.theme,
        child: Column(
          children: [
            // Interactive demo
            buildSectionCard(
              title: 'TableContextualBar — Interactive Demo',
              subtitle:
                  'Select rows to see the toolbar swap to a contextual action bar',
              isDark: widget.isDark,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.isDark
                            ? const Color(0xFF404040)
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        children: [
                          TableContextualBar(
                            selectedCount: _selectedIds.length,
                            normalToolbar: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: widget.theme.borderLightColor,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  FilledButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Add User'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor:
                                          widget.theme.accentColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      minimumSize: const Size(0, 36),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.file_download_outlined,
                                      size: 18,
                                    ),
                                    label: const Text('Export'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          widget.theme.textSecondaryColor,
                                      side: BorderSide(
                                        color: widget.theme.borderColor,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      minimumSize: const Size(0, 36),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Search...',
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          size: 18,
                                        ),
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: widget.theme.borderColor,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                            color: widget.theme.borderColor,
                                          ),
                                        ),
                                      ),
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            selectAllWidget: OutlinedButton(
                              onPressed: _toggleSelectAll,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: widget.theme.accentColor,
                                side: BorderSide(
                                  color: widget.theme.accentColor
                                      .withValues(alpha: 0.4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                minimumSize: const Size(0, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                _allSelected
                                    ? 'Deselect All'
                                    : 'Select All (${_users.length})',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            actions: [
                              OutlinedButton.icon(
                                onPressed: () =>
                                    setState(() => _selectedIds.clear()),
                                icon: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: widget.theme.textSecondaryColor,
                                ),
                                label: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: widget.theme.textSecondaryColor,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 36),
                                  side: BorderSide(
                                    color: widget.theme.borderColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              FilledButton.icon(
                                onPressed: _selectedIds.isNotEmpty
                                    ? _deleteSelected
                                    : null,
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                ),
                                label:
                                    Text('Delete (${_selectedIds.length})'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: widget.theme.dangerColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  minimumSize: const Size(0, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          DataTablePlus<User>(
                            items: _users,
                            idGetter: (u) => u.id,
                            selectedIds: _selectedIds,
                            allSelected: _allSelected,
                            showCheckboxes: true,
                            onSelectionChanged: _toggleSelection,
                            onSelectAllChanged: _toggleSelectAll,
                            columns: [
                              ColumnDefinition<User>(
                                label: 'ID',
                                size: const ColumnSize.auto(),
                                cellBuilder: TextCellBuilder.monospace<User>(
                                  (u) => u.id,
                                ),
                              ),
                              ColumnDefinition<User>(
                                label: 'Name',
                                flex: 2,
                                cellBuilder: (u) => Text(
                                  u.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              ColumnDefinition<User>(
                                label: 'Email',
                                flex: 3,
                                cellBuilder: TextCellBuilder.text<User>(
                                  (u) => u.email,
                                ),
                              ),
                              ColumnDefinition<User>(
                                label: 'Status',
                                size: const ColumnSize.auto(),
                                cellBuilder: (u) =>
                                    buildStatusBadge(u.status),
                              ),
                            ],
                            actionBuilder: (u) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 16,
                                  ),
                                  onPressed: () {},
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  tooltip: 'Edit',
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 16,
                                    color: widget.theme.dangerColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _users.removeWhere(
                                        (x) => x.id == u.id,
                                      );
                                      _selectedIds.remove(u.id);
                                      _deleteLog =
                                          'Deleted ${u.name}. ${_users.length} remaining.';
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                            actionLabel: 'Actions',
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_deleteLog.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          _deleteLog,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: widget.isDark
                                ? Colors.grey[400]
                                : Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _resetData,
                          child: const Text(
                            'Reset Data',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // How it works
            buildSectionCard(
              title: 'How it works',
              isDark: widget.isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TableContextualBar swaps between two states with a crossfade animation:',
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStateCard(
                    'State 1: Normal Toolbar',
                    'selectedCount == 0',
                    'Shows your custom normalToolbar widget (buttons, search, filters, etc.)',
                    widget.theme.textSecondaryColor,
                  ),
                  const SizedBox(height: 8),
                  _buildStateCard(
                    'State 2: Contextual Bar',
                    'selectedCount > 0',
                    'Shows selection count + selectAllWidget + trailing actions (delete, export, etc.)',
                    widget.theme.accentColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateCard(
    String title,
    String condition,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              condition,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        widget.isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
