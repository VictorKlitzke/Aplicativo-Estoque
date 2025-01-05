import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/services/api_services.dart';

class MovimentacoesPage extends StatefulWidget {
  _MovimentacoesPage createState() => _MovimentacoesPage();
}

class _MovimentacoesPage extends State<MovimentacoesPage> {
  final GetServices getServices = GetServices();
  bool isLoading = false;
  List<Map<String, dynamic>> getInsumo = [];
  String? selectedInsumos;

  @override
  void initState() {
    super.initState();
    ListInsumos();
  }

  void ListInsumos() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await getServices.getInsumos();

      setState(() {
        getInsumo = result.map((item) {
          return {
            'id': item['id'] ?? 0,
            'nome': item['nome'] ?? 'Insumos desconhecido',
          };
        }).toList();

        if (getInsumo.isNotEmpty && selectedInsumos == null) {
          selectedInsumos = getInsumo.first['id'].toString();
        }

        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar insumos')),
      );
      print('Erro ao fazer consulta de insumos $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insumos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 8),
            DropdownSearch<Map<String, dynamic>>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    labelText: 'Pesquisar',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              itemAsString: (item) => item['nome'] ?? 'Insumo desconhecido',
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedInsumos = value['id'].toString();
                  } else {
                    selectedInsumos = null;
                  }
                });
              },
              selectedItem: selectedInsumos != null
                  ? getInsumo.firstWhere(
                      (item) => item['id'].toString() == selectedInsumos)
                  : null,
              // items: getInsumo.map((item) => item['nome'] as String).toList(),
              filterFn: (item, filter) {
                return item['nome'].toLowerCase().contains(filter.toLowerCase());
              },
            ),
          ],
        ),
      ),
    );
  }
}
