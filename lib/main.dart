import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tde3/firebase_options.dart';
import 'firebase_api.dart';
import 'consult_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Top 10 Músicas do Artista',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseApi().initNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    return const ConsultApi();
  }
}
