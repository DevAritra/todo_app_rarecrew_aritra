# Flutter TODO App with Firebase by Aritra

A responsive and scalable TODO application built with Flutter, Firebase, and the MVVM architecture using Provider for state management. The application supports real-time task collaboration through email-based task sharing and role-based access.

---

## 🔐 Demo Credentials

You can log in using any of the following test accounts:

| Email                     | Password    |
|--------------------------|-------------|
| user1@mailinator.com     | Test@1234   |
| user2@mailinator.com     | Test@1234   |
| user3@mailinator.com     | Test@1234   |
| user4@mailinator.com     | Test@1234   |

---

## Features

- Firebase Authentication (Email/Password)
- Cloud Firestore for real-time data updates
- MVVM architecture using Provider
- Role-based task sharing (owner vs viewer)
- Responsive design with `responsive_sizer`
- Intuitive and clean user interface
- Display customization based on task ownership:
    - Owner sees: `Shared with:`
    - Shared user sees: `Shared by:`
- Each task includes a creation timestamp

---

## 🧠 Architecture

- **Model**: `TaskModel`
- **ViewModel**: `TaskViewModel`, `AuthViewModel`
- **Service Layer**: Firebase operations (FirestoreService)
- **UI**: Separated views and dialogs, responsive layout

---

## 📋 Task Permissions & Behavior

- **Owners** can:
  - Edit/delete the task
  - Share/unshare with other emails
  - Mark task as done/undone

- **Shared Users** can:
  - View task details
  - Mark task as done/undone ✅ ❌

> 🔄 Any user with access to a task can update its "Done" status by checking/unchecking a checkbox.

---

## Tech Stack

| Technology         | Usage                                      |
|--------------------|--------------------------------------------|
| **Flutter 3.24.5** | Core mobile development framework          |
| **Dart 3.5.4**     | Language used with Flutter                 |
| Firebase Auth      | User authentication                       |
| Cloud Firestore    | Real-time database                         |
| Provider           | State management                           |
| responsive_sizer   | Responsive layout for multiple devices     |
| MVVM Pattern       | Maintainable and testable code structure   |


---

### Prerequisites

- Flutter SDK installed (version 3.24.5)

### How It Works

- Users sign in using email and password

- Each user can create and manage tasks

- Tasks can be shared with others via email

- Task sharing is real-time and role-based:

- Only the task owner can modify the shared user list

- Shared users can view but not edit sharing permissions

- UI dynamically adapts to screen size and ownership context

## Author

- Linkedin [@aritraadhikary](https://www.linkedin.com/in/aritraadhikary)
- Email: [aritra.adhikary@yahoo.com](aritra.adhikary@yahoo.com)


