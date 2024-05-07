import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jornada/pages/destino_page.dart';
import 'package:jornada/shared/colors.dart';
import 'package:jornada/shared/widgets/app_images.dart';
import 'package:jornada/shared/widgets/menu_lateral.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late CarouselController _carouselController;
  late CarouselController _carouselControllerComentarios;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    _carouselControllerComentarios = CarouselController();
  }

  void _search() {
    String searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DestinoPage(searchText: searchText),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: const MenuLateral(),
          appBar: AppBar(
            title: Image.asset(
              AppImages.logo_preto,
              width: 150,
            ),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.person_rounded),
                  color: ColorsApp.textColorBlack,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _search(),
                      decoration: InputDecoration(
                        hintText: 'Para onde vamos viajar',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _search,
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ),
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
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    color: ColorsApp.primaryColor,
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        const Text(
                          "Em alta para a estação:",
                          style: TextStyle(color: ColorsApp.textColorBlack, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "INVERNO",
                          style: TextStyle(color: ColorsApp.accentColor, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15), // Ajuste o valor conforme necessário
                          child: Image(
                            image: AssetImage(AppImages.sem_foto),
                            width: MediaQuery.of(context).size.width * 0.8,
                          ),
                        ),
                      ],
                    ),
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
                                    'Muito bom o aplicativo, gostei bastante!',
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
                                    'Me ajudou a encontrar a área com neve no Ceará!',
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
                        )
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
          )),
    );
  }
}
