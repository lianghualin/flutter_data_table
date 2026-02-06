import 'package:flutter/material.dart';
import 'package:data_table_plus/data_table_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DataTablePlus Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const ExamplePage(),
    );
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

// =============================================================================
// DATA GENERATOR - 300 Users
// =============================================================================

List<User> generateUsers(int count) {
  final firstNames = [
    'James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael',
    'Linda', 'William', 'Elizabeth', 'David', 'Barbara', 'Richard', 'Susan',
    'Joseph', 'Jessica', 'Thomas', 'Sarah', 'Charles', 'Karen', 'Wei', 'Fang',
    'Ming', 'Li', 'Chen', 'Wang', 'Zhang', 'Liu', 'Yang', 'Huang'
  ];

  final lastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller',
    'Davis', 'Rodriguez', 'Martinez', 'Anderson', 'Taylor', 'Thomas', 'Moore',
    'Jackson', 'Martin', 'Lee', 'Thompson', 'White', 'Harris', 'Chen', 'Wang',
    'Li', 'Zhang', 'Liu', 'Yang', 'Huang', 'Wu', 'Zhou', 'Xu'
  ];

  final departments = [
    'Engineering', 'Marketing', 'Sales', 'Finance', 'HR', 'Operations',
    'Product', 'Design', 'Legal', 'Support', 'Research', 'IT'
  ];

  final baseDate = DateTime(2024, 1, 1);

  return List.generate(count, (index) {
    final firstName = firstNames[index % firstNames.length];
    final lastName = lastNames[(index * 7) % lastNames.length];
    final name = '$firstName $lastName';
    final email = '${firstName.toLowerCase()}.${lastName.toLowerCase()}$index@example.com';

    return User(
      id: 'USR${(index + 1).toString().padLeft(5, '0')}',
      name: name,
      email: email,
      department: departments[index % departments.length],
      role: UserRole.values[index % UserRole.values.length],
      status: UserStatus.values[index % UserStatus.values.length],
      createdAt: baseDate.subtract(Duration(days: index * 3)),
      lastLogin: baseDate.subtract(Duration(hours: index * 5, minutes: index * 17)),
      loginCount: (index * 13 + 5) % 500,
      score: ((index * 17 + 30) % 100) + (index % 10) / 10,
    );
  });
}

// =============================================================================
// EXAMPLE PAGE
// =============================================================================

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  // Data
  late List<User> _allUsers;
  List<User> _filteredUsers = [];

  // Selection
  final Set<String> _selectedIds = {};

  // Pagination
  int _currentPage = 1;
  int _pageSize = 10;

  // Filters
  String _searchQuery = '';
  UserStatus? _statusFilter;
  UserRole? _roleFilter;
  String? _departmentFilter;

  // Date range filters
  DateTime? _createdFromDate;
  DateTime? _createdToDate;
  DateTime? _lastLoginFromDate;
  DateTime? _lastLoginToDate;

  // Theme
  bool _useDarkTheme = false;
  bool _showCheckboxes = true;

  // UI State
  bool _showAdvancedFilters = false;
  bool _showColumnInfo = false;

  @override
  void initState() {
    super.initState();
    _allUsers = generateUsers(300);
    _applyFilters();
  }

  void _applyFilters() {
    _filteredUsers = _allUsers.where((user) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!user.name.toLowerCase().contains(query) &&
            !user.email.toLowerCase().contains(query) &&
            !user.id.toLowerCase().contains(query) &&
            !user.department.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Status filter
      if (_statusFilter != null && user.status != _statusFilter) {
        return false;
      }

      // Role filter
      if (_roleFilter != null && user.role != _roleFilter) {
        return false;
      }

      // Department filter
      if (_departmentFilter != null && user.department != _departmentFilter) {
        return false;
      }

      // Created date range filter
      if (_createdFromDate != null) {
        if (user.createdAt.isBefore(_createdFromDate!)) {
          return false;
        }
      }
      if (_createdToDate != null) {
        // Add 1 day to include the end date fully
        final endOfDay = _createdToDate!.add(const Duration(days: 1));
        if (user.createdAt.isAfter(endOfDay)) {
          return false;
        }
      }

      // Last login date range filter
      if (_lastLoginFromDate != null) {
        if (user.lastLogin.isBefore(_lastLoginFromDate!)) {
          return false;
        }
      }
      if (_lastLoginToDate != null) {
        final endOfDay = _lastLoginToDate!.add(const Duration(days: 1));
        if (user.lastLogin.isAfter(endOfDay)) {
          return false;
        }
      }

      return true;
    }).toList();

    // Reset to page 1 when filters change
    _currentPage = 1;
  }

  List<User> get _paginatedUsers {
    final startIndex = (_currentPage - 1) * _pageSize;
    if (startIndex >= _filteredUsers.length) return [];
    final endIndex = (startIndex + _pageSize).clamp(0, _filteredUsers.length);
    return _filteredUsers.sublist(startIndex, endIndex);
  }

  int get _totalPages => (_filteredUsers.length / _pageSize).ceil().clamp(1, 999);

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
    setState(() {
      _selectedIds.clear();
    });
  }

  DataTablePlusTheme get _theme {
    if (_useDarkTheme) {
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
    }
    return DataTablePlusTheme.defaultTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _useDarkTheme ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('DataTablePlus Example'),
        backgroundColor: _useDarkTheme ? const Color(0xFF1E1E1E) : null,
        foregroundColor: _useDarkTheme ? Colors.white : null,
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(_useDarkTheme ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: () => setState(() => _useDarkTheme = !_useDarkTheme),
          ),
          // Checkbox toggle
          IconButton(
            icon: Icon(_showCheckboxes ? Icons.check_box : Icons.check_box_outline_blank),
            tooltip: 'Toggle Checkboxes',
            onPressed: () => setState(() => _showCheckboxes = !_showCheckboxes),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: _useDarkTheme ? const Color(0xFF1E1E1E) : Colors.white,
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
              // Stats bar
              _buildStatsBar(),

              // Toolbar
              _buildToolbar(),

              // Selection bar
              DataTablePlusThemeProvider(
                theme: _theme,
                child: TableSelectionBar(
                  selectedCount: _selectedIds.length,
                  pageItemCount: _paginatedUsers.length,
                  allPageSelected: _allSelected,
                  onSelectAllPage: _toggleSelectAll,
                  onClearSelection: _clearSelection,
                ),
              ),

              // Table
              Expanded(
                child: SingleChildScrollView(
                  child: DataTablePlusThemeProvider(
                    theme: _theme,
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

              // Pagination
              DataTablePlusThemeProvider(
                theme: _theme,
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
      ),
    );
  }

  Widget _buildStatsBar() {
    final textColor = _useDarkTheme ? Colors.white : Colors.black87;
    final mutedColor = _useDarkTheme ? Colors.grey[400] : Colors.grey[600];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _useDarkTheme ? const Color(0xFF404040) : Colors.grey[200]!,
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
          _buildStatItem('Total', _allUsers.length.toString(), textColor, mutedColor),
          const SizedBox(width: 24),
          _buildStatItem('Filtered', _filteredUsers.length.toString(), Colors.blue, mutedColor),
          const SizedBox(width: 24),
          _buildStatItem('Selected', _selectedIds.length.toString(), Colors.green, mutedColor),
          if (_selectedIds.isNotEmpty) ...[
            const SizedBox(width: 16),
            TextButton.icon(
              onPressed: _clearSelection,
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor, Color? labelColor) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 13, color: labelColor),
        ),
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
    final hasAdvancedFilters = _roleFilter != null || _departmentFilter != null;
    final advancedFilterCount = (_roleFilter != null ? 1 : 0) + (_departmentFilter != null ? 1 : 0);

    return DataTablePlusThemeProvider(
      theme: _theme,
      child: TableFilterToolbar(
        mainFilters: [
          // Search
          FilterSearchField(
            hint: 'Search by name, email, ID...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _applyFilters();
              });
            },
          ),

          // Status filter
          FilterDropdown<UserStatus?>(
            value: _statusFilter,
            hint: 'All Status',
            items: [
              const DropdownMenuItem(value: null, child: Text('All Status')),
              ...UserStatus.values.map((s) => DropdownMenuItem(
                value: s,
                child: Text(s.name[0].toUpperCase() + s.name.substring(1)),
              )),
            ],
            onChanged: (value) {
              setState(() {
                _statusFilter = value;
                _applyFilters();
              });
            },
          ),

          // Created Date picker (always visible)
          FilterDateRangePicker(
            label: 'Created',
            fromDate: _createdFromDate,
            toDate: _createdToDate,
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

          // Last Login picker (always visible)
          FilterDateRangePicker(
            label: 'Last Login',
            fromDate: _lastLoginFromDate,
            toDate: _lastLoginToDate,
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
          // Reset filters
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
          onToggle: () => setState(() => _showAdvancedFilters = !_showAdvancedFilters),
        ),
        showAdvancedFilters: _showAdvancedFilters,
        advancedFilters: [
          // Role filter
          FilterDropdown<UserRole?>(
            value: _roleFilter,
            hint: 'All Roles',
            items: [
              const DropdownMenuItem(value: null, child: Text('All Roles')),
              ...UserRole.values.map((r) => DropdownMenuItem(
                value: r,
                child: Text(r.name[0].toUpperCase() + r.name.substring(1)),
              )),
            ],
            onChanged: (value) {
              setState(() {
                _roleFilter = value;
                _applyFilters();
              });
            },
          ),

          // Department filter
          FilterDropdown<String?>(
            value: _departmentFilter,
            hint: 'All Departments',
            items: [
              const DropdownMenuItem(value: null, child: Text('All Departments')),
              ...['Engineering', 'Marketing', 'Sales', 'Finance', 'HR', 'Operations',
                  'Product', 'Design', 'Legal', 'Support', 'Research', 'IT']
                  .map((d) => DropdownMenuItem(value: d, child: Text(d))),
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
      ),
    );
  }

  List<ColumnDefinition<User>> _buildColumns() {
    return [
      ColumnDefinition<User>(
        label: 'ID',
        description: 'Unique user identifier',
        flex: 1,
        cellBuilder: (user) => Text(
          user.id,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
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
        cellBuilder: (user) => Text(
          user.email,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ColumnDefinition<User>(
        label: 'Department',
        description: 'Organizational department',
        flex: 1,
        cellBuilder: (user) => Text(user.department),
      ),
      ColumnDefinition<User>(
        label: 'Role',
        description: 'Permission level',
        flex: 1,
        cellBuilder: (user) => _buildRoleBadge(user.role),
      ),
      ColumnDefinition<User>(
        label: 'Status',
        description: 'Account status',
        flex: 1,
        cellBuilder: (user) => _buildStatusBadge(user.status),
      ),
      ColumnDefinition<User>(
        label: 'Created',
        description: 'Account creation date',
        flex: 1,
        cellBuilder: (user) => Text(user.formattedCreatedAt),
      ),
      ColumnDefinition<User>(
        label: 'Last Login',
        description: 'Most recent login time',
        flex: 2,
        cellBuilder: (user) => Text(user.formattedLastLogin),
      ),
      ColumnDefinition<User>(
        label: 'Logins',
        description: 'Total login count',
        flex: 1,
        cellBuilder: (user) => Text(
          user.loginCount.toString(),
          style: const TextStyle(fontFamily: 'monospace'),
        ),
      ),
      ColumnDefinition<User>(
        label: 'Score',
        description: 'Performance score (0-100)',
        flex: 1,
        cellBuilder: (user) => _buildScoreIndicator(user.score),
      ),
    ];
  }

  Widget _buildRoleBadge(UserRole role) {
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

  Widget _buildStatusBadge(UserStatus status) {
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

  Widget _buildScoreIndicator(double score) {
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

  Widget _buildActionCell(User user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.visibility_outlined,
            size: 18,
            color: _useDarkTheme ? Colors.blue[300] : Colors.blue,
          ),
          tooltip: 'View',
          onPressed: () => _showUserDialog(user, 'View'),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            size: 18,
            color: _useDarkTheme ? Colors.orange[300] : Colors.orange,
          ),
          tooltip: 'Edit',
          onPressed: () => _showUserDialog(user, 'Edit'),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            size: 18,
            color: _useDarkTheme ? Colors.red[300] : Colors.red,
          ),
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
            Icon(
              Icons.search_off,
              size: 48,
              color: _useDarkTheme ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No users found',
              style: TextStyle(
                fontSize: 14,
                color: _useDarkTheme ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(
                fontSize: 12,
                color: _useDarkTheme ? Colors.grey[600] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// CUSTOM DATE PICKER DIALOG
// =============================================================================

class _CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool isDarkTheme;

  const _CustomDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.isDarkTheme,
  });

  @override
  State<_CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<_CustomDatePickerDialog> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  Color get _bgColor => widget.isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _textColor => widget.isDarkTheme ? Colors.white : Colors.black87;
  Color get _mutedColor => widget.isDarkTheme ? Colors.grey[600]! : Colors.grey[400]!;
  Color get _accentColor => widget.isDarkTheme ? const Color(0xFF64B5F6) : const Color(0xFF3B82F6);
  Color get _hoverColor => widget.isDarkTheme ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5);

  List<String> get _weekDays => ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  List<String> get _months => [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    if (date.isBefore(widget.firstDate) || date.isAfter(widget.lastDate)) return;
    setState(() {
      _selectedDate = date;
    });
  }

  List<DateTime?> _getDaysInMonth() {
    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    final days = <DateTime?>[];

    // Add empty slots for days before the first day
    for (int i = 0; i < startWeekday; i++) {
      days.add(null);
    }

    // Add the days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month, day));
    }

    return days;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with month/year and navigation
            _buildHeader(),
            const SizedBox(height: 16),

            // Weekday labels
            _buildWeekdayLabels(),
            const SizedBox(height: 8),

            // Calendar grid
            _buildCalendarGrid(),
            const SizedBox(height: 20),

            // Action buttons
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Month/Year selector
        InkWell(
          onTap: () => _showMonthYearPicker(),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 20, color: _mutedColor),
              ],
            ),
          ),
        ),

        // Navigation arrows
        Row(
          children: [
            _buildNavButton(Icons.chevron_left, _previousMonth),
            const SizedBox(width: 4),
            _buildNavButton(Icons.chevron_right, _nextMonth),
          ],
        ),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _hoverColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: _textColor),
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _weekDays.map((day) {
        return SizedBox(
          width: 36,
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _mutedColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final days = _getDaysInMonth();
    final rows = <Widget>[];

    for (int i = 0; i < days.length; i += 7) {
      final weekDays = days.sublist(i, (i + 7).clamp(0, days.length));
      rows.add(_buildWeekRow(weekDays));
    }

    return Column(children: rows);
  }

  Widget _buildWeekRow(List<DateTime?> days) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((date) => _buildDayCell(date)).toList(),
      ),
    );
  }

  Widget _buildDayCell(DateTime? date) {
    if (date == null) {
      return const SizedBox(width: 36, height: 36);
    }

    final isSelected = _isSameDay(date, _selectedDate);
    final isToday = _isToday(date);
    final isDisabled = date.isBefore(widget.firstDate) || date.isAfter(widget.lastDate);

    return InkWell(
      onTap: isDisabled ? null : () => _selectDate(date),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected
              ? _accentColor
              : isToday
                  ? _accentColor.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: _accentColor, width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
              color: isDisabled
                  ? _mutedColor.withValues(alpha: 0.5)
                  : isSelected
                      ? Colors.white
                      : _textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: _mutedColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selectedDate),
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Select'),
        ),
      ],
    );
  }

  void _showMonthYearPicker() {
    showDialog(
      context: context,
      builder: (context) => _MonthYearPickerDialog(
        selectedDate: _displayedMonth,
        isDarkTheme: widget.isDarkTheme,
        onSelect: (date) {
          setState(() {
            _displayedMonth = date;
          });
        },
      ),
    );
  }
}

// =============================================================================
// MONTH/YEAR PICKER DIALOG
// =============================================================================

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime selectedDate;
  final bool isDarkTheme;
  final ValueChanged<DateTime> onSelect;

  const _MonthYearPickerDialog({
    required this.selectedDate,
    required this.isDarkTheme,
    required this.onSelect,
  });

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedDate.year;
    _selectedMonth = widget.selectedDate.month;
  }

  Color get _bgColor => widget.isDarkTheme ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _textColor => widget.isDarkTheme ? Colors.white : Colors.black87;
  Color get _mutedColor => widget.isDarkTheme ? Colors.grey[600]! : Colors.grey[400]!;
  Color get _accentColor => widget.isDarkTheme ? const Color(0xFF64B5F6) : const Color(0xFF3B82F6);
  Color get _hoverColor => widget.isDarkTheme ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5);

  List<String> get _shortMonths => [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Year selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: _textColor),
                  onPressed: () => setState(() => _selectedYear--),
                ),
                Text(
                  _selectedYear.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: _textColor),
                  onPressed: () => setState(() => _selectedYear++),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Month grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                final isSelected = month == _selectedMonth;

                return InkWell(
                  onTap: () {
                    setState(() => _selectedMonth = month);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? _accentColor : _hoverColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _shortMonths[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.white : _textColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: _mutedColor),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    widget.onSelect(DateTime(_selectedYear, _selectedMonth));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
