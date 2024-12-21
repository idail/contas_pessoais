import 'dart:convert';
import 'package:financas/pages/main_pages/main_contracts/cadastroCategoriaRenda.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CadastroRendaPage extends StatefulWidget {
  final BuildContext context; // Novo parâmetro

  String? nomerenda;
  String? categoriarenda;
  int? valorrenda;
  String? pagorenda;
  int? codigorenda;
  String? execucao;


  @override
  CadastroRendaPage({Key? key, required this.context, required this.nomerenda, required this.categoriarenda, required this.valorrenda, required this.pagorenda, required this.codigorenda, required this.execucao}) : super(key: key);

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

  //bool exibirSnackbar = false;
  //static bool exibirSnackbar = false;

  bool exibirSnackbar = false;
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

  Future<void> cadastrarRenda() async {
    if (_formKey.currentState!.validate()) {
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

        if (respostaCadastrarRenda.statusCode == 200) {
          var retornoCadastrarRenda = jsonDecode(respostaCadastrarRenda.body);

          // Exibe a mensagem de sucesso
          exibirMensagem();
        }
      } catch (e) {
        print("Erro na requisição: $e");
      }
    }
  }

  // Função para atualizar categorias após o cadastro de nova categoria
  Future<void> atualizarCategorias() async {
    await buscarCategorias();
  }

  // Exibir mensagem de sucesso e ocultar após 4 segundos
  Future<void> exibirMensagem() async {
    setState(() {
      exibirMensagemSucesso = true;
    });

    // Atraso de 4 segundos
    await Future.delayed(const Duration(seconds: 4));

    setState(() {
      exibirMensagemSucesso = false;
    });
  }

  @override
  void initState() {
    super.initState();
    buscarCategorias();
  }

  //static bool exibirSnackbar = false; // Variável de controle para o Snackbar
  // Variável para controlar a exibição da mensagem
  bool exibirMensagemSucesso = false;
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
                // Campo Nome
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
                // Campo Categoria
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
                            setState(() {
                              categorias.add(resultado);
                            });
                            await atualizarCategorias();
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                // Campo Valor
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: valorRenda,
                    decoration: const InputDecoration(
                      labelText: "Valor",
                      prefixIcon: Icon(Icons.monetization_on),
                      prefixText: "R\$ ",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o valor.';
                      }
                      final unformattedValue =
                          value.replaceAll(RegExp(r'[^0-9]'), '');
                      if (double.tryParse(unformattedValue) == null ||
                          double.parse(unformattedValue) <= 0) {
                        return 'Por favor, insira um valor válido maior que zero.';
                      }
                      return null;
                    },
                  ),
                ),
                // Campo Pago
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
                // Botões de Ação
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      // Botões de Ação
                      Row(
                        children: [
                          // Botão Cadastrar
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {

                                if(widget.execucao == "cadastrar_renda")
                                {
                                  await cadastrarRenda();
                                }else{

                                }

                                

                                // Exibir SnackBar com a mensagem de sucesso
                                // ScaffoldMessenger.of(widget.context)
                                //     .showSnackBar(
                                //   const SnackBar(
                                //     content: Text(
                                //       'Renda cadastrada com sucesso!',
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.bold),
                                //     ),
                                //     backgroundColor: Colors.green,
                                //     duration: Duration(seconds: 3),
                                //   ),
                                // );
                              },
                              child: const Text('Gravar'),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          // Botão Limpar
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                nomeRenda.clear();
                                valorRenda.clear();
                                pagoRenda.clear();
                                categoriaRenda.clear();
                                setState(() {
                                  exibirMensagemSucesso = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              child: const Text('Limpar'),
                            ),
                          ),
                        ],
                      ),

                      //Exibir mensagem de sucesso abaixo dos botões, condicionalmente
                      if (exibirMensagemSucesso)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            width: double
                                .infinity, // Garante que o Container ocupe toda a largura
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text(
                              'Renda cadastrada com sucesso!',
                              textAlign: TextAlign
                                  .center, // Centraliza o texto na largura do container
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
