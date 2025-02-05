Firebase Flutter Learning Project 

This project is designed to help you learn how to integrate Firebase with Flutter, focusing on Android. It covers Firebase Authentication, Firestore, Firebase Cloud Storage, and Push Notifications.

Getting Started

Prerequisites
To get started with this project, you need to have the following installed:

Flutter SDK
Firebase Account
Firebase CLI
Setup Firebase for Android
Go to the Firebase Console.
Create a new Firebase project.
Add an Android app to your Firebase project.
Follow the instructions to download the google-services.json file and add it to your Flutter project.
For Android:

Place google-services.json in the android/app directory.
Modify android/build.gradle and android/app/build.gradle according to Firebase setup instructions.
Install Dependencies
Clone the repository:
git clone https://github.com/vicky-prog/flutter_firebase_example.git
cd flutter_firebase_example
Install the required dependencies:
flutter pub get
Firebase Modules Integrated
Firebase Authentication: Learn how to sign in, sign up, and manage users.
Firestore Database: Store and retrieve data in Firestore.
Firebase Cloud Storage: Upload and download files such as images or videos.
Firebase Cloud Messaging (Push Notifications): Receive push notifications from Firebase Cloud Messaging (FCM).
Running the App
To run the app on your Android device or emulator, execute:

flutter run
Firebase Features Covered
Firebase Authentication:
Email and Password Authentication
Google Authentication
Facebook Authentication
Firestore:
CRUD operations in Firestore
Real-time updates
Firebase Cloud Storage:
Upload and download images
Firebase Cloud Messaging (Push Notifications):
Setup and configure Firebase Cloud Messaging (FCM) in your app.
Handle foreground and background push notifications.
Send notifications to your app from Firebase Console.
