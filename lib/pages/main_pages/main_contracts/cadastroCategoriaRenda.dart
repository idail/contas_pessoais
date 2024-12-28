import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CadastroCategoriaRenda extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nomeCategoria = TextEditingController();

  int? codigoUsuarioLogado; // Código do usuário logado passado como parâmetro
  String? tipo_cadastro;

  var retornoCadastrarCategoriaRenda;

  CadastroCategoriaRenda(
      {required this.codigoUsuarioLogado,
      required this.tipo_cadastro}); // Construtor atualizado

  Future<String?> cadastrarCategoria(BuildContext context) async {
    var uri =
        Uri.parse("https://idailneto.com.br/contas_pessoais/API/Categoria.php");

    //print(nomeCategoriaRenda.text);

    if (tipo_cadastro == "renda") {
      var valorCadastrarCategoriaRenda = jsonEncode({
        "execucao": "cadastrar_categoria_renda",
        "nome_categoria_renda": nomeCategoria.text,
        "codigo_usuario_renda": codigoUsuarioLogado,
      });

      try {
        var respostaCadastrarCategoriaRenda = await http.post(
          uri,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: valorCadastrarCategoriaRenda,
        );

        if (respostaCadastrarCategoriaRenda.statusCode == 200) {
          retornoCadastrarCategoriaRenda =
              jsonDecode(respostaCadastrarCategoriaRenda.body);

          var valorCodigoCategoriaRenda =
              int.parse(retornoCadastrarCategoriaRenda);

          return nomeCategoria.text;
        }
      } catch (e) {
        print("Erro na requisição: $e");
      }

      return null; // Retorna null em caso de falha
    } else {
      var valorCadastrarCategoriaRenda = jsonEncode({
        "execucao": "cadastrar_categoria_despesa",
        "nome_categoria_despesa": nomeCategoria.text,
        "codigo_usuario_despesa": codigoUsuarioLogado,
      });

      try {
        var respostaCadastrarCategoriaRenda = await http.post(
          uri,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: valorCadastrarCategoriaRenda,
        );

        if (respostaCadastrarCategoriaRenda.statusCode == 200) {
          retornoCadastrarCategoriaRenda =
              jsonDecode(respostaCadastrarCategoriaRenda.body);

          var valorCodigoCategoriaRenda =
              int.parse(retornoCadastrarCategoriaRenda);

          return nomeCategoria.text;
        }
      } catch (e) {
        print("Erro na requisição: $e");
      }

      return null; // Retorna null em caso de falha
    }
  }

  // void mostrarAlerta(BuildContext context,String titulo, String mensagem) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(titulo),
  //         content: Text(mensagem),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    bool sucesso = false; // Controle para exibir a mensagem de sucesso
    String tipoMensagem = ""; // Variável para armazenar a mensagem dinâmica

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: const Text(
            "Cadastro de Categoria",
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Altura ajustada ao conteúdo
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo Nome
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: nomeCategoria,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      prefixIcon: Icon(Icons.label),
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

                // Botão de Salvar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final resultado = await cadastrarCategoria(context);

                          // Define a mensagem de acordo com o tipo de cadastro
                          setState(() {
                            sucesso = true;
                            tipoMensagem = (tipo_cadastro == "cadastrar_renda")
                                ? "Categoria da renda gravada!"
                                : "Categoria da despesa gravada!";
                          });

                          // Aguarda 3 segundos antes de fechar a modal
                          await Future.delayed(const Duration(seconds: 3));

                          // Passa a mensagem como resultado ao fechar a modal
                          Navigator.of(context).pop(resultado);
                        }
                      },
                      child: const Text('Salvar'),
                    ),
                  ),
                ),

                // Mensagem de sucesso abaixo do botão
                if (sucesso)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.only(top: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      tipoMensagem,
                      style:
                          const TextStyle(color: Colors.green, fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}