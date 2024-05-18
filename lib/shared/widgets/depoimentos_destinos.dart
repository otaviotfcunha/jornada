import 'package:flutter/material.dart';
import 'package:jornada/models/destino_depoimentos_model.dart';
import 'package:jornada/shared/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DepoimentosDestinosUsuarios extends StatefulWidget {
  final DepoimentosDestinoModel depoimento;

  const DepoimentosDestinosUsuarios({Key? key, required this.depoimento}) : super(key: key);

  @override
  State<DepoimentosDestinosUsuarios> createState() => _FeedbackUsuariosState();
}

class _FeedbackUsuariosState extends State<DepoimentosDestinosUsuarios> {
  final CarouselController _carouselControllerComentarios = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsApp.backgroundColor(),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Text(
            "USUÁRIOS DISSERAM SOBRE:",
            style: TextStyle(color: ColorsApp.textColorBlack, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          CarouselSlider(
            carouselController: _carouselControllerComentarios,
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: widget.depoimento.results.map((depoimento) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: ColorsApp.textColor,
                  borderRadius: BorderRadius.circular(10), // Ajuste o valor conforme necessário
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${depoimento.nome} disse:",
                      style: const TextStyle(
                        color: ColorsApp.textColorBlack,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      depoimento.textoDepoimento,
                      style: const TextStyle(
                        color: ColorsApp.textColorBlack,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          depoimento.nota,
                          (index) => const Icon(
                            Icons.star,
                            color: ColorsApp.textDourado,
                          ),
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
                  _carouselControllerComentarios.previousPage();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: () {
                  _carouselControllerComentarios.nextPage();
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          )
        ],
      ),
    );
  }
}
