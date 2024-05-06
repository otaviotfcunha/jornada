import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jornada/pages/perfil_page.dart';
import 'package:jornada/services/shared_preferences.dart';
import 'package:jornada/shared/widgets/app_images.dart';
import 'package:jornada/shared/widgets/itens_menu_lateral.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class MenuLateral extends StatefulWidget {
  const MenuLateral({super.key});

  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  AppStorageService storage = AppStorageService();
  String nomeUsuario = "";
  String telefoneUsuario = "";
  String emailUsuario = "";
  String fotoNome = "sem-foto.jpg";
  bool carregando = false;
  String path = "";
  late XFile? photo;

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
    nomeUsuario = await storage.getConfiguracoesNomeUsuario();
    telefoneUsuario = await storage.getConfiguracoesTelefoneUsuario();
    emailUsuario = await storage.getConfiguracoesEmailUsuario();
    fotoNome = await storage.getConfiguracoesFotoUsuario();
    path = (await path_provider.getApplicationDocumentsDirectory()).path;
    photo = XFile("$path/$fotoNome");
    setState(() {
      carregando = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (fotoNome == "sem-foto.jpg" || fotoNome == "")
              ? UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    image: DecorationImage(
                        image: AssetImage(AppImages.sem_foto),
                        fit: BoxFit.cover),
                  ),
                  accountName: Text(nomeUsuario,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w900,
                          fontSize: 20)),
                  accountEmail: Text(emailUsuario,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w900,
                          fontSize: 16)))
              : UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    image: DecorationImage(
                        image: FileImage(File(photo!.path)), fit: BoxFit.cover),
                  ),
                  accountName: Text(nomeUsuario,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w900,
                          fontSize: 20)),
                  accountEmail: Text(emailUsuario,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w900,
                          fontSize: 16))),
          const ItensMenuLateral(
              textMenu: "Seu perfil de usuário",
              paginaDireciona: PerfilPage(),
              iconeMenu: Icons.list),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          ItensMenuLateral(
              textMenu: "Sair",
              paginaDireciona: AlertDialog(
                title: const Text(
                  "Sair do Aplicativo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Wrap(
                  children: [
                    Text("Tem certeza que deseja sair do aplicativo?"),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Não")),
                  TextButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: const Text("Sim")),
                ],
              ),
              iconeMenu: Icons.exit_to_app),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
