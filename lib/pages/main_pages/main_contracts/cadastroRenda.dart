import 'package:financas/pages/main_pages/main_contracts/cadastroCategoriaRenda.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    nomeController.dispose();
    categoriaController.dispose();
    valorController.dispose();
    pagoController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      // Aqui você pode manipular os dados para enviar ao backend ou fazer outras ações.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Renda"),
      ),
      body: SingleChildScrollView(
        // Adicione este widget
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

                // Campo Categoria com Select List e botão "+"
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
                          value: null,
                          items: const [
                            DropdownMenuItem(
                              value: null,
                              child: Text('Selecione'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            categoriaController.text = newValue ?? '';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
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

                          if (resultado != null) {
                            print("Categoria cadastrada: $resultado");
                            // Atualize sua lista de categorias aqui
                          }
                        },
                        icon: Icon(Icons.add, color: Colors.blue),
                      ),
                    ],
                  ),
                ),

                // Campo Valor
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

                // Campo Pago
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

                // Botão de Submissão
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: submitForm,
                    child: Text('Cadastrar'),
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
