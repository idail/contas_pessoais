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

  const MainContractsWidget({super.key, this.usuariocodigo, this.tipo_acesso, this.codigo_departamento_fornecedor , 
  this.email_usuario , this.login_usuario , this.nome_usuario , this.departamentos_gestor});

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
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MainContractsModel());
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
    backgroundColor: FlutterFlowTheme.of(context).primaryBackground, // Definindo a cor de fundo
    body: Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start, // Alinha os itens à esquerda
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // Mantém os cards alinhados à esquerda
            children: [
              // Card 1
              _buildHorizontalCard(
                context,
                icon: Icons.money,
                title: 'Renda',
                buttonLabel: 'Cadastrar', // Passando o botão
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 16.0,
                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 400,
                            maxWidth: 300,
                          ),
                          child: CadastroRendaPage(),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 10.0), // Ajustando o espaçamento entre os cards
              // Card 2
              _buildHorizontalCard(
                context,
                icon: Icons.account_balance_wallet,
                title: 'Despesa',
                buttonLabel: 'Cadastrar', // Passando o botão
                onPressed: () {
                  print('Card 2 pressionado');
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


Widget _buildHorizontalCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String buttonLabel,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0), // Menor espaçamento entre os cards
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      constraints: const BoxConstraints(
        minHeight: 100.0,
        maxWidth: 200.0, // Ajustando a largura para 170.0
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
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ícone arredondado
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                shape: BoxShape.circle,
              ),
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: FlutterFlowTheme.of(context).primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            // Título do Card
            Text(
              title,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 12.0),
            // Botão Centralizado
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
              child: Text(
                buttonLabel,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}