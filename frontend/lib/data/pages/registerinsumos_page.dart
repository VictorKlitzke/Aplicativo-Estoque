import 'package:flutter/material.dart';
import 'package:frontend/data/services/api_services.dart';
import 'package:frontend/data/utils/money.dart';

class RegisterInsumosPage extends StatefulWidget {
  @override
  _RegisterInsumosPage createState() => _RegisterInsumosPage();
}

class _RegisterInsumosPage extends State<RegisterInsumosPage> {
  final PostServices postServices = PostServices();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final TextEditingController estoqueMinimoController = TextEditingController();
  final TextEditingController custoUnitarioController = TextEditingController();

  bool isLoading = false;

  String? selectedUnidade;

  void registerInsumo(BuildContext conntext) async {
    final nome = nomeController.text;
    final categoria = categoriaController.text;
    final quantidade = quantidadeController.text;
    final unidade = selectedUnidade;
    final estoqueMinimo = estoqueMinimoController.text;
    final custoUnitario = custoUnitarioController.text
        .trim()
        .replaceAll(',', '.')
        .replaceAll('R\$', '');

    final data = {
      'nome': nome,
      'categoria': categoria,
      'quantidade': quantidade,
      'unidade': unidade,
      'estoqueMinimo': estoqueMinimo,
      'custoUnitario': custoUnitario,
    };

    if (nome.isEmpty ||
        unidade == null ||
        quantidade.isEmpty ||
        estoqueMinimo.isEmpty ||
        custoUnitario.isEmpty) {
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
      bool success = await postServices.RegisterInsumos(data);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Insumos registrado com sucesso!'),
              backgroundColor: Colors.lightGreen),
        );
        nomeController.clear();
        categoriaController.clear();
        quantidadeController.clear();
        custoUnitarioController.clear();
        estoqueMinimoController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao registrar transação'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (error) {
      print('Erro ao registrar produtos $error');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildLabel('Nome do Produto'),
            _buildTextField(
                controller: nomeController, hint: 'Ex.: Fertilizante A'),
            const SizedBox(height: 20),
            _buildLabel('Categoria'),
            _buildTextField(
                controller: categoriaController, hint: 'Ex.: Fertilizantes'),
            const SizedBox(height: 20),
            _buildLabel('Quantidade'),
            _buildTextField(
              controller: quantidadeController,
              hint: 'Ex.: 100',
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildLabel('Unidade'),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              items: const [
                DropdownMenuItem(value: 'Unidade', child: Text('Unidade')),
                DropdownMenuItem(value: 'Kilo', child: Text('Kilo')),
                DropdownMenuItem(value: 'Tonelada', child: Text('Tonelada')),
                DropdownMenuItem(value: 'Litro', child: Text('Litro')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedUnidade = value;
                });
              },
              value: selectedUnidade,
            ),
            const SizedBox(height: 20),
            _buildLabel('Estoque Mínimo'),
            _buildTextField(
              controller: estoqueMinimoController,
              hint: 'Ex.: 10',
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            MoneyInputFormatter.buildMoneyField(
                "Valor Unitario", custoUnitarioController),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => registerInsumo(context),
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
      style: const TextStyle(
        fontSize: 16,
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
