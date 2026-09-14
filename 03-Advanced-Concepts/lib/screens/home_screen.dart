import 'package:flutter/material.dart';
import '../main.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/task_card.dart';
import '../widgets/empty_task_widget.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Task> _allTasks = [];
  String _filterType = 'All';
  String _searchQuery = '';
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  /// Drives the staggered entrance animation for the summary cards and
  /// the task list whenever the data is (re)loaded.
  late final AnimationController _entranceController;

  static const List<_FilterOption> _filterOptions = [
    _FilterOption('All', Icons.apps_rounded),
    _FilterOption('Pending', Icons.pending_actions_rounded),
    _FilterOption('Completed', Icons.check_circle_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _loadTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final tasks = await StorageService.loadTasks();
    if (mounted) {
      setState(() {
        _allTasks = tasks;
        _isLoading = false;
      });
      _entranceController.forward(from: 0);
    }
  }

  List<Task> get _filteredTasks {
    var tasks = List<Task>.from(_allTasks);

    switch (_filterType) {
      case 'Pending':
        tasks = tasks.where((t) => !t.isCompleted).toList();
        break;
      case 'Completed':
        tasks = tasks.where((t) => t.isCompleted).toList();
        break;
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      tasks = tasks.where((task) {
        return task.title.toLowerCase().contains(query) ||
            task.description.toLowerCase().contains(query);
      }).toList();
    }

    tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.dueDate.compareTo(b.dueDate);
    });

    return tasks;
  }

  int get _totalCount => _allTasks.length;
  int get _completedCount => _allTasks.where((t) => t.isCompleted).length;
  int get _pendingCount => _allTasks.where((t) => !t.isCompleted).length;

  Future<void> _navigateToAddTask() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TaskFormScreen()),
    );
    if (result == true) _loadTasks();
  }

  Future<void> _navigateToEditTask(Task task) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
    );
    if (result == true) _loadTasks();
  }

  Future<void> _toggleComplete(Task task) async {
    await StorageService.toggleTaskComplete(task.id);
    _loadTasks();
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.overdueColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await StorageService.deleteTask(task.id);
      _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted successfully!')),
        );
      }
    }
  }

  void _showThemeDialog() {
    final currentMode = StorageService.getThemeMode();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _themeOption('System Default', ThemeMode.system, currentMode),
            _themeOption('Light Mode', ThemeMode.light, currentMode),
            _themeOption('Dark Mode', ThemeMode.dark, currentMode),
          ],
        ),
      ),
    );
  }

  Widget _themeOption(String label, ThemeMode mode, ThemeMode current) {
    return RadioGroup<ThemeMode>(
      groupValue: current,
      onChanged: (value) async {
        if (value != null) {
          await StorageService.setThemeMode(value);
          themeNotifier.value = value;
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: RadioListTile<ThemeMode>(
        title: Text(label),
        value: mode,
      ),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  /// Wraps [child] with a fade + rise-in transition, staggered by [index]
  /// against the shared [_entranceController]. Gives lists and card rows
  /// a lively, cascading appearance instead of popping in all at once.
  Widget _staggeredEntrance({
    required int index,
    required Widget child,
    double perItem = 0.08,
    double span = 0.55,
  }) {
    final cappedIndex = index.clamp(0, 8);
    final start = (cappedIndex * perItem).clamp(0.0, 1.0);
    final end = (start + span).clamp(start, 1.0);
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - animation.value) * 18),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final tasks = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: AppTheme.animFast,
          child: _isSearching
              ? TextField(
            key: const ValueKey('search'),
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search tasks...',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          )
              : Column(
            key: const ValueKey('title'),
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.brandGradient(dark: isDark).createShader(bounds),
                child: const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'Student Task Manager',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: AppTheme.animFast,
              transitionBuilder: (child, animation) =>
                  RotationTransition(turns: animation, child: child),
              child: Icon(
                _isSearching ? Icons.close : Icons.search,
                key: ValueKey(_isSearching),
              ),
            ),
            onPressed: _toggleSearch,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings_outlined),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            onSelected: (value) {
              if (value == 'theme') _showThemeDialog();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(Icons.dark_mode_outlined),
                    SizedBox(width: AppTheme.spaceSm),
                    Text('Theme'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: AppTheme.brandGradient(dark: isDark),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: AppTheme.animMedium,
        switchInCurve: AppTheme.animCurve,
        child: _isLoading
            ? const Center(
          key: ValueKey('loading'),
          child: CircularProgressIndicator(),
        )
            : RefreshIndicator(
          key: const ValueKey('content'),
          onRefresh: _loadTasks,
          child: Column(
            children: [
              _buildSummaryCards(colorScheme),
              _buildFilterChips(colorScheme),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppTheme.animMedium,
                  switchInCurve: AppTheme.animCurve,
                  child: KeyedSubtree(
                    key: ValueKey('$_filterType-$_searchQuery-${tasks.isEmpty}'),
                    child: tasks.isEmpty
                        ? _buildEmptyState()
                        : _buildTaskList(tasks),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _GradientFab(
        onPressed: _navigateToAddTask,
        isDark: isDark,
      ),
    );
  }

  Widget _buildSummaryCards(ColorScheme colorScheme) {
    final cards = [
      _SummaryCard(
        title: 'Total',
        count: _totalCount,
        color: colorScheme.primary,
        icon: Icons.list_alt_rounded,
      ),
      _SummaryCard(
        title: 'Completed',
        count: _completedCount,
        color: AppTheme.completedColor,
        icon: Icons.check_circle_outline_rounded,
      ),
      _SummaryCard(
        title: 'Pending',
        count: _pendingCount,
        color: AppTheme.mediumPriorityColor,
        icon: Icons.pending_actions_rounded,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spaceMd,
        AppTheme.spaceSm,
        AppTheme.spaceMd,
        AppTheme.spaceXs,
      ),
      child: Row(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: AppTheme.spaceSm),
            Expanded(
              child: _staggeredEntrance(index: i, child: cards[i]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChips(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMd,
        vertical: AppTheme.spaceSm,
      ),
      child: Row(
        children: _filterOptions.map((option) {
          final isSelected = _filterType == option.label;
          return Padding(
            padding: const EdgeInsets.only(right: AppTheme.spaceSm),
            child: FilterChip(
              avatar: Icon(
                option.icon,
                size: 18,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              label: Text(option.label),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _filterType = option.label);
              },
              selectedColor: colorScheme.primaryContainer,
              checkmarkColor: colorScheme.primary,
              elevation: isSelected ? 2 : 0,
              pressElevation: 4,
              shadowColor: colorScheme.primary.withValues(alpha: 0.35),
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.4)
                      : colorScheme.outline.withValues(alpha: 0.25),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    switch (_filterType) {
      case 'Pending':
        return const EmptyTaskWidget(
          emoji: '🎉',
          title: 'All Done!',
          subtitle: 'You have completed all your tasks. Great job!',
        );
      case 'Completed':
        return const EmptyTaskWidget(
          emoji: '📋',
          title: 'No Completed Tasks',
          subtitle: 'Start completing tasks to see them here.',
        );
      default:
        if (_searchQuery.isNotEmpty) {
          return EmptyTaskWidget(
            emoji: '🔍',
            title: 'No Results',
            subtitle: 'No tasks match "$_searchQuery"',
            buttonText: null,
            onButtonPressed: null,
          );
        }
        return EmptyTaskWidget(
          onButtonPressed: _navigateToAddTask,
        );
    }
  }

  Widget _buildTaskList(List<Task> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _staggeredEntrance(
          index: index,
          child: TaskCard(
            task: task,
            onToggleComplete: () => _toggleComplete(task),
            onEdit: () => _navigateToEditTask(task),
            onDelete: () => _deleteTask(task),
          ),
        );
      },
    );
  }
}

class _FilterOption {
  final String label;
  final IconData icon;
  const _FilterOption(this.label, this.icon);
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceSm,
        vertical: AppTheme.spaceMd - 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.22 : 0.14),
            color.withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: AppTheme.spaceXs + 2),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}

/// A floating action button with the app's brand gradient instead of a
/// flat fill, giving the primary call-to-action more visual weight.
class _GradientFab extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isDark;

  const _GradientFab({required this.onPressed, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.brandGradient(dark: isDark),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.softShadow(dark: isDark),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Colors.white),
                SizedBox(width: AppTheme.spaceXs + 4),
                Text(
                  'Add Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}