import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:frontend/data/services/api_services.dart';

class MovimentacoesPage extends StatefulWidget {
  @override
  _MovimentacoesPageState createState() => _MovimentacoesPageState();
}

class _MovimentacoesPageState extends State<MovimentacoesPage> {
  final GetServices getServices = GetServices();
  bool isLoading = false;
  List<Map<String, dynamic>> getInsumo = [];
  List<Map<String, dynamic>> filteredInsumo = [];
  String? selectedValue;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadInsumos();
  }

  Future<void> loadInsumos() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await getServices.getInsumos();

      setState(() {
        getInsumo = result.map<Map<String, dynamic>>((item) {
          return {
            'id': item['id'] ?? 0,
            'nome': item['nome'] ?? 'Insumo desconhecido',
          };
        }).toList();
        filteredInsumo = List.from(
            getInsumo); // Inicialmente, todos os insumos estão na lista filtrada
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar insumos: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredInsumo = List.from(getInsumo);
      });
    } else {
      setState(() {
        filteredInsumo = getInsumo
            .where((item) => item['nome']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar insumos',
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.blueGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade600),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    onChanged: filterSearchResults,
                  ),
                  const SizedBox(height: 16),
                  if (filteredInsumo.isNotEmpty)
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Selecione um item',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: filteredInsumo
                            .map((item) => DropdownMenuItem<String>(
                                  value: item['nome'],
                                  child: Text(
                                    item['nome'] ?? 'Insumo desconhecido',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                            color: Colors.white,
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(Icons.arrow_forward_ios_outlined),
                          iconSize: 14,
                          iconEnabledColor: Colors.blueGrey,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 14),
                        ),
                      ),
                    ),
                  if (selectedValue != null && selectedValue!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Você selecionou: $selectedValue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
