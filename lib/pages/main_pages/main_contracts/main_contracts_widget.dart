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
  bool exibirSnackbar = false;
  late TabController _tabController;
  late TabController _tabDespesas;

  late Future<List<Map<String, dynamic>>> _todasRendas;
  List<Map<String, dynamic>> _pagos = [];
  List<Map<String, dynamic>> _naoPagos = [];

  @override
  void initState() {
    super.initState();

    rendas();
    _model = createModel(context, () => MainContractsModel());

    _tabController = TabController(length: 3, vsync: this);
    _tabDespesas = TabController(length: 3, vsync: this);

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

  // Future<List<Map<String, dynamic>>> buscaRendas() async {
  //   var resposta =
  //       await http.get(Uri.parse("https://idailneto.com.br/contas_pessoais/API/Renda.php?execucao=busca_rendas"));

  //   if (resposta.statusCode == 200) {
  //     final List<dynamic> rendasJson = json.decode(resposta.body);
  //     final List<Map<String, dynamic>> rendas =
  //         List<Map<String, dynamic>>.from(
  //       rendasJson.map((renda) => Map<String, dynamic>.from(renda)),
  //     );

  //     // Separar os pedidos pagos e não pagos
  //     _pagos = rendas.where((renda) => renda['pago_renda'] == 'Sim').toList();
  //     _naoPagos = rendas.where((renda) => renda['pago_renda'] == 'Não').toList();

  //     return rendas;
  //   } else {
  //     throw Exception('Falha ao carregar pedidos');
  //   }
  // }

  Future<List<Map<String, dynamic>>> rendas() async {
    final String apiUrl =
        'https://idailneto.com.br/contas_pessoais/API/Renda.php?execucao=busca_rendas'; // Substitua pela URL da sua API
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Erro ao buscar dados: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar-se à API: $e');
    }
  }

  List<Map<String, dynamic>> filterData(
      List<Map<String, dynamic>> data, String filter) {
    if (filter == 'Todos') {
      return data; // Retorna todos os itens
    } else if (filter == 'Ativos') {
      return data
          .where((item) => item['pago_renda'] == 'Não')
          .toList(); // Filtra ativos (não pagos)
    } else if (filter == 'Pagos') {
      return data
          .where((item) => item['pago_renda'] == 'Sim')
          .toList(); // Filtra pagos
    } else {
      return []; // Caso não haja filtro correspondente
    }
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
                    // Exibe o diálogo de cadastro
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
                              maxHeight: 580,
                              maxWidth: 400,
                            ),
                            child: Builder(
                              builder: (BuildContext modalContext) {
                                // Passa o modalContext para o CadastroRendaPage
                                return CadastroRendaPage(
                                  context: modalContext,
                                  // A função de callback agora será chamada após o fechamento do diálogo
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ).then((_) {
                      // Aqui, a função rendas() será chamada quando o diálogo for fechado
                      setState(() {
                        rendas();
                      });
                    });
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
                      hintText: 'Pesquisar renda...',
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

            Flexible(
              flex: 2, // Aumente o valor para expandir mais altura
              child: RefreshIndicator(
                onRefresh: () async {
                  // Chama a função rendas() ao arrastar para baixo
                  print("puxou");
                  setState(() {
                    // Aqui você pode chamar o método que realiza a atualização dos dados
                  });
                },
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: rendas(), // Carrega os dados com a função rendas
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return Column(
                        children: [
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
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildListView(
                                    filterData(data, 'Todos'), context),
                                _buildListView(
                                    filterData(data, 'Ativos'), context),
                                _buildListView(
                                    filterData(data, 'Pagos'), context),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                          child: Text('Nenhum dado encontrado.'));
                    }
                  },
                ),
              ),
            ),

            // Espaçamento entre o campo de pesquisa e as abas
            const SizedBox(height: 20.0),

            // Campo de pesquisa com botão de pesquisa
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Pesquisar despesa...',
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

            // Use o RefreshIndicator para ativar o pull-to-refresh
            Flexible(
              flex: 2, // Aumente o valor para expandir mais altura
              child: RefreshIndicator(
                onRefresh: () async {
                  // Chama a função rendas() ao arrastar para baixo
                  print("puxou");
                  // Refresca o FutureBuilder chamando rendas() novamente
                  setState(() {
                    // Aqui você pode chamar o método que realiza a atualização dos dados
                  });
                },
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: rendas(), // Carrega os dados com a função rendas
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return Column(
                        children: [
                          TabBar(
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.blue,
                            controller: _tabDespesas,
                            tabs: const [
                              Tab(text: 'Todos'),
                              Tab(text: 'Ativos'),
                              Tab(text: 'Pagos'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabDespesas,
                              children: [
                                _buildListView(
                                    filterData(data, 'Todos'), context),
                                _buildListView(
                                    filterData(data, 'Ativos'), context),
                                _buildListView(
                                    filterData(data, 'Pagos'), context),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                          child: Text('Nenhum dado encontrado.'));
                    }
                  },
                ),
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
            width: double
                .infinity, // Garante que o container ocupe toda a largura da tela
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor, // Fundo do card
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
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
                          'Nome: ${item['nome_renda']}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize:
                                      20), // Aumentando o tamanho da fonte
                        ),
                        Text(
                          'Categoria: ${item['categoria_renda']}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize:
                                      16), // Aumentando o tamanho da fonte
                        ),
                        Row(
                          children: [
                            Text(
                              'Pago: ${item['pago_renda']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontSize:
                                          16), // Aumentando o tamanho da fonte
                            ),
                            const SizedBox(width: 10.0),
                            Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                color: item['pago_renda'] == 'Sim'
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Valor: R\$ ${item['valor_renda'].toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize:
                                      16), // Aumentando o tamanho da fonte
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
                          var codigoRenda = item['codigo_renda'];
                          print("Alterar pressionado $codigoRenda");
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
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          var codigoRenda = item['codigo_renda'];
                          print("Excluir pressionado $codigoRenda");
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
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white),
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
