import 'dart:convert';

import 'package:financas/flutter_flow/flutter_flow_util.dart';
import 'package:financas/flutter_flow/internationalization.dart';
import 'package:financas/pages/main_pages/main_contracts/cadastroDespesa.dart';

import '/components/web_nav/web_nav_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart' as util;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'main_messages_model.dart';
export 'main_messages_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MainMessagesWidget extends StatefulWidget {
  String? nomeusuario;
  int? codigousuario;
  MainMessagesWidget({super.key, required this.nomeusuario, required this.codigousuario});

  @override
  State<MainMessagesWidget> createState() => _MainMessagesWidgetState();
}

class _MainMessagesWidgetState extends State<MainMessagesWidget>
    with TickerProviderStateMixin {
  late MainMessagesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  late TabController _tabDespesas;

  List<Map<String, dynamic>> items = [];
  late Future<List<Map<String, dynamic>>> _todasDespesas;
  List<Map<String, dynamic>> _pagos = [];
  List<Map<String, dynamic>> _naoPagos = [];
  TextEditingController filtroDespesa = new TextEditingController();
  List<Map<String, dynamic>> listarendas = [];
  late Future<List<Map<String, dynamic>>> _futureDespesas;

  @override
  void initState() {
    super.initState();

    print(widget.nomeusuario);

    _futureDespesas = despesas();

    _model = util.createModel(context, () => MainMessagesModel());

    //_calcularDistancia(); // Calcula a distância assim que a tela é carregada

    // util.logFirebaseEvent('screen_view',
    //     parameters: {'screen_name': 'Main_messages'});
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _tabDespesas = TabController(length: 3, vsync: this);

    animationsMap.addAll({
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 10.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  //GoogleMapController? _controladorMapa;

  // Pontos específicos das duas localidades
  // final LatLng _pontoA = const LatLng(-9.972413115315575, -67.80791574242686); // Rua 14 de Julho, 5141
  // final LatLng _pontoB = const LatLng(-9.951368295032635, -67.82165171759154); // Av. Afonso Pena, 4909

  // Variável para armazenar a distância calculada
  //String _distancia = "0 km";

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // void _calcularDistancia() {
  //   final distanciaEmMetros = Geolocator.distanceBetween(
  //     _pontoA.latitude,
  //     _pontoA.longitude,
  //     _pontoB.latitude,
  //     _pontoB.longitude,
  //   );

  //   setState(() {
  //     _distancia = (distanciaEmMetros / 1000).toStringAsFixed(2) + " km";
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () => FocusScope.of(context).unfocus(),
  //     child: Scaffold(
  //       key: scaffoldKey,
  //       backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
  //       appBar: !util.isWeb
  //           ? AppBar(
  //               backgroundColor: FlutterFlowTheme.of(context).primary,
  //               automaticallyImplyLeading: false,
  //               title: Text(
  //                 util.FFLocalizations.of(context).getText(
  //                   'ym579y79' /* Dashboard */,
  //                 ),
  //                 style: FlutterFlowTheme.of(context).displaySmall.override(
  //                       fontFamily: 'Outfit',
  //                       color: Colors.white,
  //                       letterSpacing: 0.0,
  //                     ),
  //               ).animateOnPageLoad(animationsMap['textOnPageLoadAnimation2']!),
  //               actions: const [],
  //               centerTitle: false,
  //               elevation: 0.0,
  //             )
  //           : null,
  //       body: Column(children: [
  //         Expanded(
  //           child: GoogleMap(
  //             onMapCreated: (controller) => _controladorMapa = controller,
  //             initialCameraPosition: CameraPosition(
  //               target: _pontoA, // Centralizando o mapa no ponto A
  //               zoom: 14,
  //             ),
  //             markers: {
  //               Marker(markerId: const MarkerId('pontoA'), position: _pontoA),
  //               Marker(markerId: const MarkerId('pontoB'), position: _pontoB),
  //             },
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Text('Distância: $_distancia', style: const TextStyle(fontSize: 20)),
  //         ),
  //       ],
  //       ),
  //     ),
  //   );
  // }

  Future<List<Map<String, dynamic>>> despesas() async {
    String opcao =
        filtroDespesa.text.trim().isEmpty ? "todos" : "busca_nome_despesa";

    const String uriBuscaRenda =
        'https://idailneto.com.br/contas_pessoais/API/Despesa.php';

    try {
      final uri = Uri.parse(uriBuscaRenda).replace(queryParameters: {
        "execucao": "busca_despesas",
        "opcao": opcao,
        "filtro": filtroDespesa.text.trim(),
        "codigo_usuario":widget.codigousuario.toString()
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

  void _buscarDespesas() {
    setState(() {
      _futureDespesas =
          despesas(); // Atualiza o Future com os filtros aplicados.
    });
  }

  Future<void> deletarDespesa(BuildContext contexto, int codigoDespesa) async {
    var uri =
        Uri.parse("https://idailneto.com.br/contas_pessoais/API/Despesa.php");

    var valorExcluirDespesa =
        jsonEncode({"execucao": "excluir_despesa", "codigo_despesa": codigoDespesa});

    try {
      var respostaDeletarDespesa = await http.delete(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: valorExcluirDespesa,
      );

      if (respostaDeletarDespesa.statusCode == 200) {
        print(respostaDeletarDespesa.body);

        var retornoDeletarDespesa = jsonDecode(respostaDeletarDespesa.body);
        
        if(retornoDeletarDespesa == "despesa excluida"){
          exibirMensagem(context,"despesa excluida");
        }else{
          exibirMensagem(context,"despesa nao excluida");
        }

        // Exibe a mensagem de sucesso
        // exibirMensagem(contexto);

        // setState(() {
        //   _buscarDespesas();
        // });
      } else {
        print(
            "Erro na requisição DELETE: ${respostaDeletarDespesa.statusCode} - ${respostaDeletarDespesa.reasonPhrase}");
      }
    } catch (e) {
      print("Erro na requisição: $e");
      exibirMensagem(context,"despesa nao excluida");
    }
  }

  List<Map<String, dynamic>> filterData(
      List<Map<String, dynamic>> data, String filter) {
    if (filter == 'Todos') {
      return data; // Retorna todos os itens
    } else if (filter == 'Ativos') {
      return data
          .where((item) => item['pago_despesa'] == 'Não')
          .toList(); // Filtra ativos (não pagos)
    } else if (filter == 'Pagos') {
      return data
          .where((item) => item['pago_despesa'] == 'Sim')
          .toList(); // Filtra pagos
    } else {
      return []; // Caso não haja filtro correspondente
    }
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
                  'Olá, ${widget.nomeusuario ?? "Usuário"}',
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
                  // Expande o botão para ocupar toda a largura disponível
                  child: _buildHorizontalCard(
                    context,
                    icon: Icons.account_balance_wallet,
                    title: 'Despesa',
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
                                  // Passa o modalContext para o CadastroDespesaPage
                                  return CadastroDespesaPage(
                                    context: modalContext,
                                    nomedespesa: "",
                                    categoriadespesa: "",
                                    valordespesa: 0,
                                    pagodespesa: "",
                                    codigodespesa: 0,
                                    execucao: "cadastrar_despesa",
                                    codigousuario: widget.codigousuario,
                                    // A função de callback agora será chamada após o fechamento do diálogo
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ).then((_) {
                        // Aqui, a função rendas() será chamada quando o diálogo for fechado
                          _buscarDespesas();
                      });
                    },
                    cardWidth: MediaQuery.of(context)
                        .size
                        .width, // Largura total da tela
                  ),
                ),
              ],
            ),

            // Espaçamento entre os cards e o campo de pesquisa
            const SizedBox(height: 20.0),

            // // Campo de pesquisa com botão de pesquisa
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         decoration: InputDecoration(
            //           hintText: 'Pesquisar renda...',
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

            // Espaçamento entre o campo de pesquisa e as abas
            const SizedBox(height: 20.0),

            // Flexible(
            //   flex: 2, // Aumente o valor para expandir mais altura
            //   child: RefreshIndicator(
            //     onRefresh: () async {
            //       // Chama a função rendas() ao arrastar para baixo
            //       print("puxou");
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
            //                 controller: _tabController,
            //                 tabs: const [
            //                   Tab(text: 'Todos'),
            //                   Tab(text: 'Ativos'),
            //                   Tab(text: 'Pagos'),
            //                 ],
            //               ),
            //               Expanded(
            //                 child: TabBarView(
            //                   controller: _tabController,
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

            // Espaçamento entre o campo de pesquisa e as abas
            const SizedBox(height: 20.0),

            // Campo de pesquisa com botão de pesquisa
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:filtroDespesa,
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
                    //print('Botão de pesquisa pressionado');
                    _buscarDespesas();
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
                  future: _futureDespesas, // Usa o Future atualizado.
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
                        child: Text('Nenhuma despesa encontrada.'),
                      );
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
                                    'Nome: ${item['nome_despesa']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 20),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Text(
                                    'Categoria: ${item['categoria_despesa']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 20),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Text(
                                    'Valor: R\$ ${item['valor_despesa'].toStringAsFixed(2)}',
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
                                    var nomeDespesa = item['nome_despesa'];
                                    var categoriaDespesa =
                                        item['categoria_despesa'];
                                    int valorDespesa = item['valor_despesa'];
                                    var pagoDespesa = item['pago_despesa'];
                                    var codigoDespesa = item["codigo_despesa"];

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
                                            child: CadastroDespesaPage(
                                              context: context,
                                              nomedespesa: nomeDespesa,
                                              categoriadespesa:
                                                  categoriaDespesa,
                                              valordespesa: valorDespesa,
                                              pagodespesa: pagoDespesa,
                                              codigodespesa: codigoDespesa,
                                              execucao: "alterar_despesa",
                                              codigousuario: widget.codigousuario,
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((_) {
                                      _buscarDespesas();
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
                                    var codigoDespesa = item['codigo_despesa'];

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
                                                deletarDespesa(
                                                        context, codigoDespesa)
                                                    .then((_) {
                                                  // Chamar _buscarRendas após exclusão
                                                  _buscarDespesas();
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
                          color: item['pago_despesa'] == 'Sim'
                              ? Colors.green
                              : Colors.red,
                          child: Center(
                            child: Text(
                              item['pago_despesa'] == 'Sim' ? 'Pago' : 'Não Pago',
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
    String mensagem = opcao == "despesa excluida"
        ? "Despesa excluída com sucesso"
        : "Erro ao excluir a despesa";
    Color corFundo = opcao == "despesa excluida" ? Colors.green : Colors.red;

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
