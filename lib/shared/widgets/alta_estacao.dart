import 'package:flutter/material.dart';
import 'package:jornada/models/destino_estacao_model.dart';
import 'package:jornada/shared/colors.dart';
import 'package:jornada/pages/destino_page.dart';

class AltaEstacao extends StatefulWidget {
  final DestinosEstacaoModel estacao;
  final List<String> imagens;

  const AltaEstacao({
    super.key,
    required this.estacao,
    required this.imagens,
  });

  @override
  State<AltaEstacao> createState() => _AltaEstacaoState();
}

class _AltaEstacaoState extends State<AltaEstacao> {
  @override
  Widget build(BuildContext context) {
    if (widget.estacao.results.isEmpty || widget.imagens.isEmpty) {
      return const SizedBox(); // Retorna um widget vazio se as listas estiverem vazias
    }

    return Container(
      color: ColorsApp.primaryColor(),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Text(
            "Em alta para a estação:",
            style: TextStyle(
              color: ColorsApp.textColorBlack,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.estacao.results[0].estacao,
            style: TextStyle(
              color: ColorsApp.accentColor(),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DestinoPage(
                    searchText: widget.estacao.results[0].nome,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  Image(
                    image: NetworkImage(widget.imagens[0]),
                    width: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Text(
                      widget.estacao.results[0].nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 5
                          ..color = ColorsApp.primaryColor(),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Text(
                      widget.estacao.results[0].nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorsApp.accentColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
