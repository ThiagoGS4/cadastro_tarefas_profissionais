import 'package:flutter/material.dart';
import 'package:cadastro_tarefas_profissionais/screens/home.dart';

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
          primaryContainer: Colors.indigoAccent,
          onPrimaryContainer: Colors.white,
          secondary: Colors.black87,
          onSecondary: Colors.white,
          secondaryContainer: const Color.fromARGB(255, 46, 46, 46),
          error: Colors.pink,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87
        )
      ),
      home: const Home(),
      );
  }
}
//Trocar pelo desejado
//color: Theme.of(context).colorScheme.//Primary//,
