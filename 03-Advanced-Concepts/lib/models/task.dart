import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Task {
  final String id;
  String title;
  String description;
  DateTime dueDate;
  String priority;
  bool isCompleted;
  DateTime createdAt;

  Task({
    String? id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = 'Medium',
    this.isCompleted = false,
    DateTime? createdAt,
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now();

  String get status {
    if (isCompleted) return 'Completed';
    if (dueDate.isBefore(DateTime.now())) return 'Overdue';
    return 'Pending';
  }

  bool get isOverdue => !isCompleted && dueDate.isBefore(DateTime.now());

  String get formattedDueDate {
    return '${dueDate.day.toString().padLeft(2, '0')} '
        '${_monthName(dueDate.month)} '
        '${dueDate.year}';
  }

  static String _monthName(int month) {
    const names = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[month];
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: json['priority'] as String? ?? 'Medium',
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
