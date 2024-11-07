import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jornada/models/destino_home_model.dart';
import 'package:jornada/shared/colors.dart';

class ItensCarrosselImagens extends StatefulWidget {
  final DestinosHomeModel destinosHome;
  final List<String> imagens;

  const ItensCarrosselImagens(
      {Key? key, required this.destinosHome, required this.imagens})
      : super(key: key);

  @override
  State<ItensCarrosselImagens> createState() => _ItensCarrosselImagensState();
}

class _ItensCarrosselImagensState extends State<ItensCarrosselImagens> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.destinosHome.results.isEmpty || widget.imagens.isEmpty) {
      return SizedBox(); // Retorna um widget vazio se as listas estiverem vazias
    }

    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 200,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
          items: widget.destinosHome.results.map((destino) {
            final index = widget.destinosHome.results.indexOf(destino);
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(index < widget.imagens.length
                      ? widget.imagens[index]
                      : ''),
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
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                _carouselController.previousPage();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            IconButton(
              onPressed: () {
                _carouselController.nextPage();
              },
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ],
    );
  }
}
