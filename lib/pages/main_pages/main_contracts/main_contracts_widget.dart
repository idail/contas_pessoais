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
  final String? email_usuario;
  final String? login_usuario;
  final String? nome_usuario;
  final String? departamentos_gestor;

  const MainContractsWidget(
      {super.key,
      this.usuariocodigo,
      this.tipo_acesso,
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
  //List<Map<String, dynamic>> pedidos = [];
  int currentPage = 0;
  String texto = '';
  bool exibirSnackbar = false;
  late TabController _tabController;

  List<Map<String, dynamic>> items = [];

  late Future<List<Map<String, dynamic>>> _todasRendas;
  List<Map<String, dynamic>> _pagos = [];
  List<Map<String, dynamic>> _naoPagos = [];
  TextEditingController filtroRenda = new TextEditingController();
  List<Map<String, dynamic>> listarendas = [];
  late Future<List<Map<String, dynamic>>> _futureRendas;

  @override
  void initState() {
    super.initState();

    _futureRendas = rendas(); // Inicializa o Future com todos os dados.
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

  // Future<List<Map<String, dynamic>>> rendas() async {
  //   String opcao =
  //       filtroRenda.text.trim().isEmpty ? "todos" : "busca_nome_renda";

  //   const String uriBuscaRenda =
  //       'https://idailneto.com.br/contas_pessoais/API/Renda.php';

  //   try {
  //     // Limpa a lista antes de realizar a requisição
  //     listarendas.clear();

  //     // Criando a URI com query parameters
  //     final uri = Uri.parse(uriBuscaRenda).replace(queryParameters: {
  //       "execucao": "busca_rendas",
  //       "opcao": opcao,
  //       "filtro": filtroRenda.text.trim(),
  //     });

  //     // Fazendo a requisição GET
  //     final response = await http.get(uri);

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body) as List;

  //       // Atualiza a lista `listarendas` com os novos dados
  //       listarendas =
  //           data.map((item) => Map<String, dynamic>.from(item)).toList();
  //       return listarendas;
  //     } else {
  //       throw Exception('Erro ao buscar dados: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Erro ao conectar-se à API: $e');
  //   }
  // }

  Future<List<Map<String, dynamic>>> rendas() async {
    String opcao =
        filtroRenda.text.trim().isEmpty ? "todos" : "busca_nome_renda";

    const String uriBuscaRenda =
        'https://idailneto.com.br/contas_pessoais/API/Renda.php';

    try {
      final uri = Uri.parse(uriBuscaRenda).replace(queryParameters: {
        "execucao": "busca_rendas",
        "opcao": opcao,
        "filtro": filtroRenda.text.trim(),
        "codigo_usuario_renda": widget.usuariocodigo.toString()
      });

      final response = await http.get(uri);

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

  void _buscarRendas() {
    setState(() {
      _futureRendas = rendas(); // Atualiza o Future com os filtros aplicados.
    });
  }

  Future<void> deletarRenda(BuildContext contexto, int codigoRenda) async {
    var uri =
        Uri.parse("https://idailneto.com.br/contas_pessoais/API/Renda.php");

    var valorExcluirRenda =
        jsonEncode({"execucao": "excluir_renda", "codigo_renda": codigoRenda});

    try {
      var respostaDeletarRenda = await http.delete(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: valorExcluirRenda,
      );

      if (respostaDeletarRenda.statusCode == 200) {
        print(respostaDeletarRenda.body);

        var retornoDeletarRenda = jsonDecode(respostaDeletarRenda.body);

        if(retornoDeletarRenda == "renda excluida")
        {
          // Exibe a mensagem de sucesso
          exibirMensagem(context,"renda excluida");
        }else{
          exibirMensagem(context,"renda nao excluida");
        }

        // setState(() {
        //   rendas();
        // });
      } else {
        print(
            "Erro na requisição DELETE: ${respostaDeletarRenda.statusCode} - ${respostaDeletarRenda.reasonPhrase}");
      }
    } catch (e) {
      print("Erro na requisição: $e");
      exibirMensagem(context,"renda nao excluida");
    }
  }

  List<Map<String, dynamic>> filterData(
      List<Map<String, dynamic>> data, String filter) {
    if (filter == 'Todos') {
      print(data);
      return data; // Retorna todos os itens
    } else if (filter == 'Ativos') {
      print(data);
      return data
          .where((item) => item['pago_renda'] == 'Não')
          .toList(); // Filtra ativos (não pagos)
    } else if (filter == 'Pagos') {
      print(data);
      return data
          .where((item) => item['pago_renda'] == 'Sim')
          .toList(); // Filtra pagos
    } else {
      return []; // Caso não haja filtro correspondente
    }
  }

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
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: !isWeb
          ? AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              automaticallyImplyLeading: false,
              // Título da appBar removido
              // title: Text(
              //   FFLocalizations.of(context)
              //       .getText('y24lcr13' /* Dashboard */),
              //   style: FlutterFlowTheme.of(context).displaySmall.override(
              //         fontFamily: 'Outfit',
              //         color: Colors.white,
              //         letterSpacing: 0.0,
              //       ),
              // ).animateOnPageLoad(
              //     animationsMap['textOnPageLoadAnimation20']!),
              centerTitle: false,
              elevation: 0.0,
              // Mantendo apenas o botão de abrir o menu (Drawer)
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
            )
          : null,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Cabeçalho com o nome da pessoa logada
            DrawerHeader(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary,
              ),
              child: Center(
                // Centraliza o conteúdo no centro do DrawerHeader
                child: Text(
                  'Olá, ${widget.nome_usuario ?? "Usuário"}',
                  textAlign:
                      TextAlign.center, // Garante alinhamento central do texto
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            // Botão de ajuda com ícone centralizado e texto abaixo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                onTap: () {
                  // Ação quando o item for clicado
                  print("Ajuda clicada");
                },
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                title: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.help_rounded,
                      size: 32.0,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "Informar erro, sugestões",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            // Aqui você pode adicionar mais itens do menu
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Espaçamento no topo
            const SizedBox(height: 50.0),

            Row(
              children: [
                Expanded(
                  // Expande o botão para ocupar toda a largura
                  child: _buildHorizontalCard(
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
                            backgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                                    nomerenda: "",
                                    categoriarenda: "",
                                    valorrenda: 0,
                                    pagorenda: "",
                                    codigorenda: 0,
                                    execucao: "cadastrar_renda",
                                    codigousuario: widget.usuariocodigo,
                                    // A função de callback agora será chamada após o fechamento do diálogo
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ).then((_) {
                        // Aqui, a função rendas() será chamada quando o diálogo for fechado
                        // setState(() {
                        //   rendas();
                        // });
                        _buscarRendas();
                      });
                    },
                    cardWidth: MediaQuery.of(context)
                        .size
                        .width, // Largura dinâmica total
                  ),
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
                    controller: filtroRenda,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar pelo nome...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      //prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    ),
                    onChanged: (query) {
                      // Adicione a lógica de pesquisa aqui
                      print('Pesquisando: $query');
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.blue,
                  onPressed: () {
                    // Adicione a lógica de pesquisa ao pressionar o botão
                    //print('Botão de pesquisa pressionado');
                    _buscarRendas();
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
                // child: FutureBuilder<List<Map<String, dynamic>>>(
                //   future: rendas(), // Carrega os dados com a função rendas
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(child: CircularProgressIndicator());
                //     } else if (snapshot.hasError) {
                //       return Center(child: Text('Erro: ${snapshot.error}'));
                //     } else if (snapshot.hasData) {
                //       final data = snapshot.data!;
                //       return Column(
                //         children: [
                //           TabBar(
                //             labelColor: Colors.blue,
                //             unselectedLabelColor: Colors.grey,
                //             indicatorColor: Colors.blue,
                //             controller: _tabController,
                //             tabs: const [
                //               Tab(text: 'Todos'),
                //               Tab(text: 'Ativos'),
                //               Tab(text: 'Pagos'),
                //             ],
                //           ),
                //           Expanded(
                //             child: TabBarView(
                //               controller: _tabController,
                //               children: [
                //                 _buildListView(
                //                     filterData(data, 'Todos'), context),
                //                 _buildListView(
                //                     filterData(data, 'Ativos'), context),
                //                 _buildListView(
                //                     filterData(data, 'Pagos'), context),
                //               ],
                //             ),
                //           ),
                //         ],
                //       );
                //     } else {
                //       return const Center(
                //           child: Text('Nenhum dado encontrado.'));
                //     }
                //   },
                // ),

                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _futureRendas, // Usa o Future atualizado.
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                                    filterData(snapshot.data!, 'Todos'),
                                    context),
                                _buildListView(
                                    filterData(snapshot.data!, 'Ativos'),
                                    context),
                                _buildListView(
                                    filterData(snapshot.data!, 'Pagos'),
                                    context),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('Nenhuma renda encontrada.'),
                      );
                    }
                  },
                ),
              ),
            ),

            // Espaçamento entre o campo de pesquisa e as abas
            const SizedBox(height: 20.0),

            // // Campo de pesquisa com botão de pesquisa
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           hintText: 'Pesquisar despesa...',
            //           hintStyle: TextStyle(color: Colors.grey),
            //           border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(12),
            //             borderSide: BorderSide(color: Colors.grey),
            //           ),
            //           prefixIcon: Icon(Icons.search, color: Colors.grey),
            //         ),
            //         onChanged: (query) {
            //           // Adicione a lógica de pesquisa aqui
            //           print('Pesquisando: $query');
            //         },
            //       ),
            //     ),
            //     IconButton(
            //       icon: Icon(Icons.search),
            //       color: Colors.blue,
            //       onPressed: () {
            //         // Adicione a lógica de pesquisa ao pressionar o botão
            //         print('Botão de pesquisa pressionado');
            //       },
            //     ),
            //   ],
            // ),

            // Use o RefreshIndicator para ativar o pull-to-refresh
            // Flexible(
            //   flex: 2, // Aumente o valor para expandir mais altura
            //   child: RefreshIndicator(
            //     onRefresh: () async {
            //       // Chama a função rendas() ao arrastar para baixo
            //       print("puxou");
            //       // Refresca o FutureBuilder chamando rendas() novamente
            //       setState(() {
            //         // Aqui você pode chamar o método que realiza a atualização dos dados
            //       });
            //     },
            //     child: FutureBuilder<List<Map<String, dynamic>>>(
            //       future: rendas(), // Carrega os dados com a função rendas
            //       builder: (context, snapshot) {
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return const Center(child: CircularProgressIndicator());
            //         } else if (snapshot.hasError) {
            //           return Center(child: Text('Erro: ${snapshot.error}'));
            //         } else if (snapshot.hasData) {
            //           final data = snapshot.data!;
            //           return Column(
            //             children: [
            //               TabBar(
            //                 labelColor: Colors.blue,
            //                 unselectedLabelColor: Colors.grey,
            //                 indicatorColor: Colors.blue,
            //                 controller: _tabDespesas,
            //                 tabs: const [
            //                   Tab(text: 'Todos'),
            //                   Tab(text: 'Ativos'),
            //                   Tab(text: 'Pagos'),
            //                 ],
            //               ),
            //               Expanded(
            //                 child: TabBarView(
            //                   controller: _tabDespesas,
            //                   children: [
            //                     _buildListView(
            //                         filterData(data, 'Todos'), context),
            //                     _buildListView(
            //                         filterData(data, 'Ativos'), context),
            //                     _buildListView(
            //                         filterData(data, 'Pagos'), context),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           );
            //         } else {
            //           return const Center(
            //               child: Text('Nenhum dado encontrado.'));
            //         }
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(
    List<Map<String, dynamic>> items,
    BuildContext context,
  ) {
    return items.isNotEmpty
        ? ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nome: ${item['nome_renda']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 20),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Text(
                                    'Categoria: ${item['categoria_renda']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 20),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Text(
                                    'Valor: R\$ ${item['valor_renda'].toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    var nomeRenda = item['nome_renda'];
                                    var categoriaRenda =
                                        item['categoria_renda'];
                                    int valorRenda = item['valor_renda'];
                                    var pagoRenda = item['pago_renda'];
                                    var codigoRenda = item["codigo_renda"];

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          elevation: 16.0,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxHeight: 580,
                                              maxWidth: 400,
                                            ),
                                            child: CadastroRendaPage(
                                              context: context,
                                              nomerenda: nomeRenda,
                                              categoriarenda: categoriaRenda,
                                              valorrenda: valorRenda,
                                              pagorenda: pagoRenda,
                                              codigorenda: codigoRenda,
                                              execucao: "alterar_renda",
                                              codigousuario:
                                                  widget.usuariocodigo,
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((_) {
                                      _buscarRendas();
                                    });
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

                                    // Mostrar o alerta de confirmação
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirmação'),
                                          content: const Text(
                                              'Tem certeza de que deseja excluir este registro?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                // Fechar o alerta sem fazer nada
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Confirmar exclusão
                                                Navigator.of(context)
                                                    .pop(); // Fechar o alerta
                                                deletarRenda(
                                                        context, codigoRenda)
                                                    .then((_) {
                                                  // Chamar _buscarRendas após exclusão
                                                  _buscarRendas();
                                                });
                                              },
                                              child: Text('Excluir'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          color: item['pago_renda'] == 'Sim'
                              ? Colors.green
                              : Colors.red,
                          child: Center(
                            child: Text(
                              item['pago_renda'] == 'Sim' ? 'Pago' : 'Não Pago',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : Center(
            child: Text(
              'Nenhum item encontrado.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 18),
            ),
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

  void exibirMensagem(BuildContext context, String opcao) {
    // Define mensagem e cor com base na opção
    String mensagem = opcao == "renda excluida"
        ? "Renda excluída com sucesso"
        : "Erro ao excluir a renda";
    Color corFundo = opcao == "renda excluida" ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensagem,
          textAlign: TextAlign.center, // Garante o alinhamento centralizado
          style: const TextStyle(color: Colors.white), // Cor do texto
        ),
        backgroundColor: corFundo, // Define a cor do fundo
        duration: const Duration(seconds: 3), // Define a duração do SnackBar
      ),
    );
  }
}