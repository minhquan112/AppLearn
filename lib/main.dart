import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/common/constant.dart';
import 'package:learning_app/features/home/HomeProvider.dart';
import 'package:learning_app/features/screen2/Screen2Provider.dart';
import 'package:learning_app/features/screen3/Screen3Provider.dart';
import 'package:learning_app/main_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  Widget build(BuildContext context) {
    Constants.screenHeight = MediaQuery.of(context).size.height;
    Constants.screenWidth = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => Screen2Provider()),
        ChangeNotifierProvider(create: (context) => Screen3Provider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Learning App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MainScreen(),
      ),
    );
  }
}
