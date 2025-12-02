import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Database demo app',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.indigo,
          onPrimary: Colors.white,
          secondary: Colors.black87,
          onSecondary: Colors.white,
          error: Colors.pink,
          onError: Colors.white,
          surface: Color.fromRGBO(82, 71, 97, 1),
          onSurface: Colors.white 
        )
      )
      );
  }
}
