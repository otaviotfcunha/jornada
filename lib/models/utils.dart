import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static Future<XFile> cropImage(XFile imageFile) async {
    late XFile arquivoSaida;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9],
      uiSettings: [
        AndroidUiSettings(toolbarTitle: 'Cropper', toolbarColor: Colors.deepOrange, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      arquivoSaida = XFile(croppedFile.path);
    }
    return arquivoSaida;
  }

  static Future<List<String>> pegaImagensGoogle(String searchText, int qtdImagens) async {
    final String apiKey = dotenv.get("GOOGLESEARCH_APIKEY");
    final String searchEngineId = dotenv.get("GOOGLESEARCH_ENGINE_ID");
    final String url = "https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$searchEngineId&searchType=image&q=$searchText";
    List<String> urlImagens = [];

    final dio = Dio();

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data["items"];
        for (var i = 0; i < items.length && i < qtdImagens; i++) {
          final String imageUrl = items[i]["link"];
          urlImagens.add(imageUrl);
        }
      } else {
        print(Exception("Falha ao carregar imagens: ${response.statusCode}"));
      }
    } catch (e) {
      print(Exception("Erro ao processar solicitação: $e"));
    }
    return urlImagens;
  }
}
