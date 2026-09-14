"""
Student Management System
--------------------------
A simple console-based Student Management System built with Python.
No database is used — all data is stored in a JSON file (students.json).

Features:
    1. Add Student
    2. View Students
    3. Search Student
    4. Update Student
    5. Delete Student
    6. Input Validation
    7. Save/Load Data using JSON
"""

import json
import os

DATA_FILE = "students.json"


# ----------------------------------------------------------------------
# File Handling Functions
# ----------------------------------------------------------------------

def load_data():
    """Load student data from the JSON file. Returns an empty list if the
    file doesn't exist or is empty/corrupted."""
    if not os.path.exists(DATA_FILE):
        return []

    try:
        with open(DATA_FILE, "r", encoding="utf-8") as f:
            content = f.read().strip()
            if not content:
                return []
            return json.loads(content)
    except (json.JSONDecodeError, IOError):
        print("⚠️  Warning: Could not read data file. Starting with an empty list.")
        return []


def save_data(students):
    """Save the list of student dictionaries to the JSON file."""
    try:
        with open(DATA_FILE, "w", encoding="utf-8") as f:
            json.dump(students, f, indent=4, ensure_ascii=False)
    except IOError as e:
        print(f"❌ Error saving data: {e}")


# ----------------------------------------------------------------------
# Validation Helpers
# ----------------------------------------------------------------------

def get_valid_id(students, prompt="Enter Student ID: "):
    """Ask for an ID and make sure it's a positive integer."""
    while True:
        value = input(prompt).strip()
        if not value.isdigit():
            print("⚠️  ID must be a positive number. Try again.")
            continue
        return int(value)


def get_unique_id(students, prompt="Enter Student ID: "):
    """Ask for an ID that does not already exist in the records."""
    while True:
        student_id = get_valid_id(students, prompt)
        if find_student_by_id(students, student_id) is not None:
            print("⚠️  This ID already exists. Please enter a different ID.")
            continue
        return student_id


def get_valid_name(prompt="Enter Name: "):
    """Ask for a name and make sure it only has letters/spaces and isn't empty."""
    while True:
        name = input(prompt).strip()
        if not name:
            print("⚠️  Name cannot be empty. Try again.")
            continue
        if not all(part.isalpha() for part in name.split()):
            print("⚠️  Name should only contain letters and spaces. Try again.")
            continue
        return name.title()


def get_valid_age(prompt="Enter Age: "):
    """Ask for an age and validate it's a realistic integer."""
    while True:
        value = input(prompt).strip()
        if not value.isdigit():
            print("⚠️  Age must be a number. Try again.")
            continue
        age = int(value)
        if age < 4 or age > 100:
            print("⚠️  Please enter a realistic age (4-100). Try again.")
            continue
        return age


def get_valid_grade(prompt="Enter Grade/Class: "):
    """Ask for a grade/class label, ensuring it isn't empty."""
    while True:
        grade = input(prompt).strip()
        if not grade:
            print("⚠️  Grade cannot be empty. Try again.")
            continue
        return grade.upper()


def get_valid_email(prompt="Enter Email: "):
    """Ask for an email and do a light-weight format check."""
    while True:
        email = input(prompt).strip()
        if "@" not in email or "." not in email.split("@")[-1] or " " in email:
            print("⚠️  Please enter a valid email address (e.g. name@example.com).")
            continue
        return email.lower()


def get_yes_no(prompt):
    """Ask a yes/no question and return True/False."""
    while True:
        answer = input(f"{prompt} (y/n): ").strip().lower()
        if answer in ("y", "yes"):
            return True
        if answer in ("n", "no"):
            return False
        print("⚠️  Please answer with 'y' or 'n'.")


# ----------------------------------------------------------------------
# Core Logic
# ----------------------------------------------------------------------

def find_student_by_id(students, student_id):
    """Return the student dict matching the given ID, or None."""
    for student in students:
        if student["id"] == student_id:
            return student
    return None


def add_student(students):
    """Add a new student record after collecting validated input."""
    print("\n--- ➕ Add New Student ---")
    student_id = get_unique_id(students)
    name = get_valid_name()
    age = get_valid_age()
    grade = get_valid_grade()
    email = get_valid_email()

    student = {
        "id": student_id,
        "name": name,
        "age": age,
        "grade": grade,
        "email": email,
    }

    students.append(student)
    save_data(students)
    print(f"✅ Student '{name}' added successfully!\n")


def view_students(students):
    """Display all student records in a formatted table."""
    print("\n--- 📋 All Students ---")
    if not students:
        print("No student records found.\n")
        return

    header = f'{"ID":<6}{"Name":<20}{"Age":<6}{"Grade":<10}{"Email":<25}'
    print(header)
    print("-" * len(header))
    for student in sorted(students, key=lambda s: s["id"]):
        print(
            f'{student["id"]:<6}{student["name"]:<20}{student["age"]:<6}'
            f'{student["grade"]:<10}{student["email"]:<25}'
        )
    print(f"\nTotal Students: {len(students)}\n")


def search_student(students):
    """Search for a student by ID or by (partial) name."""
    print("\n--- 🔍 Search Student ---")
    print("1. Search by ID")
    print("2. Search by Name")
    choice = input("Choose an option (1-2): ").strip()

    results = []
    if choice == "1":
        student_id = get_valid_id(students)
        student = find_student_by_id(students, student_id)
        if student:
            results = [student]
    elif choice == "2":
        keyword = input("Enter name (or part of it): ").strip().lower()
        results = [s for s in students if keyword in s["name"].lower()]
    else:
        print("⚠️  Invalid option.\n")
        return

    if not results:
        print("❌ No matching student found.\n")
        return

    print(f"\nFound {len(results)} matching record(s):")
    for student in results:
        print(
            f'  ID: {student["id"]} | Name: {student["name"]} | '
            f'Age: {student["age"]} | Grade: {student["grade"]} | '
            f'Email: {student["email"]}'
        )
    print()


def update_student(students):
    """Update fields of an existing student record."""
    print("\n--- ✏️  Update Student ---")
    student_id = get_valid_id(students, "Enter the ID of the student to update: ")
    student = find_student_by_id(students, student_id)

    if not student:
        print("❌ No student found with that ID.\n")
        return

    print(f"Editing record: {student}")
    print("Leave a field blank to keep its current value.\n")

    new_name = input(f"Name [{student['name']}]: ").strip()
    if new_name:
        while not all(part.isalpha() for part in new_name.split()):
            print("⚠️  Name should only contain letters and spaces.")
            new_name = input(f"Name [{student['name']}]: ").strip()
        student["name"] = new_name.title()

    new_age = input(f"Age [{student['age']}]: ").strip()
    if new_age:
        while not (new_age.isdigit() and 4 <= int(new_age) <= 100):
            print("⚠️  Please enter a realistic age (4-100).")
            new_age = input(f"Age [{student['age']}]: ").strip()
        student["age"] = int(new_age)

    new_grade = input(f"Grade [{student['grade']}]: ").strip()
    if new_grade:
        student["grade"] = new_grade.upper()

    new_email = input(f"Email [{student['email']}]: ").strip()
    if new_email:
        while "@" not in new_email or "." not in new_email.split("@")[-1]:
            print("⚠️  Please enter a valid email address.")
            new_email = input(f"Email [{student['email']}]: ").strip()
        student["email"] = new_email.lower()

    save_data(students)
    print("✅ Student record updated successfully!\n")


def delete_student(students):
    """Delete a student record after confirmation."""
    print("\n--- 🗑️  Delete Student ---")
    student_id = get_valid_id(students, "Enter the ID of the student to delete: ")
    student = find_student_by_id(students, student_id)

    if not student:
        print("❌ No student found with that ID.\n")
        return

    print(f"Record to delete: {student}")
    if get_yes_no("Are you sure you want to delete this student?"):
        students.remove(student)
        save_data(students)
        print("✅ Student deleted successfully!\n")
    else:
        print("❎ Deletion cancelled.\n")


# ----------------------------------------------------------------------
# Menu / Program Entry Point
# ----------------------------------------------------------------------

def print_menu():
    print("=" * 40)
    print("   🎓 STUDENT MANAGEMENT SYSTEM")
    print("=" * 40)
    print("1. ➕ Add Student")
    print("2. 📋 View Students")
    print("3. 🔍 Search Student")
    print("4. ✏️  Update Student")
    print("5. 🗑️  Delete Student")
    print("6. 🚪 Exit")
    print("=" * 40)


def main():
    students = load_data()

    while True:
        print_menu()
        choice = input("Enter your choice (1-6): ").strip()

        if choice == "1":
            add_student(students)
        elif choice == "2":
            view_students(students)
        elif choice == "3":
            search_student(students)
        elif choice == "4":
            update_student(students)
        elif choice == "5":
            delete_student(students)
        elif choice == "6":
            print("\n👋 Thank you for using the Student Management System. Goodbye!")
            break
        else:
            print("⚠️  Invalid choice. Please select a number between 1 and 6.\n")


if __name__ == "__main__":
    main()
