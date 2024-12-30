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
  int? codigousuario;

  @override
  CadastroRendaPage(
      {Key? key,
      required this.context,
      required this.nomerenda,
      required this.categoriarenda,
      required this.valorrenda,
      required this.pagorenda,
      required this.codigorenda,
      required this.execucao,
      required this.codigousuario})
      : super(key: key);

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

  String? categoriaSelecionada;

  bool exibirSnackbar = false;

  late String mensagemSucesso;
  late String mensagemErro;
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
        'https://idailneto.com.br/contas_pessoais/API/Categoria.php';

    try {
      // Monta os parâmetros da requisição GET
      final queryParameters = {
        "codigo_usuario": widget.codigousuario.toString(),
        "execucao": "busca_categorias_renda",
      };

      // Cria a URI com os parâmetros de consulta
      final uri = Uri.parse(apiUrl).replace(queryParameters: queryParameters);

      // Realiza a requisição GET
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );

      // Verifica o status da resposta
      if (response.statusCode == 200) {
        var retorno = jsonDecode(response.body);

        // Trata o caso em que a API retorna "nada"
        if (retorno == "nada") {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nenhum registro localizado')),
            );
          }
          return; // Interrompe a execução
        }

        // Continua o processamento normal se o retorno não for "nada"
        final List<dynamic> categoriasData = retorno;

        // Atualiza o estado com as categorias recebidas
        if (mounted) {
          setState(() {
            categorias = [
              "Selecione",
              ...categoriasData
                  .map((cat) => cat['nome_categoria'] ?? 'Sem Nome')
                  .toList(),
            ];
          });
        }

        // Define a categoria selecionada com base na execução
        if (widget.execucao == "alterar_renda" &&
            categorias.contains(widget.categoriarenda)) {
          categoriaSelecionada = widget.categoriarenda;
        } else if (widget.execucao == "cadastrar_renda") {
          categoriaSelecionada = "Selecione";
        }
      } else {
        // Log de erro para debugging
        print('Erro na API: ${response.statusCode}, corpo: ${response.body}');
        throw Exception('Falha ao carregar categorias');
      }
    } catch (e) {
      // Exibe o erro no SnackBar e log para debugging
      print('Erro no método buscarCategorias: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar categorias: $e')),
        );
      }
    }
  }

  void carregarDadosIniciais() {
    buscarCategorias().then((_) {
      if (widget.execucao == "alterar_renda") {
        setState(() {
          nomeRenda.text = widget.nomerenda ?? "";
          valorRenda.text = widget.valorrenda?.toString() ?? "";
          pagoRenda.text = widget.pagorenda ?? "";
        });
      }
    });
  }

  Future<bool> cadastrarRenda() async {
    if (_formKey.currentState!.validate()) {
      var uri =
          Uri.parse("https://idailneto.com.br/contas_pessoais/API/Renda.php");

      var valorCadastrarRenda = jsonEncode({
        "execucao": widget.execucao,
        "nome_renda": nomeRenda.text,
        "categoria_renda": categoriaSelecionada,
        "valor_renda": valorRenda.text,
        "pago_renda": pagoRenda.text,
        "codigo_renda": widget.codigousuario.toString()
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
          String resultadoCadastrarRenda =
              jsonDecode(respostaCadastrarRenda.body);
          if (int.parse(resultadoCadastrarRenda) > 0) {
            return true;
          }
        } else {
          return false;
        }
      } catch (e) {
        print("Erro na requisição: $e");
        return false;
      }
    }
    return false;
  }

  Future<bool> alterarRenda() async {
    if (_formKey.currentState!.validate()) {
      var uri =
          Uri.parse("https://idailneto.com.br/contas_pessoais/API/Renda.php");

      var valorCadastrarRenda = jsonEncode({
        "execucao": widget.execucao,
        "nome_renda": nomeRenda.text,
        "categoria_renda": categoriaSelecionada,
        "valor_renda": valorRenda.text,
        "pago_renda": pagoRenda.text,
        "codigo_renda": widget.codigorenda
      });

      print(valorCadastrarRenda);

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
          String resultadoAlterarRenda =
              jsonDecode(respostaCadastrarRenda.body);
          if(resultadoAlterarRenda == "renda alterada")
          {
            return true;
          }

          //var retornoCadastrarRenda = jsonDecode(respostaCadastrarRenda.body);

          // Exibe a mensagem de sucesso
          //exibirMensagem();
        }else{
          return false;
        }
      } catch (e) {
        print("Erro na requisição: $e");
        return false;
      }
    }
    return false;
  }

  // Função para atualizar categorias após o cadastro de nova categoria
  Future<void> atualizarCategorias() async {
    await buscarCategorias();
  }

  // Exibir mensagem de sucesso e ocultar após 4 segundos
  // Exibir mensagem de sucesso e ocultar após 4 segundos
  Future<void> exibirMensagem() async {
    setState(() {
      // Define a mensagem para exibição
      exibirMensagemSucesso = true; // Ou false dependendo da lógica
    });

    // Oculta a mensagem após 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          exibirMensagemSucesso = null;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    carregarDadosIniciais(); // Chama o método assíncrono sem await
  }

  //static bool exibirSnackbar = false; // Variável de controle para o Snackbar
  // Variável para controlar a exibição da mensagem
  bool? exibirMensagemSucesso;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.execucao == 'cadastrar_renda'
            ? 'Cadastro de Renda'
            : 'Alterar Renda'),
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
                            prefixIcon: Icon(Icons.category),
                          ),
                          value: categoriaSelecionada,
                          items: categorias.map((String categoria) {
                            return DropdownMenuItem<String>(
                              value: categoria,
                              child: Text(categoria),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              categoriaSelecionada = newValue;
                            });
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
                            builder: (context) => CadastroCategoriaRenda(
                              codigoUsuarioLogado: widget.codigousuario,
                              tipo_cadastro: "renda",
                            ),
                          );
                          if (resultado != null && resultado.isNotEmpty) {
                            setState(() {
                              categorias.add(resultado);
                              categoriaSelecionada = resultado;
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
                          // Botão Gravar
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (widget.execucao == "cadastrar_renda") {
                                  try {
                                    final sucesso =
                                        await cadastrarRenda(); // Retorna true/false
                                    if (mounted) {
                                      setState(() {
                                        if (sucesso) {
                                          mensagemSucesso =
                                              "Renda cadastrada com sucesso!";
                                          exibirMensagem();
                                          exibirMensagemSucesso = true;
                                        } else {
                                          mensagemErro =
                                              "Erro ao cadastrar renda.";
                                          exibirMensagem();
                                          exibirMensagemSucesso = false;
                                        }
                                      });
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      setState(() {
                                        mensagemErro =
                                            "Erro ao cadastrar renda: ${e.toString()}";
                                      exibirMensagem();      
                                        exibirMensagemSucesso = false;
                                      });
                                    }
                                  }
                                } else if (widget.execucao == "alterar_renda") {
                                  try {
                                    final sucesso =
                                        await alterarRenda(); // Retorna true/false
                                    if (mounted) {
                                      setState(() {
                                        if (sucesso) {
                                          mensagemSucesso =
                                              "Renda alterada com sucesso!";
                                          exibirMensagem();
                                          exibirMensagemSucesso = true;
                                        } else {
                                          mensagemErro =
                                              "Erro ao alterar renda.";
                                          exibirMensagem();
                                          exibirMensagemSucesso = false;
                                        }
                                      });
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      setState(() {
                                        mensagemErro =
                                            "Erro ao alterar renda: ${e.toString()}";
                                      exibirMensagem();
                                        exibirMensagemSucesso = false;
                                      });
                                    }
                                  }
                                }
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
                                if (mounted) {
                                  setState(() {
                                    exibirMensagemSucesso = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                              child: const Text('Limpar'),
                            ),
                          ),
                        ],
                      ),

                      // Exibir mensagem de sucesso abaixo dos botões, condicionalmente
                      if (exibirMensagemSucesso != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            width: double
                                .infinity, // Garante que o Container ocupe toda a largura
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: exibirMensagemSucesso == true
                                  ? Colors.green // Verde para sucesso
                                  : Colors.red, // Vermelho para erro
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              exibirMensagemSucesso == true
                                  ? mensagemSucesso // Mensagem de sucesso
                                  : mensagemErro, // Mensagem de erro
                              textAlign: TextAlign
                                  .center, // Centraliza o texto na largura do container
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
