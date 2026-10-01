
# EduTask -- Student Task Manager

A simple and user-friendly student task management mobile application
built with **Flutter** and **Dart**. EduTask helps students organize
academic tasks by adding tasks, setting due dates, selecting priorities,
and tracking task status.

## Features

-   Add academic tasks.
-   Enter a task title and description.
-   Select a due date.
-   Set task priority.
-   View total, completed, and pending task counts.
-   Filter tasks by All, Pending, and Completed.
-   Use a clean interface with light and dark themes.
-   Receive confirmation after successfully adding a task.

## Screenshots

### Dashboard -- Dark Theme

![EduTask Dashboard Dark](screenshots/dashboard_dark.png)

### Dashboard -- Light Theme

![EduTask Dashboard Light](screenshots/dashboard_light.png)

### Add New Task

![Add New Task](screenshots/add_task.png)

### Task Added Successfully

![Task Added](screenshots/task_added.png)

> Add your actual screenshots to the `screenshots/` folder using the
> filenames shown above.

## Technology Stack

-   **Framework:** Flutter
-   **Programming Language:** Dart
-   **Platform:** Android
-   **Version Control:** Git and GitHub

## Project Structure

``` text
EduTask/
├── android/
├── assets/
├── lib/
│   ├── models/
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── splash_screen.dart
│   │   └── task_form_screen.dart
│   ├── services/
│   │   └── storage_service.dart
│   ├── utils/
│   │   ├── app_theme.dart
│   │   └── constants.dart
│   ├── widgets/
│   └── main.dart
├── test/
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
├── .gitignore
└── README.md
```

> Keep only the files and folders that exist in your repository.

## Getting Started

### Prerequisites

-   Flutter SDK
-   Dart SDK (included with Flutter)
-   Android Studio or Visual Studio Code
-   Android emulator or a physical Android device

Check your Flutter installation:

``` bash
flutter doctor
```

### Installation

1.  Clone the repository:

    ``` bash
    git clone https://github.com/rayhanuftb/Yuva_Mobile-App-Development-Fresher
    ```

2.  Navigate to the project directory:

    ``` bash
    cd EduTask
    ```

3.  Install dependencies:

    ``` bash
    flutter pub get
    ```

4.  Run the application:

    ``` bash
    flutter run
    ```

## Build Android APK

To generate a release APK, run the following commands from the project
directory:

``` bash
flutter clean
flutter pub get
flutter analyze
flutter build apk --release
```

The generated APK is normally located at:

``` text
build/app/outputs/flutter-apk/app-release.apk
```

Install the APK on a compatible Android device to verify the release
build before distributing it.

## Testing

Suggested test scenarios include:

-   Launching the application.
-   Opening the Add New Task form.
-   Entering task details.
-   Selecting a due date and priority.
-   Saving a task.
-   Checking dashboard counters.
-   Filtering tasks by status.
-   Handling empty or unusually long input.
-   Installing and launching the release APK.

Record test outcomes only after performing the corresponding tests.

## Deployment

An Android release APK was generated using Flutter's release build
command. The APK can be shared through the GitHub **Releases** section.

If you publish a release, add its URL here.

## Internship Project Documentation

This project was developed as part of an internship program and covers:

-   **Practical Implementation:** Mobile application development using
    Flutter and Dart.
-   **Testing and Quality Assurance:** Test cases, functional testing,
    and debugging.
-   **Final Project and Assessment:** Project documentation and Android
    release preparation.

## Future Improvements

-   Task editing and deletion.
-   Improved input validation.
-   Task reminders and notifications.
-   Additional task organization options.
-   Automated unit and integration tests.

## Developer

**Your Name**

GitHub: [https://github.com/rayhan](https://github.com/rayhanuftb/Yuva_Mobile-App-Development-Fresher)

## License

This project was developed for educational and internship purposes.
