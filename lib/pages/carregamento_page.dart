import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:jornada/pages/home_page.dart';
import 'package:jornada/shared/widgets/app_images.dart';

class CarregamentoPage extends StatefulWidget {
  const CarregamentoPage({super.key});

  @override
  State<CarregamentoPage> createState() => _CarregamentoPageState();
}

class _CarregamentoPageState extends State<CarregamentoPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  carregarHome() async {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.blue,
              Colors.lightBlue,
              Colors.blueGrey,
            ],
                stops: [
              0.2,
              0.3,
              0.7,
            ])),
        child: Center(
          child: SizedBox(
            width: 250.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  Image.asset(
                    AppImages.logo_branco,
                    width: 200,
                  ),
                  AnimatedTextKit(
                    totalRepeatCount: 1,
                    repeatForever: false,
                    onFinished: () {
                      carregarHome();
                    },
                    animatedTexts: [
                      FadeAnimatedText('Seja bem vindo!'),
                      FadeAnimatedText('Estamos carregando tudo para você...'),
                    ],
                    onTap: () {
                      carregarHome();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
