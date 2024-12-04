import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CadastroCategoriaRenda extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nomeCategoriaRenda = TextEditingController();

  var retornoCadastrarCategoriaRenda;

  Future<String?> cadastrarCategoriaRenda(BuildContext context) async {
    var uri =
        Uri.parse("https://idailneto.com.br/contas_pessoais/API/Categoria.php");

    print(nomeCategoriaRenda.text);

    var valorCadastrarCategoriaRenda = jsonEncode({
      "nome_categoria_renda": nomeCategoriaRenda.text,
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

      if(respostaCadastrarCategoriaRenda.statusCode == 200){
        retornoCadastrarCategoriaRenda = jsonDecode(respostaCadastrarCategoriaRenda.body);

        var valorCodigoCategoriaRenda = int.parse(retornoCadastrarCategoriaRenda);

        return nomeCategoriaRenda.text;
      }
    } catch (e) {
      print("Erro na requisição: $e");
    }

    return null; // Retorna null em caso de falha
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
                controller: nomeCategoriaRenda,
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
                      final resultado = await cadastrarCategoriaRenda(context);
                      Navigator.of(context).pop(resultado); // Fecha a modal retornando o resultado
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
