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
  final JornadaApiRepository _jornadaApiRepository = JornadaApiRepository();

  DestinosHomeModel _destinosHome = DestinosHomeModel([]);
  DestinosEstacaoModel _estacaoHome = DestinosEstacaoModel([]);
  FeedbacksHomeModel _feedbackHome = FeedbacksHomeModel([]);
  List<String> _imagensEstacao = [];
  List<String> _imagensDestinosHome = [];
  bool _carregando = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  int _nota = 1;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _carregando = true;
    });

    try {
      await Future.wait([
        _carregaDestinosHome(),
        _carregaEstacaoHome(),
        _carregaFeedbackHome(),
      ]);
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }

    setState(() {
      _carregando = false;
    });
  }

  Future<void> _carregaDestinosHome() async {
    _destinosHome = await _jornadaApiRepository.carregarDestinosHome();
    _imagensDestinosHome.clear();
    for (var destino in _destinosHome.results) {
      final imagensDestino = await Utils.pegaImagensGoogle(destino.nome, 1);
      _imagensDestinosHome.addAll(imagensDestino);
    }
  }

  Future<void> _carregaEstacaoHome() async {
    _estacaoHome = await _jornadaApiRepository.carregarEstacaoHome();
    _imagensEstacao.clear();
    for (var estacao in _estacaoHome.results) {
      final imagensEstacao = await Utils.pegaImagensGoogle(estacao.nome, 1);
      _imagensEstacao.addAll(imagensEstacao);
    }
  }

  Future<void> _carregaFeedbackHome() async {
    _feedbackHome = await _jornadaApiRepository.carregarFeedbackHome();
  }

  void _search() {
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DestinoPage(searchText: searchText),
        ),
      );
    }
  }

  void _enviarFeedback() async {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text.trim();
      final feedback = _feedbackController.text.trim();

      try {
        await _jornadaApiRepository.salvarFeedbackHome(nome, feedback, _nota);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback enviado com sucesso!')),
        );
        _nomeController.clear();
        _feedbackController.clear();
        _nota = 1;
        Navigator.of(context).pop(); // Fecha o modal
        await _carregaFeedbackHome(); // Recarrega os feedbacks
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao enviar feedback!')),
        );
      }
    }
  }

  void _mostrarModalAvaliacao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Avalie o Aplicativo'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _feedbackController,
                    decoration: const InputDecoration(labelText: 'Feedback'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu feedback';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: _nota,
                    decoration: const InputDecoration(labelText: 'Nota'),
                    items: List.generate(
                      5,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('Nota ${index + 1}'),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _nota = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _enviarFeedback,
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
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
        body: _carregando
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _carregarDados,
                child: ListView(
                  children: [
                    _buildSearchBar(),
                    _buildCarrosselImagens(),
                    _buildAltaEstacao(),
                    _buildFeedbackUsuarios(),
                    _buildBotaoAvaliacao(),
                    _buildFooter(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
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
    );
  }

  Widget _buildCarrosselImagens() {
    return ItensCarrosselImagens(
      destinosHome: _destinosHome,
      imagens: _imagensDestinosHome,
    );
  }

  Widget _buildAltaEstacao() {
    return _imagensEstacao.isNotEmpty
        ? AltaEstacao(estacao: _estacaoHome, imagens: _imagensEstacao)
        : const Center(child: Text('Sem imagens disponíveis'));
  }

  Widget _buildFeedbackUsuarios() {
    return _feedbackHome.results.isNotEmpty
        ? FeedbackUsuarios(comentario: _feedbackHome)
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: const Center(
              child: Text(
                'Não há feedbacks para serem exibidos...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
  }

  Widget _buildBotaoAvaliacao() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsApp.primaryColor(),
        ),
        onPressed: _mostrarModalAvaliacao,
        child: const Text('Avalie o Aplicativo'),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: ColorsApp.primaryColor(),
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
    );
  }
}
