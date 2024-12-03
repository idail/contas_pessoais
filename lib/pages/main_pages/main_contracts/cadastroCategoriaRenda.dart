import 'package:flutter/material.dart';

class CadastroCategoriaRenda extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nomeCategoriaRenda = TextEditingController();

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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Fecha a modal retornando o nome da categoria
                      Navigator.of(context).pop(nomeCategoriaRenda.text);
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