import 'package:flutter/material.dart';
import 'package:jornada/models/destino_depoimentos_model.dart';
import 'package:jornada/models/destino_pesquisa_model.dart';
import 'package:jornada/models/roteiro_destino_model.dart';
import 'package:jornada/models/utils.dart';
import 'package:jornada/repositories/jornada_api_repository.dart';
import 'package:jornada/shared/colors.dart';
import 'package:jornada/shared/widgets/app_images.dart';
import 'package:jornada/shared/widgets/carrossel_destino.dart';
import 'package:jornada/shared/widgets/depoimentos_destinos.dart';

class DestinoPage extends StatefulWidget {
  final String searchText;

  const DestinoPage({Key? key, required this.searchText}) : super(key: key);

  @override
  State<DestinoPage> createState() => _DestinoPageState();
}

class _DestinoPageState extends State<DestinoPage> {
  JornadaApiRepository _jornadaApiRepository = JornadaApiRepository();
  var _destino = DestinosPesquisaModel([]);
  var _depoimentos = DepoimentosDestinoModel([]);
  var _roteiro = RoteiroDestinoModel("");
  List<String> _imagensDestino = [];
  bool _mostrarTextoCompleto = false;
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      carregando = true;
    });

    try {
      await _carregaDestino();
      await _carregarRoteiros();
      //await _carregaDepoimentos();
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }

    setState(() {
      carregando = false;
    });
  }

  Future<void> _carregaDestino() async {
    _destino = await _jornadaApiRepository.carregarDestinoPesquisa(widget.searchText);
    _imagensDestino.clear();
    await Future.forEach(_destino.results, (destino) async {
      List<String> imagensDestino = await Utils.pegaImagensGoogle(destino.nome, 3);
      _imagensDestino.addAll(imagensDestino);
    });
  }

  Future<void> _carregaDepoimentos() async {
    _depoimentos = await _jornadaApiRepository.carregarDepoimentos(widget.searchText);
  }

  Future<void> _carregarRoteiros() async {
    _roteiro = await _jornadaApiRepository.carregarRoteiroDestino(widget.searchText, 5, true);
    //print("ROTEIRO: + ${_roteiro.roteiro}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Destino: ${widget.searchText}'),
        ),
        body: carregando
            ? const Center(child: CircularProgressIndicator())
            : ListView(
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
                                child: _destino.results[0].descricaoCompleta.isNotEmpty
                                    ? Text(
                                        _mostrarTextoCompleto
                                            ? _destino.results[0].descricaoCompleta
                                            : _destino.results[0].descricaoCompleta.length > 100
                                                ? '${_destino.results[0].descricaoCompleta.substring(0, 100)}... '
                                                : _destino.results[0].descricaoCompleta,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.justify,
                                      )
                                    : Image.asset(
                                        AppImages.logo_animado,
                                        width: MediaQuery.of(context).size.width * 0.5,
                                      ),
                              ),
                            ),
                            if (_destino.results[0].descricaoCompleta.length > 100)
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
                  CarrosselDestino(destino: _destino, imagens: _imagensDestino),
                  Row(
                    children: [DepoimentosDestinosUsuarios(depoimento: _depoimentos)],
                  ),
                  SizedBox(height: 20), // Espaçamento entre os widgets
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Roteiro"),
                            content: SingleChildScrollView(
                              child: Text(_roteiro.roteiro),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Fechar"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("Roteiro"),
                  ),
                  SizedBox(height: 20),

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
