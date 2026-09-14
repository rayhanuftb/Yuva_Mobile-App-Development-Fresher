class AppConstants {
  static const String appName = 'EduTask';
  static const String appSubtitle = 'Student Task & Assignment Manager';
  static const String splashEmoji = '🎓';

  static const String storageKeyTasks = 'edutask_tasks';
  static const String storageKeyTheme = 'edutask_theme_mode';

  static const List<String> priorityValues = ['High', 'Medium', 'Low'];
  static const String defaultPriority = 'Medium';

  static const int taskTitleMinLength = 3;
  static const int taskDescriptionMaxLength = 500;

  static const String statusPending = 'Pending';
  static const String statusCompleted = 'Completed';
  static const String statusOverdue = 'Overdue';

  static const String dateFormat = 'dd MMM yyyy';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';
}
