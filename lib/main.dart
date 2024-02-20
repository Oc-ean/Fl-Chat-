import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chat/view_model/providers/auth_provider.dart';
import 'package:fl_chat/view_model/providers/message_provider.dart';
import 'package:fl_chat/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_life_cycle.dart';
import 'constants/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Init HiveDB
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () => FirebaseService.userActiveStatus(false),
        resumeCallBack: () => FirebaseService.userActiveStatus(true),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthModelProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
