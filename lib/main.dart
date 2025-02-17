import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_example/config/dependencies.dart';
import 'package:flutter_firebase_example/core/utils/screen_utils.dart';
import 'package:flutter_firebase_example/data/services/firebase_service.dart';
import 'package:flutter_firebase_example/data/services/push_notification_service.dart';
import 'package:flutter_firebase_example/presentation/pages/home_page.dart';
import 'package:flutter_firebase_example/presentation/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  runApp(MultiBlocProvider(providers: getBlocProviders(), child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     // Initialize screen utilities (only needs to be done once)
    ScreenUtils.init(context);
    return MaterialApp(
     // showPerformanceOverlay: true,
      title: 'Skill Mentor',
      //theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: AuthStateHandler(),
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        } else if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
