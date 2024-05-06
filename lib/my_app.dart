import 'package:flutter/material.dart';
import 'package:jornada/pages/carregamento_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
        ),
      ),
      home: const CarregamentoPage(),
    );
  }
}
