Cross-Platform Firebase Flutter Project

This project is designed to help you learn how to integrate Firebase with Flutter, focusing on Android development while also supporting iOS and Web platforms. It covers Firebase Authentication, Firestore, Firebase Cloud Storage, and Push Notifications. The project also serves as a platform for building new skills and habits, with AI assistance, while working towards career goals in the tech industry.

The aim is to keep coding and developing hands-on projects until you land a job in the field.

Getting Started

Prerequisites
To get started with this project, you need to have the following installed:

Flutter SDK
Firebase Account
Firebase CLI
Firebase Setup
Firebase for Android, iOS, and Web

Go to the Firebase Console.
Create a new Firebase project.
Add Android, iOS, and Web apps to your Firebase project.
Download the necessary configuration files:
For Android, place the google-services.json file in the android/app directory.
For iOS, place the GoogleService-Info.plist in the ios/Runner directory.
For Web, use the Firebase web configuration snippet in your project.
For Android-specific setup:

Modify android/build.gradle and android/app/build.gradle according to Firebase setup instructions.
Install Dependencies
Clone the repository and install the required dependencies:

git clone https://github.com/vicky-prog/flutter_firebase_example.git
cd flutter_firebase_example
flutter pub get
Firebase Features Integrated
Firebase Authentication:
Email and Password Authentication
Google Authentication
Facebook Authentication
Firestore:
CRUD (Create, Read, Update, Delete) operations
Real-time data synchronization
Firebase Cloud Storage:
Upload and download images and videos
Firebase Cloud Messaging (Push Notifications):
Setup and configure FCM
Handle foreground and background notifications
Send notifications from the Firebase Console
Running the App
To run the app on Android, iOS, or Web:

For Android:

flutter run --target-platform android
For iOS:

flutter run --target-platform ios
For Web:

flutter run -d chrome
Project Goals

This project is a hands-on way to build the following skills:

Learning Firebase with Flutter: Understanding and implementing Firebase features in a real-world project.
Developing New Habits: Coding regularly to establish a productive learning routine.
AI-Assisted Learning: Using AI tools to aid in your learning journey, especially focusing on Large Language Models (LLMs) for future tech insights.
Continuous Learning: The project serves as a platform to keep coding and developing until securing a job in the field.
Future Learning Plans

Along with Firebase and Flutter, the following are areas of focus:

Learning about Large Language Models (LLMs) to explore the AI domain and its potential applications.
Constantly updating your coding skills and habits, and adapting to new trends in technology.
Feel free to contribute, ask questions, and share any improvements. Keep coding, and let's learn together!
