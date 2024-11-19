import 'package:jornada/models/destino_depoimentos_model.dart';
import 'package:jornada/models/destino_estacao_model.dart';
import 'package:jornada/models/destino_home_model.dart';
import 'package:jornada/models/destino_pesquisa_model.dart';
import 'package:jornada/models/feedback_home_model.dart';
import 'package:jornada/models/roteiro_destino_model.dart';
import 'package:jornada/repositories/custom_dio.dart';

class JornadaApiRepository {
  final _customDio = CustomDio();

  JornadaApiRepository();

  Future<DestinosHomeModel> carregarDestinosHome() async {
    var url = "/destinos/destinos-home";
    var result = await _customDio.dio.get(url);
    List<dynamic> data = result.data;
    return DestinosHomeModel.fromJson(data);
  }

  Future<DestinosEstacaoModel> carregarEstacaoHome() async {
    var url = "/destinos/estacao";
    var result = await _customDio.dio.get(url);
    List<dynamic> data = result.data;
    return DestinosEstacaoModel.fromJson(data);
  }

  Future<FeedbacksHomeModel> carregarFeedbackHome() async {
    var url = "/feedbacks/feedbacks-home";
    var result = await _customDio.dio.get(url);
    List<dynamic> data = result.data;
    return FeedbacksHomeModel.fromJson(data);
  }

  Future<void> salvarFeedbackHome(
      String nomeUsuario, String feedback, int nota) async {
    const url = "/feedbacks";
    try {
      await _customDio.dio.post(
        url,
        data: {
          'nomeUsuario': nomeUsuario,
          'feedback': feedback,
          'nota': nota,
        },
      );
    } catch (e) {
      print('Erro ao salvar feedback: $e');
      throw Exception('Falha ao salvar feedback');
    }
  }

  Future<void> salvarFeedbackDestino(
      String nomeUsuario, String feedback, String local) async {
    const url = "/depoimentos";
    try {
      await _customDio.dio.post(
        url,
        data: {
          'nome': nomeUsuario,
          'textoDepoimento': feedback,
          'local': local,
        },
      );
    } catch (e) {
      print('Erro ao salvar feedback: $e');
      throw Exception('Falha ao salvar feedback');
    }
  }

  Future<DepoimentosDestinoModel> carregarDepoimentos(String busca) async {
    var url = "/depoimentos/depoimentos-destino?local=$busca";
    var result = await _customDio.dio.get(url);
    List<dynamic> data = result.data;
    return DepoimentosDestinoModel.fromJson(data);
  }

  Future<DestinosPesquisaModel> carregarDestinoPesquisa(String busca) async {
    var url = "/destinos/pesquisar?nome=$busca";
    var result = await _customDio.dio.get(url);
    List<dynamic> data = result.data;
    return DestinosPesquisaModel.fromJson(data);
  }

  Future<RoteiroDestinoModel> carregarRoteiroDestino(
      String busca, int qtdDias, bool alternativo) async {
    var url =
        "/destinos/roteiro?nomeDestino=$busca&quantidadeDias=$qtdDias&alternativo=$alternativo";
    var result = await _customDio.dio.post(url);
    String data = result.data;
    return RoteiroDestinoModel.fromJson(data);
  }
}
