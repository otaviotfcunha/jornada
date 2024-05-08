import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  late String _descricaoDestino = "";
  bool _mostrarTextoCompleto = false;
  List<String> imageUrls = ["", ""];

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    _carouselControllerComentarios = CarouselController();
    _fetchDescricaoDestino();
    _fetchImageUrls(widget.searchText);
  }

  Future<void> _fetchDescricaoDestino() async {
    try {
      final String apiKey = dotenv.get("TEXTCORTEX_APIKEY");
      final String url = 'https://api.textcortex.com/v1/texts/blogs';

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $apiKey';

      final response = await dio.post(
        url,
        data: {
          "context": widget.searchText,
          "formality": "default",
          "keywords": [widget.searchText, "locais turísticos", "passeios"],
          "max_tokens": 2048,
          "model": "chat-sophos-1",
          "n": 1,
          "source_lang": "pt",
          "target_lang": "pt-br",
          "temperature": 0.65,
          "title": widget.searchText
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _descricaoDestino = response.data['data']['outputs'][0]['text'].replaceAll('"', '');
        });
      } else {
        print('Erro ao carregar descrição do destino: ${response.statusCode}');
        print('DESCRIÇÃO DO DESTINO: ${response.data}');
        throw Exception('Erro ao carregar descrição do destino: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar descrição do destino: $e');
    }

    print("DESCRIÇÃO DO DESTINO :::>>> $_descricaoDestino");
  }

  Future<void> _fetchImageUrls(String searchText) async {
    final String apiKey = dotenv.get("GOOGLESEARCH_APIKEY");
    final String searchEngineId = dotenv.get("GOOGLESEARCH_ENGINE_ID");
    final String url = "https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$searchEngineId&searchType=image&q=$searchText";

    final dio = Dio();

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data["items"];
        imageUrls.clear();
        for (var i = 0; i < items.length && i < 2; i++) {
          final String imageUrl = items[i]["link"];
          imageUrls.add(imageUrl);
        }
      } else {
        print(Exception("Falha ao carregar imagens: ${response.statusCode}"));
      }
    } catch (e) {
      print(Exception("Erro ao processar solicitação: $e"));
    }
    print("IMAGENS:: $imageUrls");
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: _descricaoDestino.isNotEmpty
                              ? Text(
                                  _mostrarTextoCompleto
                                      ? _descricaoDestino
                                      : _descricaoDestino.length > 100
                                          ? '${_descricaoDestino.substring(0, 100)}... '
                                          : _descricaoDestino,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.justify,
                                )
                              : Image.asset(
                                  AppImages.logo_animado,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                ),
                        ),
                      ),
                      if (_descricaoDestino.length > 100)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _mostrarTextoCompleto = !_mostrarTextoCompleto;
                            });
                          },
                          child: _mostrarTextoCompleto ? const Icon(Icons.expand_less) : const Text("Leia mais..."), // Ícone "leia mais" ou "recolher"
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Imagens de ${widget.searchText}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorsApp.accentColor),
              textAlign: TextAlign.center,
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
                    image: imageUrls[0] != ""
                        ? DecorationImage(
                            image: NetworkImage(imageUrls[0]),
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
                    image: imageUrls[1] != ""
                        ? DecorationImage(
                            image: NetworkImage(imageUrls[1]),
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
