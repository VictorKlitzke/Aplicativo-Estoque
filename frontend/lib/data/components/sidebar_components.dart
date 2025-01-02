import 'package:flutter/material.dart';

class SideBarComponents extends StatefulWidget {
  _SideBarComponents createState() => _SideBarComponents();
}

class _SideBarComponents extends State<SideBarComponents> {

  void logout(BuildContext context) async {

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.lightGreen,
            border: Border(bottom: BorderSide(color: Colors.white)),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  'usuarioName',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'usuarioEmail',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'usuarioAtivo',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text('Insumos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/Insumos');
                },
              ),
              ListTile(
                leading: const Icon(Icons.warning),
                title: const Text('Reposição'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/Reposicao');
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Relatórios'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/Relatorios');
                },
              ),
              // ExpansionTile(
              //   leading: const Icon(Icons.list),
              //   title: const Text('Despesas'),
              //   children: [
              //     ListTile(
              //       leading: const Icon(Icons.add),
              //       title: const Text('Registrar Transação'),
              //       onTap: () {
              //         Navigator.pop(context);
              //         Navigator.pushNamed(context, '/expense');
              //       },
              //     ),
              //     ListTile(
              //       leading: const Icon(Icons.expand),
              //       title: const Text('Lista Despesas'),
              //       onTap: () {
              //         Navigator.pop(context);
              //         Navigator.pushNamed(context, '/listtransacao');
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Sair'),
          onTap: () {
            Navigator.pop(context);
            logout(context);
          },
        ),
      ],
    );
  }
}