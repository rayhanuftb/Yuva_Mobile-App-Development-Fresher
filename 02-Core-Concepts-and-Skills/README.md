# 🎓 Student Management System (No Database)

A simple, beginner-friendly **console-based Student Management System** built with pure Python.
No database is required — all student records are stored in a local `students.json` file.

## 🧰 Built With

- 🐍 Python 3
- 📋 Lists
- 📖 Dictionaries
- 💾 JSON file handling (`json` module)
- 🔄 Functions & Loops
- ⚖️ Conditional logic
- 🛡️ Input validation

## ✨ Features

| Feature | Description |
|---|---|
| ➕ Add Student | Add a new student with ID, name, age, grade, and email (all validated) |
| 📋 View Students | Display all students in a neat table |
| 🔍 Search Student | Search by ID or by (partial) name |
| ✏️ Update Student | Edit any field of an existing student, leaving blank to keep current value |
| 🗑️ Delete Student | Remove a student record, with a confirmation prompt |
| 🛡️ Input Validation | Prevents duplicate IDs, invalid ages, empty names, malformed emails, etc. |
| 💾 JSON Persistence | Data is automatically saved to and loaded from `students.json` |

## 📁 Project Structure

```
student-management-system/
│
├── main.py           # Main application (run this file)
├── students.json     # Auto-created/updated data storage
└── README.md          # Project documentation
```

## ▶️ How to Run

1. Make sure Python 3.7+ is installed.
2. Open a terminal in the project folder.
3. Run:

   ```bash
   python main.py
   ```

4. Use the on-screen menu to manage students:

   ```
   1. ➕ Add Student
   2. 📋 View Students
   3. 🔍 Search Student
   4. ✏️  Update Student
   5. 🗑️  Delete Student
   6. 🚪 Exit
   ```

## 💾 Data Storage Format

Each student is stored as a JSON object inside `students.json`, for example:

```json
[
    {
        "id": 1,
        "name": "John Smith",
        "age": 20,
        "grade": "A",
        "email": "john.smith@example.com"
    }
]
```

## 🔧 Possible Extensions

- Export student list to CSV or PDF
- Add subjects and grade-point calculations
- Build a GUI using Tkinter or a web interface using Flask
- Replace JSON storage with SQLite for larger datasets

## 📄 License

Free to use and modify for learning purposes.
