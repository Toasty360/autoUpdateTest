import 'package:auto_update_test/update.dart';
import 'package:flutter/material.dart';

const version = "v1.5";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkForUpdates();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dipshit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Home());
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "New version",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        child: const Center(
            child: Text(
          version,
          style: TextStyle(color: Colors.green),
        )),
      ),
    );
  }
}
