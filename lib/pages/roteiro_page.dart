import 'package:flutter/material.dart';
import 'package:jornada/shared/colors.dart';
import 'package:jornada/shared/widgets/app_images.dart';
import 'package:share_plus/share_plus.dart';

class RoteiroPage extends StatelessWidget {
  final String roteiro;

  const RoteiroPage({super.key, required this.roteiro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roteiro de Viagem'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image(
                image: AssetImage(AppImages.logo_preto),
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  roteiro,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsApp.primaryColor(),
                      foregroundColor: ColorsApp.textColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsApp.primaryColor(),
                      foregroundColor: ColorsApp.textColor),
                  onPressed: () {
                    Share.share(roteiro, subject: 'Roteiro de Viagem');
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Compartilhar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
