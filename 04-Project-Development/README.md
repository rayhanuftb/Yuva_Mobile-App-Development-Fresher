# EduTask

**Student Task & Assignment Manager**

A modern, clean, and fully functional Flutter mobile application designed for students to manage academic tasks and assignments.

---

## Overview

EduTask helps students stay organized by managing their academic tasks and assignments in one place. The app is fully offline-capable, storing all data locally on the device using SharedPreferences.

## Features

- **Add Tasks** - Create new tasks with title, description, due date, and priority
- **View Tasks** - See all your tasks in a clean, organized list
- **Edit Tasks** - Modify existing task details
- **Delete Tasks** - Remove tasks with confirmation
- **Mark Complete** - Toggle task completion status with a single tap
- **Search** - Find tasks by title or description
- **Filter** - View All, Pending, or Completed tasks
- **Priority Levels** - High (Red), Medium (Orange), Low (Green)
- **Due Date** - Set and track due dates for each task
- **Overdue Detection** - Automatically identifies overdue tasks
- **Dark Mode** - Switch between Light, Dark, and System Default themes
- **Offline Storage** - All data persists locally using SharedPreferences
- **Task Summary** - View Total, Completed, and Pending task counts

## Screenshots

```
screenshots/
├── splash.png
├── home_light.png
├── home_dark.png
├── add_task.png
├── edit_task.png
├── task_card.png
└── empty_state.png
```

## Technology Stack

| Technology | Purpose |
|------------|---------|
| Flutter | UI Framework |
| Dart | Programming Language |
| Material Design 3 | Design System |
| SharedPreferences | Local Storage |
| intl | Date Formatting |
| uuid | Unique ID Generation |

## Installation

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio or VS Code
- Android Emulator or Physical Device

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/edutask.git
   ```

2. **Navigate to project directory**
   ```bash
   cd edutask
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## Project Structure

```
edutask/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── task.dart             # Task data model
│   ├── screens/
│   │   ├── splash_screen.dart    # Splash screen
│   │   ├── home_screen.dart      # Main home screen
│   │   └── task_form_screen.dart # Add/Edit task screen
│   ├── services/
│   │   └── storage_service.dart  # SharedPreferences service
│   ├── widgets/
│   │   ├── task_card.dart        # Task card widget
│   │   └── empty_task_widget.dart # Empty state widget
│   └── utils/
│       ├── app_theme.dart        # Theme definitions
│       └── constants.dart        # App constants
├── assets/
│   └── images/
├── README.md
└── pubspec.yaml
```

## Data Storage

EduTask uses **SharedPreferences** for local persistent storage:

- All tasks are stored as JSON strings
- Task data is automatically saved when tasks are created, updated, or deleted
- Data persists across app restarts
- No internet connection required
- No Firebase or cloud services

### Storage Format

```json
[
  {
    "id": "uuid-string",
    "title": "Complete Flutter Project",
    "description": "Build the internship project",
    "dueDate": "2026-09-20T00:00:00.000",
    "priority": "High",
    "isCompleted": false,
    "createdAt": "2026-09-14T10:30:00.000"
  }
]
```

## Testing

### Test Scenarios

| Test | Description | Expected Result |
|------|-------------|-----------------|
| 1. Add Task | Create a new task with all fields | Task appears in list |
| 2. Restart App | Close and reopen the app | Tasks remain saved |
| 3. Edit Task | Modify task details | Changes appear immediately |
| 4. Delete Task | Remove a task | Task is removed from list |
| 5. Mark Complete | Toggle task completion | Status updates correctly |
| 6. Search | Search for tasks | Correct tasks are displayed |
| 7. Overdue | Task with past due date | Task marked as overdue |
| 8. Theme | Switch between themes | Theme changes correctly |

### Manual Testing Steps

1. **Add Task Test**
   - Tap "Add Task" button
   - Fill in title, description, due date, priority
   - Tap "SAVE TASK"
   - Verify task appears in list

2. **Persistence Test**
   - Add a task
   - Close the app completely
   - Reopen the app
   - Verify task still exists

3. **Edit Task Test**
   - Tap on a task card
   - Modify the title or description
   - Tap "UPDATE TASK"
   - Verify changes are reflected

4. **Delete Task Test**
   - Tap the delete icon on a task
   - Confirm deletion in dialog
   - Verify task is removed

5. **Completion Test**
   - Tap the checkbox on a task
   - Verify status changes to "Completed"
   - Verify completed count increases

6. **Search Test**
   - Tap the search icon
   - Type a task title
   - Verify matching tasks are shown

7. **Overdue Test**
   - Create a task with yesterday's date
   - Verify it shows "Overdue" badge
   - Complete the task
   - Verify overdue badge disappears

8. **Theme Test**
   - Tap settings icon
   - Select "Theme"
   - Switch between Light/Dark/System
   - Verify theme changes throughout app

## Architecture

### State Management

- Uses Flutter's built-in `StatefulWidget` and `setState()`
- `ValueNotifier` for theme mode propagation
- Clean and simple for the app's scope

### Design Patterns

- **Separation of Concerns**: Models, Services, Screens, Widgets, Utils
- **Single Responsibility**: Each file has one clear purpose
- **DRY Principle**: Reusable widgets and constants

## Future Improvements

- [ ] Push notifications for due dates
- [ ] Task categories/tags
- [ ] Calendar view
- [ ] Recurring tasks
- [ ] Cloud backup/restore
- [ ] User authentication
- [ ] Subtasks/checklists
- [ ] Task attachments
- [ ] Export to CSV/PDF
- [ ] Widgets for home screen

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Material Design 3 for the design system
- The open-source community for packages used
