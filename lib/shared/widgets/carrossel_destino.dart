import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jornada/models/destino_pesquisa_model.dart';
import 'package:jornada/shared/widgets/app_images.dart';

class CarrosselDestino extends StatefulWidget {
  final DestinosPesquisaModel destino;
  final List<String> imagens;

  const CarrosselDestino({Key? key, required this.destino, required this.imagens}) : super(key: key);

  @override
  State<CarrosselDestino> createState() => _ItensCarrosselImagensState();
}

class _ItensCarrosselImagensState extends State<CarrosselDestino> {
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    if (widget.destino.results.isEmpty || widget.imagens.isEmpty) {
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
          items: <Widget>[
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: widget.imagens[0] != ""
                    ? DecorationImage(
                        image: NetworkImage(widget.imagens[0]),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: AssetImage(AppImages.sem_foto),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: widget.imagens[1] != ""
                    ? DecorationImage(
                        image: NetworkImage(widget.imagens[1]),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: AssetImage(AppImages.sem_foto),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
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
        )
      ],
    );
  }
}
