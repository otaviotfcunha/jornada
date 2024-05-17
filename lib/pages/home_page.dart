import 'package:flutter/material.dart';
import 'package:jornada/models/destino_estacao_model.dart';
import 'package:jornada/models/destino_home_model.dart';
import 'package:jornada/models/feedback_home_model.dart';
import 'package:jornada/models/utils.dart';
import 'package:jornada/pages/destino_page.dart';
import 'package:jornada/repositories/jornada_api_repository.dart';
import 'package:jornada/shared/colors.dart';
import 'package:jornada/shared/widgets/alta_estacao.dart';
import 'package:jornada/shared/widgets/app_images.dart';
import 'package:jornada/shared/widgets/feedback_usuarios.dart';
import 'package:jornada/shared/widgets/itens_carrossel_imagens.dart';
import 'package:jornada/shared/widgets/menu_lateral.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  JornadaApiRepository _jornadaApiRepository = JornadaApiRepository();
  var _destinosHome = DestinosHomeModel([]);
  var _estacaoHome = DestinosEstacaoModel([]);
  var _feedbackHome = FeedbacksHomeModel([]);
  List<String> _imagensEstacao = [];
  List<String> _imagensDestinosHome = [];
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
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

  Future<void> _carregarDados() async {
    setState(() {
      carregando = true;
    });

    try {
      await _carregaDestinosHome();
      await _carregaEstacaoHome();
      await _carregaFeedbackHome();
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }

    setState(() {
      carregando = false;
    });
  }

  Future<void> _carregaDestinosHome() async {
    _destinosHome = await _jornadaApiRepository.carregarDestinosHome();
    _imagensDestinosHome.clear();
    await Future.forEach(_destinosHome.results, (destino) async {
      List<String> imagensDestino = await Utils.pegaImagensGoogle(destino.nome, 1);
      _imagensDestinosHome.addAll(imagensDestino);
    });
  }

  Future<void> _carregaEstacaoHome() async {
    _estacaoHome = await _jornadaApiRepository.carregarEstacaoHome();
    _imagensEstacao.clear();
    await Future.forEach(_estacaoHome.results, (estacao) async {
      List<String> imagensEstacao = await Utils.pegaImagensGoogle(estacao.nome, 1);
      _imagensEstacao.addAll(imagensEstacao);
    });
  }

  Future<void> _carregaFeedbackHome() async {
    _feedbackHome = await _jornadaApiRepository.carregarFeedbackHome();
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
          body: carregando
              ? const Center(child: CircularProgressIndicator())
              : ListView(
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
                        ItensCarrosselImagens(destinosHome: _destinosHome, imagens: _imagensDestinosHome)
                      ],
                    ),
                    Row(children: _imagensEstacao.isNotEmpty ? [AltaEstacao(estacao: _estacaoHome, imagens: _imagensEstacao)] : [Text('Sem imagens disponíveis')] // Ou qualquer outro widget de reserva
                        ),
                    Row(
                      children: [FeedbackUsuarios(comentario: _feedbackHome)],
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
