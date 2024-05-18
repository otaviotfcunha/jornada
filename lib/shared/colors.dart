import 'package:flutter/material.dart';

enum Estacao { INVERNO, PRIMAVERA, VERAO, OUTONO }

class EstacaoUtil {
  static Estacao identificarEstacao() {
    final agora = DateTime.now();
    final mes = agora.month;

    if (mes >= 3 && mes <= 5) {
      return Estacao.OUTONO;
    } else if (mes >= 6 && mes <= 8) {
      return Estacao.INVERNO;
    } else if (mes >= 9 && mes <= 11) {
      return Estacao.PRIMAVERA;
    } else {
      return Estacao.VERAO;
    }
  }
}

class ColorsApp {
  static Color primaryColor() {
    Estacao estacao = EstacaoUtil.identificarEstacao();
    switch (estacao) {
      case Estacao.INVERNO:
        return const Color.fromRGBO(178, 241, 255, 1);
      case Estacao.VERAO:
        return const Color.fromRGBO(255, 150, 150, 1);
      case Estacao.OUTONO:
        return const Color.fromRGBO(255, 255, 200, 1);
      case Estacao.PRIMAVERA:
        return const Color.fromRGBO(255, 150, 255, 1);
      default:
        return const Color.fromRGBO(178, 241, 255, 1);
    }
  }

  static Color backgroundColor() {
    Estacao estacao = EstacaoUtil.identificarEstacao();
    switch (estacao) {
      case Estacao.INVERNO:
        return const Color.fromRGBO(217, 217, 217, 1);
      case Estacao.VERAO:
        return const Color.fromRGBO(217, 217, 217, 1);
      case Estacao.OUTONO:
        return const Color.fromRGBO(217, 217, 217, 1);
      case Estacao.PRIMAVERA:
        return const Color.fromRGBO(217, 217, 217, 1);
      default:
        return const Color.fromRGBO(217, 217, 217, 1); // Cor padrão para as outras estações
    }
  }

  static Color secondaryColor() {
    Estacao estacao = EstacaoUtil.identificarEstacao();
    switch (estacao) {
      case Estacao.INVERNO:
        return const Color.fromRGBO(0, 183, 223, 1);
      case Estacao.VERAO:
        return const Color.fromRGBO(223, 110, 0, 1);
      case Estacao.OUTONO:
        return const Color.fromRGBO(223, 183, 0, 1);
      case Estacao.PRIMAVERA:
        return const Color.fromRGBO(200, 0, 223, 1);
      default:
        return const Color.fromRGBO(0, 183, 223, 1); // Cor padrão para as outras estações
    }
  }

  static Color accentColor() {
    Estacao estacao = EstacaoUtil.identificarEstacao();
    switch (estacao) {
      case Estacao.INVERNO:
        return const Color.fromRGBO(0, 95, 183, 1);
      case Estacao.VERAO:
        return const Color.fromRGBO(255, 0, 0, 1);
      case Estacao.OUTONO:
        return const Color.fromRGBO(255, 187, 0, 1);
      case Estacao.PRIMAVERA:
        return const Color.fromRGBO(119, 1, 133, 1);
      default:
        return const Color.fromRGBO(0, 95, 183, 1); // Cor padrão para as outras estações
    }
  }

  static const Color textColorBlack = Colors.black;
  static const Color textColor = Colors.white;
  static const Color textDourado = Color.fromRGBO(218, 165, 32, 1);
}
