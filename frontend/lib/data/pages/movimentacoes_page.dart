import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:frontend/data/services/api_services.dart';

class MovimentacoesPage extends StatefulWidget {
  @override
  _MovimentacoesPageState createState() => _MovimentacoesPageState();
}

class _MovimentacoesPageState extends State<MovimentacoesPage> {
  final GetServices getServices = GetServices();
  final PostServices postServices = PostServices();

  bool isLoading = false;

  List<Map<String, dynamic>> getInsumo = [];
  List<Map<String, dynamic>> filteredInsumo = [];

  SingleValueDropDownController _controller = SingleValueDropDownController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController controllerQuantidade = TextEditingController();
  final TextEditingController controllerTipo = TextEditingController();

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
        filteredInsumo = List.from(getInsumo);
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

  void registerMovimentacao(BuildContext context) async {
    final nomeProduto = _controller.dropDownValue?.value;
    final quantidade = controllerQuantidade.text;
    final tipo = controllerTipo.text;

    final data = {
      'nomeProduto': nomeProduto,
      'quantidade': quantidade,
      'tipo': tipo,
    };

    if (data.isEmpty || quantidade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      bool success = await postServices.RegisterMovimentacoes(data);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Insumos registrado com sucesso!'),
              backgroundColor: Colors.lightGreen),
        );
        _controller.clearDropDown();
        controllerQuantidade.clear();
        controllerTipo.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao registrar movimentações'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (error) {
      print('Erro ao registrar movimentação $error');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Nome do Produto'),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.lightGreen,
                  width: 2,
                ),
              ),
              child: DropDownTextField(
                controller: _controller,
                enableSearch: true,
                dropDownItemCount: 6,
                validator: (value) {
                  if (value == null) {
                    return "Campo obrigatório";
                  }
                  return null;
                },
                dropDownList: filteredInsumo.map((item) {
                  return DropDownValueModel(
                    name: item['nome'],
                    value: item['id'].toString(),
                  );
                }).toList(),
                onChanged: (val) {
                  print(val.value);
                },
              ),
            ),
            if (isLoading) Center(child: CircularProgressIndicator()),
            SizedBox(height: 20),
            _buildLabel('Quantidade'),
            _buildTextField(
                controller: controllerQuantidade,
                hint: 'Ex: 10',
                inputType: TextInputType.number),
            SizedBox(height: 20),
            _buildLabel('Tipo'),
            _buildTextField(
                controller: controllerTipo,
                hint: 'Ex: Fert...',
                inputType: TextInputType.text),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => registerMovimentacao(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Registrar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.lightGreen,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.lightGreen, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
