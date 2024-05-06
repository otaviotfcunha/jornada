import 'package:flutter/material.dart';

class ItensMenuLateral extends StatelessWidget {
  final String textMenu;
  final Widget paginaDireciona;
  final IconData iconeMenu;
  const ItensMenuLateral(
      {super.key,
      required this.textMenu,
      required this.paginaDireciona,
      required this.iconeMenu});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          width: double.infinity,
          child: Row(
            children: [
              Icon(iconeMenu),
              const SizedBox(
                width: 10,
              ),
              Text(textMenu),
            ],
          )),
      onTap: () {
        if (textMenu == "Sair") {
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return paginaDireciona;
              });
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => paginaDireciona));
        }
      },
    );
  }
}
