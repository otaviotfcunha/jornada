import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jornada/shared/colors.dart';
import 'package:jornada/shared/widgets/app_images.dart';

class DestinoPage extends StatefulWidget {
  final String searchText;

  const DestinoPage({Key? key, required this.searchText}) : super(key: key);

  @override
  State<DestinoPage> createState() => _DestinoPageState();
}

class _DestinoPageState extends State<DestinoPage> {
  late CarouselController _carouselController;
  late CarouselController _carouselControllerComentarios;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    _carouselControllerComentarios = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Destino: ${widget.searchText}'),
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  'Resultado da busca para: ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  widget.searchText,
                  style: const TextStyle(fontSize: 20, color: ColorsApp.accentColor, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Container(
                  color: ColorsApp.primaryColor,
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                            child: Text(
                          "Um lugar muito bonito, cheio de belas paisagens, hotéis, praia, frio, neve, calor e também frio quando é noite durante o dia.",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
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
                    image: DecorationImage(
                      image: AssetImage(AppImages.sem_foto),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Text(
                    'Descrição da imagem 1',
                    style: TextStyle(
                      color: ColorsApp.textColorBlack,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage(AppImages.sem_foto),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Text(
                    'Descrição da imagem 2',
                    style: TextStyle(
                      color: ColorsApp.textColorBlack,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Adicione mais imagens e descrições conforme necessário
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
            ),
            Row(
              children: [
                Container(
                  color: ColorsApp.backgroundColor,
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
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: ColorsApp.textColor,
                              borderRadius: BorderRadius.circular(10), // Ajuste o valor conforme necessário
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  'Ótimo lugar, porém eu queimei meu dedo no gelo da sala.',
                                  style: TextStyle(
                                    color: ColorsApp.textColorBlack,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: ColorsApp.textDourado,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: ColorsApp.textDourado,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: ColorsApp.textDourado,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: ColorsApp.textColor,
                              borderRadius: BorderRadius.circular(10), // Ajuste o valor conforme necessário
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  'Sábado de sol, aluguei um caminhão...',
                                  style: TextStyle(
                                    color: ColorsApp.textColorBlack,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: ColorsApp.textDourado,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: ColorsApp.textDourado,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: ColorsApp.textDourado,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: ColorsApp.textDourado,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: ColorsApp.textDourado,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),

                          // Adicione mais comentários conforme necessário
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              _carouselControllerComentarios.previousPage();
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          IconButton(
                            onPressed: () {
                              _carouselControllerComentarios.nextPage();
                            },
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  color: ColorsApp.primaryColor,
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(AppImages.logo_branco),
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
