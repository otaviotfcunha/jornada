import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jornada/models/utils.dart';
import 'package:jornada/services/shared_preferences.dart';
import 'package:jornada/shared/colors.dart';
import 'package:jornada/shared/widgets/app_images.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  AppStorageService storage = AppStorageService();
  var nomeController = TextEditingController(text: "");
  var telefoneController = TextEditingController(text: "");
  var emailController = TextEditingController(text: "");
  var carregando = false;
  bool subiuFoto = false;
  late String path;
  late XFile? photo;
  String fotoNome = "sem-foto.jpg";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    setState(() {
      carregando = true;
    });
    nomeController.text = await storage.getConfiguracoesNomeUsuario();
    telefoneController.text = await storage.getConfiguracoesTelefoneUsuario();
    emailController.text = await storage.getConfiguracoesEmailUsuario();
    fotoNome = await storage.getConfiguracoesFotoUsuario();
    path = (await path_provider.getApplicationDocumentsDirectory()).path;
    photo = XFile("$path/$fotoNome");
    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "PERFIL",
          style: TextStyle(color: ColorsApp.textColorBlack, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorsApp.textColorBlack),
          onPressed: () {
            Navigator.pop(context);
            setState(() {});
          },
        ),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [Expanded(child: (fotoNome == "sem-foto.jpg" || fotoNome == "") && !subiuFoto ? Image.asset(AppImages.sem_foto) : Image.file(File(photo!.path)))],
                    ),
                    TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.photo_camera),
                                      title: const Text("Acessar a câmera"),
                                      onTap: () async {
                                        final ImagePicker picker = ImagePicker();
                                        photo = await picker.pickImage(source: ImageSource.camera);
                                        if (photo != null) {
                                          photo = await Utils.cropImage(photo!);
                                          fotoNome = basename(photo!.path);
                                          await photo!.saveTo("$path/$fotoNome");
                                          subiuFoto = true;
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo),
                                      title: const Text("Acessar a galeria"),
                                      onTap: () async {
                                        final ImagePicker picker = ImagePicker();
                                        photo = await picker.pickImage(source: ImageSource.gallery);
                                        if (photo != null) {
                                          photo = await Utils.cropImage(photo!);
                                          fotoNome = basename(photo!.path);
                                          await photo!.saveTo("$path/$fotoNome");
                                          subiuFoto = true;
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text("Adicionar uma foto")),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(flex: 2, child: Text("Seu Nome: ")),
                        Expanded(
                            flex: 5,
                            child: TextField(
                              controller: nomeController,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(flex: 2, child: Text("Seu Telefone: ")),
                        Expanded(
                            flex: 5,
                            child: TextField(
                              controller: telefoneController,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(flex: 2, child: Text("Seu Email: ")),
                        Expanded(
                            flex: 5,
                            child: TextField(
                              controller: emailController,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () async {
                              await storage.setConfiguracoesNomeUsuario(nomeController.text);
                              await storage.setConfiguracoesTelefoneUsuario(telefoneController.text);
                              await storage.setConfiguracoesEmailUsuario(emailController.text);
                              await storage.setConfiguracoesFotoUsuario(fotoNome);
                              carregarDados();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Seus dados foram atualizados com sucesso!")));
                            },
                            style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), backgroundColor: MaterialStateProperty.all(Colors.blue)),
                            child: const Text(
                              "Salvar dados do perfil",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
    ));
  }
}
