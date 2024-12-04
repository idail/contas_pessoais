import 'dart:convert';
import 'package:financas/pages/main_pages/main_contracts/cadastroCategoriaRenda.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroRendaPage extends StatefulWidget {
  @override
  _CadastroRendaPageState createState() => _CadastroRendaPageState();
}

class _CadastroRendaPageState extends State<CadastroRendaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController pagoController = TextEditingController();

  // Lista de categorias para o Dropdown
  List<String> categorias = ["Selecione"];

  @override
  void dispose() {
    nomeController.dispose();
    categoriaController.dispose();
    valorController.dispose();
    pagoController.dispose();
    super.dispose();
  }

  // Função para buscar as categorias da API
  Future<void> buscarCategorias() async {
    String apiUrl = 'https://idailneto.com.br/contas_pessoais/API/Categoria.php?execucao=busca_categorias';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> categoriasData = json.decode(response.body);
        setState(() {
          categorias = [
            "Selecione",
            ...categoriasData.map((cat) => cat['nomeCategoria']).toList()
          ];
        });
      } else {
        throw Exception('Falha ao carregar categorias');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar categorias: $e')),
      );
    }
  }

  // Função para enviar o formulário
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
      ));
    }
  }

  // Função para atualizar categorias após o cadastro de nova categoria
  Future<void> atualizarCategorias() async {
    await buscarCategorias();
  }

  @override
  void initState() {
    super.initState();
    buscarCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Renda"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Categoria",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category),
                          ),
                          value: categorias.isNotEmpty ? categorias[0] : null,
                          items: categorias.map((String categoria) {
                            return DropdownMenuItem<String>(
                              value: categoria,
                              child: Text(categoria),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            categoriaController.text = newValue ?? '';
                          },
                          validator: (value) {
                            if (value == null || value == "Selecione") {
                              return 'Por favor, selecione uma categoria.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        onPressed: () async {
                          final resultado = await showDialog<String>(
                            context: context,
                            builder: (context) => CadastroCategoriaRenda(),
                          );
                          if (resultado != null && resultado.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Categoria "$resultado" adicionada!'),
                              ),
                            );
                            await atualizarCategorias();
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: valorController,
                    decoration: const InputDecoration(
                      labelText: "Valor",
                      prefixIcon: Icon(Icons.monetization_on),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o valor.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Por favor, insira um valor válido.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: pagoController,
                    decoration: const InputDecoration(
                      labelText: "Pago",
                      prefixIcon: Icon(Icons.check_circle),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe se foi pago.';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: submitForm,
                    child: const Text('Cadastrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}