// ignore_for_file: use_build_context_synchronously

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
      await _carregaDepoimentos();
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }

    setState(() {
      carregando = false;
    });
  }

  Future<void> _carregaDestino() async {
    _destino =
        await _jornadaApiRepository.carregarDestinoPesquisa(widget.searchText);
    _imagensDestino.clear();
    await Future.forEach(_destino.results, (destino) async {
      List<String> imagensDestino =
          await Utils.pegaImagensGoogle(destino.nome, 3);
      _imagensDestino.addAll(imagensDestino);
    });
  }

  Future<void> _carregaDepoimentos() async {
    _depoimentos =
        await _jornadaApiRepository.carregarDepoimentos(widget.searchText);
  }

  Future<void> _carregarRoteiros(int dias, bool incluirTransporte) async {
    _roteiro = await _jornadaApiRepository.carregarRoteiroDestino(
        widget.searchText, dias, incluirTransporte);
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
                        style: TextStyle(
                            fontSize: 20,
                            color: ColorsApp.accentColor(),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Container(
                        color: ColorsApp.primaryColor(),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: _destino.results.isNotEmpty
                                    ? _destino.results[0].descricaoCompleta
                                            .isNotEmpty
                                        ? Text(
                                            _mostrarTextoCompleto
                                                ? _destino.results[0]
                                                    .descricaoCompleta
                                                : _destino
                                                            .results[0]
                                                            .descricaoCompleta
                                                            .length >
                                                        100
                                                    ? '${_destino.results[0].descricaoCompleta.substring(0, 100)}... '
                                                    : _destino.results[0]
                                                        .descricaoCompleta,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.justify,
                                          )
                                        : Image.asset(
                                            AppImages.logo_animado,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                          )
                                    : const Text(
                                        'Nenhum destino encontrado',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                            if (_destino.results.isNotEmpty &&
                                _destino.results[0].descricaoCompleta.length >
                                    100)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _mostrarTextoCompleto =
                                        !_mostrarTextoCompleto;
                                  });
                                },
                                child: _mostrarTextoCompleto
                                    ? const Icon(Icons.expand_less)
                                    : const Text(
                                        "Leia mais..."), // Ícone "leia mais" ou "recolher"
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
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorsApp.accentColor()),
                    textAlign: TextAlign.center,
                  ),
                  CarrosselDestino(destino: _destino, imagens: _imagensDestino),
                  Row(
                    children: [
                      DepoimentosDestinosUsuarios(depoimento: _depoimentos)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsApp.primaryColor(),
                          foregroundColor: ColorsApp.accentColor(),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                      onPressed: () {
                        final scaffoldContext = context;

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            int? dias;
                            bool incluirTransporte = true;

                            return AlertDialog(
                              title: const Text("Configure o seu roteiro"),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        labelText: "Quantidade de dias",
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        dias = int.tryParse(value);
                                      },
                                    ),
                                    DropdownButton<bool>(
                                      value: incluirTransporte,
                                      onChanged: (bool? newValue) {
                                        if (newValue != null) {
                                          incluirTransporte = newValue;
                                        }
                                      },
                                      items: const [
                                        DropdownMenuItem(
                                          value: true,
                                          child: Text(
                                              "Roteiro alternativo (Baixo Custo)"),
                                        ),
                                        DropdownMenuItem(
                                          value: false,
                                          child: Text("Roteiro normal"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (dias != null) {
                                      Navigator.of(context).pop();

                                      showDialog(
                                        context: scaffoldContext,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );

                                      await _carregarRoteiros(
                                          dias!, incluirTransporte);

                                      Navigator.of(scaffoldContext).pop();

                                      if (mounted) {
                                        ScaffoldMessenger.of(scaffoldContext)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Roteiro carregado com sucesso!"),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );

                                        showDialog(
                                          // ignore: duplicate_ignore
                                          // ignore: use_build_context_synchronously
                                          context: scaffoldContext,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Roteiro de Viagem"),
                                              content: SingleChildScrollView(
                                                child: Text(_roteiro.roteiro),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Fechar"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(scaffoldContext)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Por favor, insira a quantidade de dias."),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text("Confirmar"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text("Roteiro de Viagem"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
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
                      ),
                    ],
                  ),
                ],
              ));
  }
}
