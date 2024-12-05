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
  TextEditingController nomeRenda = TextEditingController();
  TextEditingController categoriaRenda = TextEditingController();
  TextEditingController valorRenda = TextEditingController();
  TextEditingController pagoRenda = TextEditingController();

  // Lista de categorias para o Dropdown
  List<String> categorias = ["Selecione"];

  @override
  void dispose() {
    nomeRenda.dispose();
    categoriaRenda.dispose();
    valorRenda.dispose();
    pagoRenda.dispose();
    super.dispose();
  }

  Future<void> buscarCategorias() async {
    String apiUrl =
        'https://idailneto.com.br/contas_pessoais/API/Categoria.php?execucao=busca_categorias';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> categoriasData = json.decode(response.body);

        print(categoriasData); // Para verificar a estrutura da resposta
        setState(() {
          categorias = [
            "Selecione",
            ...categoriasData
                .map((cat) => cat['nome_categoria'] ?? 'Sem Nome')
                .toList(),
          ];
        });
      } else {
        throw Exception('Falha ao carregar categorias');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar categorias: $e')),
      );
    }
  }

  // Função para enviar o formulário
  Future<int?> cadastrarRenda() async {
    if (_formKey.currentState!.validate()) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('Cadastro realizado com sucesso!'),
      // ));

      var uri = Uri.parse(
          "https://idailneto.com.br/contas_pessoais/API/Categoria.php");

      var valorCadastrarRenda = jsonEncode({
        "execucao": "cadastrar_renda",
        "nome_renda": nomeRenda.text,
        "categoria_renda": categoriaRenda.text,
        "valor_renda": valorRenda.text,
        "pago_renda": pagoRenda.text,
      });

      try {
        var respostaCadastrarRenda = await http.post(
          uri,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: valorCadastrarRenda,
        );

        if(respostaCadastrarRenda.statusCode == 200){
          var retornoCadastrarRenda = jsonDecode(respostaCadastrarRenda.body);

          var valorCodigoRenda = int.parse(retornoCadastrarRenda);

          return valorCodigoRenda;
        }
      } catch (e) {
        print("Erro na requisição: $e");
      }

      return null;
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
                    controller: nomeRenda,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      prefixIcon: Icon(Icons.account_balance_wallet),
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
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          value: categorias.isNotEmpty ? categorias[0] : null,
                          items: categorias.map((String categoria) {
                            return DropdownMenuItem<String>(
                              value: categoria,
                              child: Text(categoria),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            categoriaRenda.text = newValue ?? '';
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
                    controller: valorRenda,
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
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Pago",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.check_circle),
                    ),
                    value: pagoRenda.text.isNotEmpty ? pagoRenda.text : null,
                    items: ['Sim', 'Não'].map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      pagoRenda.text = newValue ?? '';
                    },
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
                  child: Row(
                    children: [
                      // Botão Cadastrar
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            cadastrarRenda();
                          },
                          child: const Text('Cadastrar'),
                        ),
                      ),
                      const SizedBox(width: 8.0), // Espaçamento entre os botões
                      // Botão Limpar
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Ação para limpar os campos do formulário
                            nomeRenda.clear();
                            valorRenda.clear();
                            pagoRenda.clear();
                            categoriaRenda.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Cor cinza
                          ),
                          child: const Text('Limpar'),
                        ),
                      ),
                    ],
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
