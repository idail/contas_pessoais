import 'dart:convert';
import 'dart:math';

import '/components/modal_sections/modal_project_details/modal_project_details_widget.dart';
import '/components/modals/command_palette/command_palette_widget.dart';
import '/components/web_nav/web_nav_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'cadastroRenda.dart';
import 'main_contracts_model.dart';
export 'main_contracts_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MainContractsWidget extends StatefulWidget {
  final String? tipo_acesso;
  final int? usuariocodigo;
  final int? codigo_departamento_fornecedor;
  final String? email_usuario;
  final String? login_usuario;
  final String? nome_usuario;
  final String? departamentos_gestor;

  const MainContractsWidget(
      {super.key,
      this.usuariocodigo,
      this.tipo_acesso,
      this.codigo_departamento_fornecedor,
      this.email_usuario,
      this.login_usuario,
      this.nome_usuario,
      this.departamentos_gestor});

  @override
  State<MainContractsWidget> createState() => _MainContractsWidgetState();
}

class _MainContractsWidgetState extends State<MainContractsWidget>
    with TickerProviderStateMixin {
  late MainContractsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  // Variáveis para armazenar os pedidos e o estado da paginação
  List<Map<String, dynamic>> pedidos = [];
  int currentPage = 0;
  String texto = '';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainContractsModel());

    _tabController = TabController(length: 3, vsync: this);

    // logFirebaseEvent('screen_view', parameters: {'screen_name': 'Main_Contracts'});
    animationsMap.addAll({
      // Animations...
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    //WidgetsBinding.instance.addPostFrameCallback((_) => loadPedidos());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Função para carregar pedidos da API e atualizar o estado
  // Future<void> loadPedidos() async {

  //   if(widget.tipo_acesso == "gestor")
  //   {
  //     var uri = Uri.parse(
  //       "http://192.168.15.200/np3beneficios_appphp/api/pedidos/busca_pedidos.php?codigo_usuario=${widget.usuariocodigo}&tipo_acesso=${widget.tipo_acesso}&departamentos=${widget.departamentos_gestor}");
  //     var resposta = await http.get(uri, headers: {"Accept": "application/json"});
  //     List<dynamic> data = json.decode(resposta.body);

  //     setState(() {
  //       pedidos = List<Map<String, dynamic>>.from(data);
  //     });
  //   }else{
  //     var uri = Uri.parse(
  //       "http://192.168.15.200/np3beneficios_appphp/api/pedidos/busca_pedidos.php?codigo_usuario=${widget.usuariocodigo}&tipo_acesso=${widget.tipo_acesso}&codigo_fornecedor_departamento=${widget.codigo_departamento_fornecedor}");
  //     var resposta = await http.get(uri, headers: {"Accept": "application/json"});

  //     List<dynamic> data = json.decode(resposta.body);

  //     setState(() {
  //         pedidos = List<Map<String, dynamic>>.from(data);
  //     });
  //   }
  // }

  // Future<void> LerPedido() async {
  //   String code = await FlutterBarcodeScanner.scanBarcode(
  //     "#FFFFFF",
  //     "Cancelar",
  //     false,
  //     ScanMode.QR,
  //   );

  //   if (code != '-1') {
  //     setState(() {
  //       texto = code;
  //       mostrarAlerta("Informação", texto);
  //     });
  //   } else {
  //     setState(() {
  //       texto = 'Leitura de QR Code cancelada';
  //       print(texto);
  //     });
  //   }
  // }

  void mostrarAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Espaçamento no topo
            const SizedBox(height: 50.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHorizontalCard(
                  context,
                  icon: Icons.money_rounded,
                  title: 'Renda',
                  buttonLabel: 'Cadastrar',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 16.0,
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 500,
                              maxWidth: 400,
                            ),
                            child: CadastroRendaPage(),
                          ),
                        );
                      },
                    );
                  },
                  cardWidth: MediaQuery.of(context).size.width *
                      0.4, // Largura dinâmica
                ),
                const SizedBox(width: 10.0),
                _buildHorizontalCard(
                  context,
                  icon: Icons.account_balance_wallet,
                  title: 'Despesa',
                  buttonLabel: 'Cadastrar',
                  onPressed: () {
                    print('Card 2 pressionado');
                  },
                  cardWidth: MediaQuery.of(context).size.width *
                      0.4, // Largura dinâmica
                ),
              ],
            ),

            // Espaçamento entre os cards e o campo de pesquisa
            const SizedBox(height: 20.0),

            // Campo de pesquisa com botão de pesquisa
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Pesquisar...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                    onChanged: (query) {
                      // Adicione a lógica de pesquisa aqui
                      print('Pesquisando: $query');
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.blue,
                  onPressed: () {
                    // Adicione a lógica de pesquisa ao pressionar o botão
                    print('Botão de pesquisa pressionado');
                  },
                ),
              ],
            ),

            // Espaçamento entre o campo de pesquisa e as abas
            const SizedBox(height: 20.0),

            // Abas e Conteúdo
            Expanded(
              child: Column(
                children: [
                  // Abas
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Todos'),
                      Tab(text: 'Ativos'),
                      Tab(text: 'Pagos'),
                    ],
                  ),
                  // Conteúdo das Abas
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildListView([
                          {
                            'nome': 'João',
                            'categoria': 'Alimentos',
                            'pago': 'Sim',
                            'valor': 120.00
                          },
                          {
                            'nome': 'Maria',
                            'categoria': 'Bebidas',
                            'pago': 'Não',
                            'valor': 80.50
                          },
                          {
                            'nome': 'Carlos',
                            'categoria': 'Tecnologia',
                            'pago': 'Não',
                            'valor': 230.75
                          },
                          {
                            'nome': 'Ana',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Idail',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Matheus',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Eliza',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Caroline',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Lucas',
                            'categoria': 'Eletrônicos',
                            'pago': 'Sim',
                            'valor': 180.00
                          },
                          {
                            'nome': 'Juliana',
                            'categoria': 'Móveis',
                            'pago': 'Não',
                            'valor': 250.00
                          },
                        ], context),
                        _buildListView([
                          {
                            'nome': 'Carlos',
                            'categoria': 'Tecnologia',
                            'pago': 'Não',
                            'valor': 230.75
                          },
                          {
                            'nome': 'Ana',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Idail',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Matheus',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Eliza',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Caroline',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Lucas',
                            'categoria': 'Eletrônicos',
                            'pago': 'Sim',
                            'valor': 180.00
                          },
                          {
                            'nome': 'Juliana',
                            'categoria': 'Móveis',
                            'pago': 'Não',
                            'valor': 250.00
                          },
                          {
                            'nome': 'Pedro',
                            'categoria': 'Saúde',
                            'pago': 'Sim',
                            'valor': 100.00
                          },
                          {
                            'nome': 'Patricia',
                            'categoria': 'Saúde',
                            'pago': 'Sim',
                            'valor': 120.00
                          },
                        ], context),
                        _buildListView([
                          {
                            'nome': 'João',
                            'categoria': 'Alimentos',
                            'pago': 'Sim',
                            'valor': 120.00
                          },
                          {
                            'nome': 'Ana',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Idail',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Matheus',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Eliza',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Caroline',
                            'categoria': 'Roupas',
                            'pago': 'Sim',
                            'valor': 150.00
                          },
                          {
                            'nome': 'Lucas',
                            'categoria': 'Eletrônicos',
                            'pago': 'Sim',
                            'valor': 180.00
                          },
                          {
                            'nome': 'Juliana',
                            'categoria': 'Móveis',
                            'pago': 'Sim',
                            'valor': 250.00
                          },
                          {
                            'nome': 'Pedro',
                            'categoria': 'Saúde',
                            'pago': 'Sim',
                            'valor': 100.00
                          },
                          {
                            'nome': 'Patricia',
                            'categoria': 'Saúde',
                            'pago': 'Sim',
                            'valor': 120.00
                          },
                        ], context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(
      List<Map<String, dynamic>> items, BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context)
                  .primaryBackground, // Mesma cor do fundo
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações do item à esquerda
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nome: ${item['nome']}',
                          style:
                              FlutterFlowTheme.of(context).bodyText1.copyWith(
                                    fontSize: 25.0,
                                  ),
                        ),
                        Text(
                          'Categoria: ${item['categoria']}',
                          style: FlutterFlowTheme.of(context)
                              .bodyText2
                              .copyWith(fontSize: 25.0),
                        ),
                        Row(
                          children: [
                            Text(
                              'Pago: ${item['pago']}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .copyWith(fontSize: 25.0),
                            ),
                            SizedBox(
                                width:
                                    10.0), // Espaçamento entre o texto e o quadrado
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                color: item['pago'] == 'Sim'
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(
                                    4.0), // Deixa o quadrado com cantos arredondados
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Valor: R\$ ${item['valor'].toStringAsFixed(2)}',
                          style: FlutterFlowTheme.of(context)
                              .bodyText2
                              .copyWith(fontSize: 25.0),
                        ),
                      ],
                    ),
                  ),

                  // Botões à direita
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print('Alterar pressionado');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Alterar',
                          style:
                              FlutterFlowTheme.of(context).bodyText1.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                        ),
                      ),
                      const SizedBox(
                          height: 8.0), // Espaçamento entre os botões
                      ElevatedButton(
                        onPressed: () {
                          print('Excluir pressionado');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Excluir',
                          style:
                              FlutterFlowTheme.of(context).bodyText1.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHorizontalCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String buttonLabel,
    required VoidCallback onPressed,
    required double cardWidth,
  }) {
    return Card(
      elevation: 0.0, // Removendo sombra extra para seguir o estilo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: cardWidth, // Define a largura do card dinamicamente
        constraints: const BoxConstraints(
          minHeight: 70.0,
          maxWidth: 300.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 3.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 1.0),
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Colors.blue),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 19.0, // Tamanho da fonte ajustado,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
