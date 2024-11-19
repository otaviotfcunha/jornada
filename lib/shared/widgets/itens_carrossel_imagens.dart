import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jornada/models/destino_home_model.dart';
import 'package:jornada/shared/colors.dart';
import 'package:jornada/pages/destino_page.dart';

class ItensCarrosselImagens extends StatefulWidget {
  final DestinosHomeModel destinosHome;
  final List<String> imagens;

  const ItensCarrosselImagens({
    Key? key,
    required this.destinosHome,
    required this.imagens,
  }) : super(key: key);

  @override
  State<ItensCarrosselImagens> createState() => _ItensCarrosselImagensState();
}

class _ItensCarrosselImagensState extends State<ItensCarrosselImagens> {
  @override
  Widget build(BuildContext context) {
    if (widget.destinosHome.results.isEmpty || widget.imagens.isEmpty) {
      return SizedBox(); // Retorna um widget vazio se as listas estiverem vazias
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
          ),
          items: widget.destinosHome.results.asMap().entries.map((entry) {
            final index = entry.key;
            final destino = entry.value;
            final imagem = widget.imagens[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinoPage(searchText: destino.nome),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(imagem),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 10.0,
                      left: 10.0,
                      child: Text(
                        destino.nome,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 5
                            ..color = ColorsApp.primaryColor(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 10.0,
                      child: Text(
                        destino.nome,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: ColorsApp.accentColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
