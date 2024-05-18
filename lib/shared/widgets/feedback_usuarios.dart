import 'package:flutter/material.dart';
import 'package:jornada/models/feedback_home_model.dart';
import 'package:jornada/shared/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeedbackUsuarios extends StatefulWidget {
  final FeedbacksHomeModel comentario;

  const FeedbackUsuarios({Key? key, required this.comentario}) : super(key: key);

  @override
  State<FeedbackUsuarios> createState() => _FeedbackUsuariosState();
}

class _FeedbackUsuariosState extends State<FeedbackUsuarios> {
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
            "USUÁRIOS DO APP DISSERAM",
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
            items: widget.comentario.results.map((comentario) {
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
                      "${comentario.nomeUsuario} disse:",
                      style: const TextStyle(
                        color: ColorsApp.textColorBlack,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      comentario.feedback,
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
                          comentario.nota,
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
