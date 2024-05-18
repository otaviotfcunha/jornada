import 'package:flutter/material.dart';
import 'package:jornada/pages/carregamento_page.dart';
import 'package:jornada/shared/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: ColorsApp.primaryColor(),
        ),
      ),
      home: const CarregamentoPage(),
    );
  }
}
