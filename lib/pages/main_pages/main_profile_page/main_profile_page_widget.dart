import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '/components/modals/command_palette/command_palette_widget.dart';
import '/components/modals_extra/modal_profile_edit/modal_profile_edit_widget.dart';
import '/components/web_nav/web_nav_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_language_selector.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'main_profile_page_model.dart';
export 'main_profile_page_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class MainProfilePageWidget extends StatefulWidget {
  final int? codigousuario;
  final String? senhausuario;
  const MainProfilePageWidget(
      {super.key, required this.codigousuario, required this.senhausuario});

  @override
  State<MainProfilePageWidget> createState() => _MainProfilePageWidgetState();
}

class _MainProfilePageWidgetState extends State<MainProfilePageWidget>
    with TickerProviderStateMixin {
  //late MainProfilePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  TextEditingController nomeUsuarioEspecifico = TextEditingController();
  TextEditingController loginUsuarioEspecifico = TextEditingController();
  TextEditingController emailUsuarioEspecifico = TextEditingController();
  TextEditingController senhaUsuarioEspecifico = TextEditingController();

  final FocusNode _senhaUsuarioFocusNode = FocusNode();

  String senhaInformada = "";

  bool _isPasswordVisible = false;

  var retornoUsuarioEspecifico;

  File? imagemSelecionada; // Armazenará a imagem selecionada

  late String imagem;

  String imagemPadraoPath =
      'assets/images/sem_foto.jpg'; // Caminho da imagem padrão

  Future<void> buscarDados() async {
    int? codigoUsuario = widget.codigousuario;

    //print(codigoUsuario);

    var uri = Uri.parse(
        "https://idailneto.com.br/contas_pessoais/API/Usuario.php?execucao=busca_dados_usuario&recebe_codigo_usuario=$codigoUsuario");

    var resposta = await http.get(uri, headers: {"Accept": "application/json"});

    //print(uri);

    //print(resposta.body);

    retornoUsuarioEspecifico = jsonDecode(resposta.body);

    print(retornoUsuarioEspecifico);

    var caminhoCompletoImagem = "";

    File arquivo;

    if (retornoUsuarioEspecifico["imagem_usuario"] !=
        "assets/images/sem_foto.jpg") {
      imagem = retornoUsuarioEspecifico["imagem_usuario"];

      final directory = await getApplicationDocumentsDirectory();
      final imagesDirectory = Directory('${directory.path}/images');
      //caminhoCompletoImagem = "${directory.path}/$imagem";

      setState(() {
        imagemSelecionada = File(imagem);
        senhaInformada = widget.senhausuario!;
      });
    } else {
      // // Copie a imagem dos assets para o diretório
      // final ByteData data = await rootBundle.load('assets/images/sem_foto.jpg');
      // //arquivo = File('${imagesDirectory.path}/sem_foto.jpg');
      // arquivo = File("assets/images/sem_foto.jpg");
      //imagem = arquivo;
      //imagem = imagemPadraoPath;

      // Caso seja "sem_foto.jpg", copie dos assets para o diretório local
      final ByteData data = await rootBundle.load('assets/images/sem_foto.jpg');
      final caminhoImagemPadrao = imagemPadraoPath;

      arquivo = File(caminhoImagemPadrao);

      // if (!arquivo.existsSync()) {
      //   // Copia a imagem somente se ainda não estiver no diretório
      //   await arquivo.writeAsBytes(data.buffer.asUint8List());
      // }

      setState(() {
        imagemSelecionada = null;
      });
    }
    //final caminhoCompletoImagem = "${directory.path}/$imagem";

    setState(() {
      nomeUsuarioEspecifico.text = retornoUsuarioEspecifico["nome_usuario"];
      loginUsuarioEspecifico.text = retornoUsuarioEspecifico["login_usuario"];
      emailUsuarioEspecifico.text = retornoUsuarioEspecifico["email_usuario"];
      senhaUsuarioEspecifico.text = widget.senhausuario!;

      // if (retornoUsuarioEspecifico["imagem_usuario"] !=
      //     "assets/images/sem_foto.jpg") {
      //   imagemSelecionada = File(caminhoCompletoImagem);
      // }
    });
  }

  String nomeImagem = "";
  File? imagemselecionada;

  File? imagemRecebida;

  Future<void> selecaoImagem() async {
    try {
      // Selecionar a imagem usando o ImagePicker
      final imagemRecebida =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      // Obter o diretório para salvar o arquivo
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDirectory = Directory('${appDir.path}/images');

      // Criar a pasta, se não existir
      // if (!await imagesDir.exists()) {
      //   await imagesDir.create(recursive: true);
      // }

      if (!imagesDirectory.existsSync()) {
        imagesDirectory.createSync(recursive: true);
      }

      File imagemLocal;

      if (imagemRecebida == null) {
        // Caso o usuário cancele a seleção, a imagem padrão será exibida

        // Copie a imagem dos assets para o diretório
        final ByteData data =
            await rootBundle.load('assets/images/sem_foto.jpg');
        final File arquivo = File('${imagesDirectory.path}/sem_foto.jpg');
        await arquivo.writeAsBytes(data.buffer.asUint8List());

        // setState(() {
        //   imagemSelecionada = null; // Não define um arquivo de imagem
        //   nomeImagem =
        //       "assets/images/sem_foto.jpg"; // Apenas o nome para fins de exibição, se necessário
        // });

        imagemLocal = arquivo;
      } else {
        // Caminho do arquivo para salvar
        final fileName = imagemRecebida.name;

        imagemLocal = File('${imagesDirectory.path}/$fileName');

        // Copiar o arquivo selecionado para o novo local
        await File(imagemRecebida.path).copy(imagemLocal.path);

        // setState(() {
        //   imagemSelecionada = localImage;
        //   nomeImagem = pickedImage.name;
        // });
      }

      setState(() {
        imagemSelecionada = imagemLocal;
      });

      // Feedback visual ao salvar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(imagemSelecionada != null
              ? 'Imagem salva em: ${imagemSelecionada!.path}'
              : 'Nenhuma imagem foi selecionada.'),
        ),
      );
    } catch (e) {
      // Exibir mensagem de erro
      print("Erro ao selecionar a imagem: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar a imagem.'),
        ),
      );
    }
  }

  Future<void> alterar_usuario() async {
    int? codigoUsuarioAlterar = widget.codigousuario;

    String url = "https://idailneto.com.br/contas_pessoais/API/Usuario.php";

    nomeImagem = "";

    nomeImagem = imagemPadraoPath;

    //nomeImagem = path.basename(imagemrecebida!.path);

    String recebeSenhaInformada;

    if (senhaInformada != "") {
      recebeSenhaInformada = senhaInformada;
    } else {
      recebeSenhaInformada = widget.senhausuario!;
    }

    // Dados a serem enviados no corpo da requisição
    var valores = jsonEncode({
      "codigo_usuario_alterar": codigoUsuarioAlterar,
      "nome_usuario_alterar": nomeUsuarioEspecifico.text,
      "login_usuario_alterar": loginUsuarioEspecifico.text,
      "email_usuario_alterar": emailUsuarioEspecifico.text,
      "senha_usuario_alterar": recebeSenhaInformada,
      "nome_imagem_usuario_alterar": nomeImagem,
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        body: valores,
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
        },
      );

      // Verificar a resposta da API
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        print(data);

        // if (data['status'] == 'success') {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Dados atualizados com sucesso!')),
        //   );
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Erro: ${data['message']}')),
        //   );
        // }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao conectar com a API.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    buscarDados();
    //_model = createModel(context, () => MainProfilePageModel());

    // logFirebaseEvent('screen_view',
    //     parameters: {'screen_name': 'Main_profilePage'});

    // Listener para o FocusNode
    _senhaUsuarioFocusNode.addListener(() {
      if (!_senhaUsuarioFocusNode.hasFocus) {
        // Aciona a ação ao perder o foco
        print("Campo de senha perdeu o foco!");
        // Exemplo de ação: validação ou outra lógica
        if (senhaUsuarioEspecifico.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Senha não pode ser vazia!')),
          );
        } else {
          setState(() {
            senhaInformada = senhaUsuarioEspecifico.text;
          });
        }
      }
    });

    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
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
      'iconOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'iconOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    //_model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // if (responsiveVisibility(
                //   context: context,
                //   phone: false,
                //   tablet: false,
                // ))
                //   wrapWithModel(
                //     model: _model.webNavModel,
                //     updateCallback: () => setState(() {}),
                //     child: const WebNavWidget(
                //       selectedNav: 5,
                //     ),
                //   ),
                Expanded(
                  child: Container(
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
                    child: Align(
                      alignment: const AlignmentDirectional(0.0, -1.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              alignment: const AlignmentDirectional(-1.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 16.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        "Perfil",
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .displaySmall
                                            .override(
                                              fontFamily: 'Outfit',
                                              letterSpacing: 0.0,
                                            ),
                                      ).animateOnPageLoad(animationsMap[
                                          'textOnPageLoadAnimation']!),
                                    ),
                                    // if (responsiveVisibility(
                                    //   context: context,
                                    //   tabletLandscape: false,
                                    //   desktop: false,
                                    // ))
                                    //   FlutterFlowIconButton(
                                    //     borderColor: Colors.transparent,
                                    //     borderRadius: 30.0,
                                    //     borderWidth: 1.0,
                                    //     buttonSize: 60.0,
                                    //     icon: Icon(
                                    //       Icons.search_rounded,
                                    //       color: FlutterFlowTheme.of(context)
                                    //           .primaryText,
                                    //       size: 30.0,
                                    //     ),
                                    //     onPressed: () async {
                                    //       await showModalBottomSheet(
                                    //         isScrollControlled: true,
                                    //         backgroundColor: Colors.transparent,
                                    //         barrierColor: const Color(0x1A000000),
                                    //         context: context,
                                    //         builder: (context) {
                                    //           return Padding(
                                    //             padding:
                                    //                 MediaQuery.viewInsetsOf(
                                    //                     context),
                                    //             child: const SizedBox(
                                    //               height: double.infinity,
                                    //               child: CommandPaletteWidget(),
                                    //             ),
                                    //           );
                                    //         },
                                    //       ).then(
                                    //           (value) => safeSetState(() {}));
                                    //     },
                                    //   ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 1.0,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    offset: const Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await selecaoImagem();
                                        if (imagemSelecionada != null) {
                                          setState(() {
                                            imagemPadraoPath = imagemSelecionada!
                                                .path; // Atualiza o caminho se houver uma nova imagem
                                            print(imagemPadraoPath);
                                          });
                                        } else {
                                          print(imagemPadraoPath);
                                        }
                                      },
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: imagemSelecionada != null
                                              ? Image.file(
                                                  imagemSelecionada!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  imagemPadraoPath, // Exibe a imagem padrão
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Clique para alterar a foto',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Campos de dados abaixo

                                // Padding(
                                //   padding: const EdgeInsetsDirectional.fromSTEB(
                                //       24.0, 12.0, 0.0, 0.0),
                                //   child: Text(
                                //     FFLocalizations.of(context).getText(
                                //       'fyxsf6vn' /* Account Settings */,
                                //     ),
                                //     style: FlutterFlowTheme.of(context)
                                //         .labelMedium
                                //         .override(
                                //           fontFamily: 'Plus Jakarta Sans',
                                //           letterSpacing: 0.0,
                                //         ),
                                //   ),
                                // ),

                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 60.0,
                                    constraints: const BoxConstraints(
                                      minHeight: 70.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 3.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 1.0),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: nomeUsuarioEspecifico,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: "Nome",
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              letterSpacing: 0.0,
                                              fontSize: 20,
                                            ),
                                        hintText: "Informe seu nome",
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .accent4,
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 24.0, 20.0, 24.0),
                                        prefixIcon: Icon(
                                          Icons.person, // Ícone de pessoa
                                          color: FlutterFlowTheme.of(context)
                                              .alternate, // Cor do ícone
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            letterSpacing: 0.0,
                                          ),
                                      cursorColor:
                                          FlutterFlowTheme.of(context).primary,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, insira seu nome';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 60.0,
                                    constraints: const BoxConstraints(
                                      minHeight: 70.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 3.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 1.0),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: loginUsuarioEspecifico,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: "Login",
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              letterSpacing: 0.0,
                                              fontSize: 20,
                                            ),
                                        hintText: "Informe seu login",
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .accent4,
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 24.0, 20.0, 24.0),
                                        prefixIcon: Icon(
                                          Icons.login_sharp, // Ícone de login
                                          color: FlutterFlowTheme.of(context)
                                              .alternate, // Cor do ícone
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            letterSpacing: 0.0,
                                          ),
                                      cursorColor:
                                          FlutterFlowTheme.of(context).primary,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, insira seu login';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 60.0,
                                    constraints: const BoxConstraints(
                                      minHeight: 70.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 3.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 1.0),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: emailUsuarioEspecifico,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: "E-mail",
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              letterSpacing: 0.0,
                                              fontSize: 20,
                                            ),
                                        hintText: "Informe seu e-mail",
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .accent4,
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 24.0, 20.0, 24.0),
                                        prefixIcon: Icon(
                                          Icons.email, // Ícone de e-mail
                                          color: FlutterFlowTheme.of(context)
                                              .alternate, // Cor do ícone
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            letterSpacing: 0.0,
                                          ),
                                      cursorColor:
                                          FlutterFlowTheme.of(context).primary,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, insira seu e-mail';
                                        }
                                        // Validação simples para formato de e-mail
                                        String emailPattern =
                                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
                                        RegExp regExp = RegExp(emailPattern);
                                        if (!regExp.hasMatch(value)) {
                                          return 'Por favor, insira um e-mail válido';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 60.0,
                                    constraints: const BoxConstraints(
                                      minHeight: 70.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 3.0,
                                          color: Color(0x33000000),
                                          offset: Offset(0.0, 1.0),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: senhaUsuarioEspecifico,
                                      focusNode:
                                          _senhaUsuarioFocusNode, // Adicionando o FocusNode
                                      autofocus: true,
                                      obscureText:
                                          !_isPasswordVisible, // Controla a visibilidade da senha
                                      decoration: InputDecoration(
                                        labelText: "Senha",
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              letterSpacing: 0.0,
                                              fontSize: 20,
                                            ),
                                        hintText: "Informe sua senha",
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              letterSpacing: 0.0,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .accent4,
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(
                                                20.0, 24.0, 20.0, 24.0),
                                        prefixIcon: Icon(
                                          Icons.lock, // Ícone de senha
                                          color: FlutterFlowTheme.of(context)
                                              .alternate, // Cor do ícone
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons
                                                    .visibility_off, // Alterna entre os ícones
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible; // Alterna a visibilidade da senha
                                            });
                                          },
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            letterSpacing: 0.0,
                                          ),
                                      cursorColor:
                                          FlutterFlowTheme.of(context).primary,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, insira sua senha';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 12.0, 16.0, 0.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      alterar_usuario();

                                      // Exibe o SnackBar após a alteração
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Registro alterado com sucesso!',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                    // Adicione a lógica de edição aqui
                                    ,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      minimumSize: const Size(
                                          180.0, 50.0), // Largura aumentada
                                      elevation: 3.0,
                                    ),
                                    child: Text(
                                      'Editar',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ),

                                // Builder(
                                //   builder: (context) => Padding(
                                //     padding: const EdgeInsetsDirectional.fromSTEB(
                                //         16.0, 0.0, 16.0, 0.0),
                                //     child: InkWell(
                                //       splashColor: Colors.transparent,
                                //       focusColor: Colors.transparent,
                                //       hoverColor: Colors.transparent,
                                //       highlightColor: Colors.transparent,
                                //       onTap: () async {

                                //         if (MediaQuery.sizeOf(context).width >=
                                //             991.0) {
                                //           await showDialog(
                                //             barrierColor: Colors.transparent,
                                //             context: context,
                                //             builder: (dialogContext) {
                                //               return Dialog(
                                //                 elevation: 0,
                                //                 insetPadding: EdgeInsets.zero,
                                //                 backgroundColor:
                                //                     Colors.transparent,
                                //                 alignment: const AlignmentDirectional(
                                //                         0.0, 0.0)
                                //                     .resolve(Directionality.of(
                                //                         context)),
                                //                 child: const ModalProfileEditWidget(),
                                //               );
                                //             },
                                //           );
                                //         } else {
                                //           context.pushNamed('editProfile');
                                //         }
                                //       },
                                //       child: AnimatedContainer(
                                //         duration: const Duration(milliseconds: 100),
                                //         curve: Curves.easeInOut,
                                //         width: double.infinity,
                                //         height: 60.0,
                                //         constraints: const BoxConstraints(
                                //           minHeight: 70.0,
                                //         ),
                                //         decoration: BoxDecoration(
                                //           color: FlutterFlowTheme.of(context)
                                //               .secondaryBackground,
                                //           boxShadow: const [
                                //             BoxShadow(
                                //               blurRadius: 3.0,
                                //               color: Color(0x33000000),
                                //               offset: Offset(
                                //                 0.0,
                                //                 1.0,
                                //               ),
                                //             )
                                //           ],
                                //           borderRadius:
                                //               BorderRadius.circular(12.0),
                                //           border: Border.all(
                                //             color: FlutterFlowTheme.of(context)
                                //                 .alternate,
                                //             width: 1.0,
                                //           ),
                                //         ),
                                //         child: Padding(
                                //           padding:
                                //               const EdgeInsetsDirectional.fromSTEB(
                                //                   8.0, 8.0, 16.0, 8.0),
                                //           child: Row(
                                //             mainAxisSize: MainAxisSize.max,
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.spaceBetween,
                                //             children: [
                                //               Padding(
                                //                 padding: const EdgeInsetsDirectional
                                //                     .fromSTEB(
                                //                         12.0, 0.0, 0.0, 0.0),
                                //                 child: Text(
                                //                   FFLocalizations.of(context)
                                //                       .getText(
                                //                     'b1lw0hfu' /* Edit Profile */,
                                //                   ),
                                //                   style: FlutterFlowTheme.of(
                                //                           context)
                                //                       .labelLarge
                                //                       .override(
                                //                         fontFamily:
                                //                             'Plus Jakarta Sans',
                                //                         letterSpacing: 0.0,
                                //                       ),
                                //                 ),
                                //               ),
                                //               Align(
                                //                 alignment: const AlignmentDirectional(
                                //                     0.9, 0.0),
                                //                 child: Icon(
                                //                   Icons.arrow_forward_ios,
                                //                   color: FlutterFlowTheme.of(
                                //                           context)
                                //                       .secondaryText,
                                //                   size: 18.0,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsetsDirectional.fromSTEB(
                                //       16.0, 0.0, 16.0, 0.0),
                                //   child: FlutterFlowLanguageSelector(
                                //     width: double.infinity,
                                //     height: 60.0,
                                //     backgroundColor:
                                //         FlutterFlowTheme.of(context)
                                //             .secondaryBackground,
                                //     borderColor:
                                //         FlutterFlowTheme.of(context).alternate,
                                //     dropdownColor: FlutterFlowTheme.of(context)
                                //         .secondaryBackground,
                                //     dropdownIconColor:
                                //         FlutterFlowTheme.of(context)
                                //             .secondaryText,
                                //     borderRadius: 12.0,
                                //     textStyle: FlutterFlowTheme.of(context)
                                //         .bodyLarge
                                //         .override(
                                //           fontFamily: 'Plus Jakarta Sans',
                                //           letterSpacing: 0.0,
                                //         ),
                                //     hideFlags: false,
                                //     flagSize: 24.0,
                                //     flagTextGap: 8.0,
                                //     currentLanguage: FFLocalizations.of(context)
                                //         .languageCode,
                                //     languages: FFLocalizations.languages(),
                                //     onChanged: (lang) =>
                                //         setAppLanguage(context, lang),
                                //   ),
                                // ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      curve: Curves.easeInOut,
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        minHeight: 70.0,
                                        maxWidth: 770.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 3.0,
                                            color: Color(0x33000000),
                                            offset: Offset(
                                              0.0,
                                              1.0,
                                            ),
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      -1.0, -1.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Escolhar a cor que deseja",
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleLarge
                                                        .override(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0.0, 4.0, 0.0, 0.0),
                                                    child: Text(
                                                      "",
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                'Plus Jakarta Sans',
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.0, 0.0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 16.0, 0.0, 16.0),
                                                child: Wrap(
                                                  spacing: 16.0,
                                                  runSpacing: 16.0,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.start,
                                                  direction: Axis.horizontal,
                                                  runAlignment:
                                                      WrapAlignment.start,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    SizedBox(
                                                      width: 322.0,
                                                      child: Stack(
                                                        children: [
                                                          AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        150),
                                                            curve: Curves
                                                                .easeInOut,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent1
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              border:
                                                                  Border.all(
                                                                color: Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  // logFirebaseEvent(
                                                                  //     'MAIN_PROFILE_Container_nj6nvadb_ON_TAP');
                                                                  setDarkModeSetting(
                                                                      context,
                                                                      ThemeMode
                                                                          .dark);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 310.0,
                                                                  height: 230.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                        0xFF1B1D27),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        8.0,
                                                                        12.0,
                                                                        8.0,
                                                                        0.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              8.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
                                                                                child: Text(
                                                                                  "Modo Escuro",
                                                                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                        fontFamily: 'Plus Jakarta Sans',
                                                                                        color: FlutterFlowTheme.of(context).info,
                                                                                        letterSpacing: 0.0,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                              if (Theme.of(context).brightness == Brightness.dark)
                                                                                Align(
                                                                                  alignment: const AlignmentDirectional(1.0, -1.0),
                                                                                  child: Icon(
                                                                                    Icons.check_circle_rounded,
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    size: 32.0,
                                                                                  ).animateOnPageLoad(animationsMap['iconOnPageLoadAnimation1']!),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              110.0,
                                                                          height:
                                                                              160.0,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Color(0xFF2A3137),
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              bottomLeft: Radius.circular(0.0),
                                                                              bottomRight: Radius.circular(0.0),
                                                                              topLeft: Radius.circular(8.0),
                                                                              topRight: Radius.circular(8.0),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                4.0,
                                                                                12.0,
                                                                                4.0,
                                                                                0.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Container(
                                                                                        width: 70.0,
                                                                                        height: 20.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: const Color(0xD81D2429),
                                                                                          borderRadius: BorderRadius.circular(6.0),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: 16.0,
                                                                                        height: 16.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                                          shape: BoxShape.circle,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                  child: Container(
                                                                                    width: double.infinity,
                                                                                    height: 44.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: const Color(0xD81D2429),
                                                                                      borderRadius: BorderRadius.circular(6.0),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                  child: Container(
                                                                                    width: double.infinity,
                                                                                    height: 44.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: const Color(0xD81D2429),
                                                                                      borderRadius: BorderRadius.circular(6.0),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 322.0,
                                                      child: Stack(
                                                        children: [
                                                          AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        150),
                                                            curve: Curves
                                                                .easeInOut,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? FlutterFlowTheme.of(
                                                                          context)
                                                                      .accent1
                                                                  : FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              border:
                                                                  Border.all(
                                                                color: Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .light
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  // logFirebaseEvent(
                                                                  //     'MAIN_PROFILE_Container_dvfw21hn_ON_TAP');
                                                                  setDarkModeSetting(
                                                                      context,
                                                                      ThemeMode
                                                                          .light);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 310.0,
                                                                  height: 230.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        8.0,
                                                                        12.0,
                                                                        8.0,
                                                                        0.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              8.0,
                                                                              0.0,
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
                                                                                child: Text(
                                                                                  "Modo Claro",
                                                                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                                                                        fontFamily: 'Plus Jakarta Sans',
                                                                                        color: const Color(0xFF1B1D27),
                                                                                        letterSpacing: 0.0,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                              if (Theme.of(context).brightness == Brightness.light)
                                                                                Align(
                                                                                  alignment: const AlignmentDirectional(1.0, -1.0),
                                                                                  child: Icon(
                                                                                    Icons.check_circle_rounded,
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    size: 32.0,
                                                                                  ).animateOnPageLoad(animationsMap['iconOnPageLoadAnimation2']!),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              110.0,
                                                                          height:
                                                                              160.0,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Color(0xFFDBE2E7),
                                                                            borderRadius:
                                                                                BorderRadius.only(
                                                                              bottomLeft: Radius.circular(0.0),
                                                                              bottomRight: Radius.circular(0.0),
                                                                              topLeft: Radius.circular(8.0),
                                                                              topRight: Radius.circular(8.0),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                                                4.0,
                                                                                12.0,
                                                                                4.0,
                                                                                0.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Container(
                                                                                        width: 70.0,
                                                                                        height: 20.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).info,
                                                                                          borderRadius: BorderRadius.circular(6.0),
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: 16.0,
                                                                                        height: 16.0,
                                                                                        decoration: BoxDecoration(
                                                                                          color: FlutterFlowTheme.of(context).primary,
                                                                                          shape: BoxShape.circle,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                  child: Container(
                                                                                    width: double.infinity,
                                                                                    height: 44.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).info,
                                                                                      borderRadius: BorderRadius.circular(6.0),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                                                                  child: Container(
                                                                                    width: double.infinity,
                                                                                    height: 44.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).info,
                                                                                      borderRadius: BorderRadius.circular(6.0),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 20.0, 0.0, 20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FFButtonWidget(
                                        onPressed: () async {
                                          // logFirebaseEvent(
                                          //     'MAIN_PROFILE_LOG_OUT_BTN_ON_TAP');

                                          context.pushNamed(
                                            'auth_Login',
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  const TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType
                                                        .bottomToTop,
                                                duration:
                                                    Duration(milliseconds: 250),
                                              ),
                                            },
                                          );
                                        },
                                        text: "Sair",
                                        options: FFButtonOptions(
                                          height: 44.0,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          iconPadding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        'Plus Jakarta Sans',
                                                    letterSpacing: 0.0,
                                                  ),
                                          elevation: 0.0,
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          hoverColor:
                                              FlutterFlowTheme.of(context)
                                                  .alternate,
                                          hoverBorderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          hoverTextColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          hoverElevation: 3.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                                  .divide(const SizedBox(height: 16.0))
                                  .addToEnd(const SizedBox(height: 64.0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
