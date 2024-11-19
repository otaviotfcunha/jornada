import 'package:flutter/material.dart';
import 'package:jornada/models/destino_depoimentos_model.dart';
import 'package:jornada/models/destino_pesquisa_model.dart';
import 'package:jornada/models/roteiro_destino_model.dart';
import 'package:jornada/models/utils.dart';
import 'package:jornada/pages/roteiro_page.dart';
import 'package:jornada/repositories/jornada_api_repository.dart';
import 'package:jornada/shared/colors.dart';
import 'package:jornada/shared/widgets/app_images.dart';
import 'package:jornada/shared/widgets/carrossel_destino.dart';
import 'package:jornada/shared/widgets/depoimentos_destinos.dart';

class DestinoPage extends StatefulWidget {
  final String searchText;

  const DestinoPage({super.key, required this.searchText});

  @override
  State<DestinoPage> createState() => _DestinoPageState();
}

class _DestinoPageState extends State<DestinoPage> {
  final JornadaApiRepository _jornadaApiRepository = JornadaApiRepository();
  late Future<void> _dadosCarregados;
  DestinosPesquisaModel _destino = DestinosPesquisaModel([]);
  DepoimentosDestinoModel _depoimentos = DepoimentosDestinoModel([]);
  RoteiroDestinoModel _roteiro = RoteiroDestinoModel("");
  final List<String> _imagensDestino = [];
  bool _mostrarTextoCompleto = false;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _dadosCarregados = _carregarDados();
  }

  Future<void> _carregarDados() async {
    await Future.wait([_carregaDestino(), _carregaDepoimentos()]);
  }

  Future<void> _carregaDestino() async {
    _destino =
        await _jornadaApiRepository.carregarDestinoPesquisa(widget.searchText);
    _imagensDestino.clear();
    for (var destino in _destino.results) {
      final imagens = await Utils.pegaImagensGoogle(destino.nome, 3);
      _imagensDestino.addAll(imagens);
    }
  }

  Future<void> _carregaDepoimentos() async {
    _depoimentos =
        await _jornadaApiRepository.carregarDepoimentos(widget.searchText);
  }

  Future<void> _carregarRoteiros(int dias, bool incluirTransporte) async {
    setState(() {
      _carregando = true;
    });
    _roteiro = await _jornadaApiRepository.carregarRoteiroDestino(
        widget.searchText, dias, incluirTransporte);
    setState(() {
      _carregando = false;
    });
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RoteiroPage(roteiro: _roteiro.roteiro),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destino: ${widget.searchText}'),
      ),
      body: FutureBuilder<void>(
        future: _dadosCarregados,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar dados: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          return _carregando
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildDescricao(),
                    const SizedBox(height: 20),
                    _buildImagensCarrossel(),
                    const SizedBox(height: 20),
                    _buildDepoimentos(),
                    const SizedBox(height: 20),
                    _buildBotaoRoteiro(),
                    const SizedBox(height: 20),
                    _buildBotaoDepoimento(),
                    const SizedBox(height: 20),
                    _buildLogo(),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Text(
          'Mostrando: ',
          style: TextStyle(fontSize: 14),
        ),
        Flexible(
          child: Text(
            widget.searchText,
            style: TextStyle(
              fontSize: 20,
              color: ColorsApp.accentColor(),
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDescricao() {
    if (_destino.results.isEmpty) {
      return const Text(
        'Nenhum destino encontrado',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }

    final descricao = _destino.results[0].descricaoCompleta;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _mostrarTextoCompleto
              ? descricao
              : (descricao.length > 100
                  ? '${descricao.substring(0, 100)}...'
                  : descricao),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.justify,
        ),
        if (descricao.length > 100)
          TextButton(
            onPressed: () {
              setState(() {
                _mostrarTextoCompleto = !_mostrarTextoCompleto;
              });
            },
            child: Text(_mostrarTextoCompleto ? 'Recolher' : 'Leia mais'),
          ),
      ],
    );
  }

  Widget _buildImagensCarrossel() {
    return Column(
      children: [
        Text(
          "Imagens de ${widget.searchText}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorsApp.accentColor(),
          ),
          textAlign: TextAlign.center,
        ),
        CarrosselDestino(destino: _destino, imagens: _imagensDestino),
      ],
    );
  }

  Widget _buildDepoimentos() {
    if (_depoimentos.results.isEmpty) {
      return const Center(
        child: Text(
          'Não há depoimentos para serem exibidos...',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return DepoimentosDestinosUsuarios(depoimento: _depoimentos);
  }

  Widget _buildBotaoRoteiro() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsApp.primaryColor(),
        foregroundColor: ColorsApp.accentColor(),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _abrirDialogoRoteiro(),
      child: const Text("Roteiro de Viagem"),
    );
  }

  Widget _buildBotaoDepoimento() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsApp.primaryColor(),
        foregroundColor: ColorsApp.accentColor(),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _abrirDialogoDepoimento(),
      child: const Text("Envie seu depoimento"),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      AppImages.logo_branco,
      width: MediaQuery.of(context).size.width * 0.5,
    );
  }

  void _abrirDialogoRoteiro() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int? dias;
        bool incluirTransporte = true;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Configure o seu roteiro"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Quantidade de dias",
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => dias = int.tryParse(value),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<bool>(
                    value: incluirTransporte,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        setState(() => incluirTransporte = newValue);
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: true,
                        child: Text("Roteiro alternativo (Baixo Custo)"),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text("Roteiro normal"),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dias != null) {
                      Navigator.of(context).pop();
                      _carregarRoteiros(dias!, incluirTransporte);
                    }
                  },
                  child: const Text("Gerar Roteiro"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _abrirDialogoDepoimento() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _nomeController = TextEditingController();
    final TextEditingController _feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Envie seu depoimento'),
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final nome = _nomeController.text.trim();
                  final feedback = _feedbackController.text.trim();

                  try {
                    await _jornadaApiRepository.salvarFeedbackDestino(
                      nome,
                      feedback,
                      widget.searchText,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Depoimento enviado com sucesso!'),
                      ),
                    );

                    _nomeController.clear();
                    _feedbackController.clear();
                    Navigator.of(context).pop(); // Fecha o modal
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro ao enviar o depoimento!'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
}
