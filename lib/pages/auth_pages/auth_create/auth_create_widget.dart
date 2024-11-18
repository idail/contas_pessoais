import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '/components/main_logo_small/main_logo_small_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'auth_create_model.dart';
export 'auth_create_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class AuthCreateWidget extends StatefulWidget {
  const AuthCreateWidget({super.key});

  @override
  State<AuthCreateWidget> createState() => _AuthCreateWidgetState();
}

class _AuthCreateWidgetState extends State<AuthCreateWidget>
    with TickerProviderStateMixin {
  late AuthCreateModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  var nomeusuariotxt = TextEditingController();
  var usuariotxt = TextEditingController();
  var emailusuariotxt = TextEditingController();
  var senhausuariotxt = TextEditingController();
  var confirmasenhausuariotxt = TextEditingController();

  File? imagemselecionada;
  XFile? imagemrecebida;

  String imagemPath = 'assets/images/sem_foto.jpg'; // Caminho padrão

  var dados;

  bool senhaVerificada = false;

  Future<void> selecaoImagem() async {
    final picker = ImagePicker();
    imagemrecebida = await picker.pickImage(source: ImageSource.gallery);
    if (imagemrecebida != null) {
      setState(() {
        imagemselecionada = File(imagemrecebida!.path);
      });
    }else{
        imagemselecionada = null; // Caminho da imagem padrão
    }
  }

  Future<void> cadastrar() async{
    var uri = Uri.parse(
        "http://192.168.100.6/contas_pessoais_php/api/Usuario.php");
    // Extrair o nome da imagem

    String nomeImagem = "";
    if(imagemrecebida != null){
      nomeImagem = path.basename(imagemrecebida!.path);
    }else{
      nomeImagem = imagemPath;
    }

    if(nomeusuariotxt.text.isEmpty){
      mostrarAlerta("Verificar preenchimento", "Favor preencher o nome do usuário");
    }else if(usuariotxt.text.isEmpty){
      mostrarAlerta("Verificar preenchimento", "Favor preencher o usuário");
    }else if(emailusuariotxt.text.isEmpty){
      mostrarAlerta("Verificar preenchimento", "Favor preencher o e-mail do usuário");
    }else if(senhausuariotxt.text.isEmpty){
      mostrarAlerta("Verificar preenchimento", "Favor preencher a senha do usuário");
    }else if(confirmasenhausuariotxt.text.isEmpty){
      mostrarAlerta("Verificar preenchimento", "Favor preencher a confirmação da senha");
    }else{
      if(senhaVerificada){

        print(senhausuariotxt.text);

        var valores = jsonEncode({
          "nome_usuario": nomeusuariotxt.text,
          "login_usuario": usuariotxt.text,
          "email_usuario": emailusuariotxt.text,
          "senha_usuario":senhausuariotxt.text,
          "nome_imagem":nomeImagem,
        });

        
        try {
          // Faz a requisição POST com cabeçalho e corpo
          var resposta = await http.post(
          uri,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          body: valores,
          );
    
          // Verifica o status da resposta
          if (resposta.statusCode == 200) {
            dados = jsonDecode(resposta.body);
            // Processa a resposta conforme necessário
            var valor_retorno = int.parse(dados);
            if(valor_retorno > 0){
              var pathParameters = <String, String>{
                "nomeusuario": nomeusuariotxt.text,
                "usuario_codigo": dados,
              };

              context.pushNamed('Main_Home',pathParameters: pathParameters);
            }
          } else {
            print("Erro ao cadastrar: ${resposta.statusCode}");
          }
        } catch (e) {
          print(dados);
          //print("Erro na requisição: $e");
        }
      }  
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
  final FocusNode confirmaSenhaFocusNode = FocusNode();

  void verificaSenha() {
    if(senhausuariotxt.text == confirmasenhausuariotxt.text){
      senhaVerificada = true;
    }else{
      senhaVerificada = false;
      confirmaSenhaFocusNode.requestFocus();
    }
  }

  @override
  void initState() {
    super.initState();

    // Image.asset(
    // 'assets/images/usuario_sem_foto.jpg',
    // fit: BoxFit.cover,
    // );

    _model = createModel(context, () => AuthCreateModel());

    //logFirebaseEvent('screen_view', parameters: {'screen_name': 'auth_Create'});

    // _model.emailAddressTextController ??= TextEditingController();
    // _model.emailAddressFocusNode ??= FocusNode();

    // _model.passwordTextController ??= TextEditingController();
    // _model.passwordFocusNode ??= FocusNode();

    // _model.passwordConfirmTextController ??= TextEditingController();
    // _model.passwordConfirmFocusNode ??= FocusNode();

    animationsMap.addAll({
      'rowOnPageLoadAnimation1': AnimationInfo(
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
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
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
            begin: const Offset(0.0, 40.0),
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
            begin: const Offset(0.0, 50.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textFieldOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 40.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textFieldOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 50.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textFieldOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 60.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'buttonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 80.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'rowOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 300.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 300.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 80.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 700.ms),
          FadeEffect(
            curve: Curves.bounceOut,
            delay: 700.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 700.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 700.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.4, 0.4),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 900.ms),
          FadeEffect(
            curve: Curves.bounceOut,
            delay: 900.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.bounceOut,
            delay: 900.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
          ScaleEffect(
            curve: Curves.bounceOut,
            delay: 900.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.4, 0.4),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'rowOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1000.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1000.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 1000.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 40.0),
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

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color.fromARGB(255, 0, 102, 180),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
          //  color: Colors.green[100]
          ),
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 530.0,
                  ),
                  decoration: const BoxDecoration(),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50.0),
                        Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 30.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                        Image.asset(
                                    'assets/images/cadastro-alterar.png',// Caminho da imagem
                                    width: 100.0, // Ajuste a largura conforme necessário
                                    height: 100.0, // Ajuste a altura conforme necessário
                                    fit: BoxFit.fitWidth, // Ajusta o estilo de exibição da imagem
                                  ),
                                ],
                              ).animateOnPageLoad(
                                  animationsMap['rowOnPageLoadAnimation1']!),
                            ),
                        Text(
                          "Cadastro",
                          style: FlutterFlowTheme.of(context)
                              .displaySmall
                              .override(
                                fontFamily: 'Outfit',
                                letterSpacing: 0.0,
                              ),
                        ).animateOnPageLoad(
                            animationsMap['textOnPageLoadAnimation1']!),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 4.0, 0.0, 0.0),
                          child: Text(
                           "",
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: 0.0,
                                ),
                          ).animateOnPageLoad(
                              animationsMap['textOnPageLoadAnimation2']!),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: TextFormField(
                                  controller: nomeusuariotxt,
                                  //focusNode: _model.emailAddressFocusNode,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText:
                                        "Nome",
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: 0.0,
                                          fontSize: 20,
                                        ),
                                    hintText:
                                        "Informe seu nome",
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
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor:
                                        FlutterFlowTheme.of(context).accent4,
                                    contentPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 24.0, 20.0, 24.0),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        letterSpacing: 0.0,
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model
                                      .emailAddressTextControllerValidator
                                      .asValidator(context),
                                ).animateOnPageLoad(animationsMap[
                                    'textFieldOnPageLoadAnimation1']!),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: TextFormField(
                                  controller: usuariotxt,
                                  //focusNode: _model.emailAddressFocusNode,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText:
                                        "Usuário",
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: 0.0,
                                          fontSize: 20,
                                        ),
                                    hintText:
                                        "Informe seu usuário",
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
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor:
                                        FlutterFlowTheme.of(context).accent4,
                                    contentPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 24.0, 20.0, 24.0),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        letterSpacing: 0.0,
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model
                                      .emailAddressTextControllerValidator
                                      .asValidator(context),
                                ).animateOnPageLoad(animationsMap[
                                    'textFieldOnPageLoadAnimation1']!),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: TextFormField(
                                  controller: emailusuariotxt,
                                  //focusNode: _model.emailAddressFocusNode,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText:
                                        "E-mail",
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: 0.0,
                                          fontSize: 20,
                                        ),
                                    hintText:
                                        "Informe seu e-mail",
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
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor:
                                        FlutterFlowTheme.of(context).accent4,
                                    contentPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 24.0, 20.0, 24.0),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        letterSpacing: 0.0,
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model
                                      .emailAddressTextControllerValidator
                                      .asValidator(context),
                                ).animateOnPageLoad(animationsMap[
                                    'textFieldOnPageLoadAnimation1']!),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: TextFormField(
                                  controller: senhausuariotxt,
                                  //focusNode: _model.passwordFocusNode,
                                  autofocus: true,
                                  autofillHints: const [AutofillHints.password],
                                  obscureText: !_model.passwordVisibility,
                                  decoration: InputDecoration(
                                    labelText:
                                       "Senha",
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: 0.0,
                                          fontSize: 20,
                                        ),
                                    hintText:
                                        "Informe sua senha",
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
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor:
                                        FlutterFlowTheme.of(context).accent4,
                                    contentPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 24.0, 20.0, 24.0),
                                    suffixIcon: InkWell(
                                      onTap: () => setState(
                                        () => _model.passwordVisibility =
                                            !_model.passwordVisibility,
                                      ),
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 24.0,
                                      ),
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
                                  validator: _model
                                      .passwordTextControllerValidator
                                      .asValidator(context),
                                ).animateOnPageLoad(animationsMap[
                                    'textFieldOnPageLoadAnimation2']!),
                              ),
                            ),
                          ],
                        ),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                  child: TextFormField(
                                    controller: confirmasenhausuariotxt,
                                    focusNode: confirmaSenhaFocusNode, // Associe o FocusNode ao campo
                                    autofocus: true,
                                    autofillHints: const [AutofillHints.password],
                                    obscureText: !_model.passwordVisibility,
                                    decoration: InputDecoration(
                                      labelText: "Confirmar senha",
                                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            letterSpacing: 0.0,
                                            fontSize: 20,
                                          ),
                                      hintText: "Informe sua senha",
                                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).primary,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).error,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context).error,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context).accent4,
                                      contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                                      suffixIcon: InkWell(
                                        onTap: () => setState(
                                          () => _model.passwordVisibility = !_model.passwordVisibility,
                                        ),
                                        focusNode: FocusNode(skipTraversal: true),
                                        child: Icon(
                                          _model.passwordVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: 0.0,
                                        ),
                                    cursorColor: FlutterFlowTheme.of(context).primary,
                                    validator: _model.passwordTextControllerValidator.asValidator(context),
                                    onChanged: (value) {
                                      // Chama verificaSenha ao terminar de digitar a senha
                                      // if (value == senhaOriginal) { // Substitua `senhaOriginal` com a senha que você quer comparar
                                        
                                      // }
                                      verificaSenha();
          },
                                  ).animateOnPageLoad(animationsMap['textFieldOnPageLoadAnimation2']!),
                                ),
                              ),
                            ],
                          ),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await selecaoImagem();
                                          if (imagemselecionada != null) {
                                            setState(() {
                                              imagemPath = imagemselecionada!.path; // Atualiza o caminho se houver uma nova imagem
                                              print(imagemPath);
                                            });
                                          }else{
                                            print(imagemPath);
                                          }
                                        },
                                        child: Container(
                                          width: 150.0,
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).accent4,
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).alternate,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15.0),
                                            child: Center(
                                              child: imagemselecionada != null
                                                  ? Image.file(
                                                      imagemselecionada!,
                                                      width: 150.0,
                                                      height: 150.0,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      imagemPath,
                                                      width: 150.0,
                                                      height: 150.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Selecione uma imagem",
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        // Container(
                        //   decoration: const BoxDecoration(),
                        //   child: Padding(
                        //     padding: const EdgeInsetsDirectional.fromSTEB(
                        //         0.0, 16.0, 0.0, 0.0),
                        //     child: TextFormField(
                        //       controller: _model.passwordConfirmTextController,
                        //       focusNode: _model.passwordConfirmFocusNode,
                        //       autofocus: true,
                        //       autofillHints: const [AutofillHints.password],
                        //       obscureText: !_model.passwordConfirmVisibility,
                        //       decoration: InputDecoration(
                        //         labelText: FFLocalizations.of(context).getText(
                        //           'kx2trk1o' /* Confirm Password */,
                        //         ),
                        //         labelStyle: FlutterFlowTheme.of(context)
                        //             .labelMedium
                        //             .override(
                        //               fontFamily: 'Plus Jakarta Sans',
                        //               letterSpacing: 0.0,
                        //             ),
                        //         hintText: FFLocalizations.of(context).getText(
                        //           'k8c3y3u7' /* Create your password... */,
                        //         ),
                        //         hintStyle: FlutterFlowTheme.of(context)
                        //             .labelMedium
                        //             .override(
                        //               fontFamily: 'Plus Jakarta Sans',
                        //               letterSpacing: 0.0,
                        //             ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color:
                        //                 FlutterFlowTheme.of(context).alternate,
                        //             width: 2.0,
                        //           ),
                        //           borderRadius: BorderRadius.circular(12.0),
                        //         ),
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: FlutterFlowTheme.of(context).primary,
                        //             width: 2.0,
                        //           ),
                        //           borderRadius: BorderRadius.circular(12.0),
                        //         ),
                        //         errorBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: FlutterFlowTheme.of(context).error,
                        //             width: 2.0,
                        //           ),
                        //           borderRadius: BorderRadius.circular(12.0),
                        //         ),
                        //         focusedErrorBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: FlutterFlowTheme.of(context).error,
                        //             width: 2.0,
                        //           ),
                        //           borderRadius: BorderRadius.circular(12.0),
                        //         ),
                        //         filled: true,
                        //         fillColor: FlutterFlowTheme.of(context).accent4,
                        //         contentPadding: const EdgeInsetsDirectional.fromSTEB(
                        //             20.0, 24.0, 20.0, 24.0),
                        //         suffixIcon: InkWell(
                        //           onTap: () => setState(
                        //             () => _model.passwordConfirmVisibility =
                        //                 !_model.passwordConfirmVisibility,
                        //           ),
                        //           focusNode: FocusNode(skipTraversal: true),
                        //           child: Icon(
                        //             _model.passwordConfirmVisibility
                        //                 ? Icons.visibility_outlined
                        //                 : Icons.visibility_off_outlined,
                        //             color: FlutterFlowTheme.of(context)
                        //                 .secondaryText,
                        //             size: 24.0,
                        //           ),
                        //         ),
                        //       ),
                        //       style: FlutterFlowTheme.of(context)
                        //           .bodyMedium
                        //           .override(
                        //             fontFamily: 'Plus Jakarta Sans',
                        //             letterSpacing: 0.0,
                        //           ),
                        //       cursorColor: FlutterFlowTheme.of(context).primary,
                        //       validator: _model
                        //           .passwordConfirmTextControllerValidator
                        //           .asValidator(context),
                        //     ).animateOnPageLoad(animationsMap[
                        //         'textFieldOnPageLoadAnimation3']!),
                        //   ),
                        // ),
                        ,
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FFButtonWidget(
                                onPressed: () async { cadastrar();} ,
                                // () async {
                                //   // logFirebaseEvent(
                                //   //     'AUTH_CREATE_PAGE_Button-Login_ON_TAP');
                                //   //GoRouter.of(context).prepareAuthEvent();
                                //   // if (_model.passwordTextController.text !=
                                //   //     _model
                                //   //         .passwordConfirmTextController.text) {
                                //   //   ScaffoldMessenger.of(context).showSnackBar(
                                //   //     const SnackBar(
                                //   //       content: Text(
                                //   //         'Passwords don\'t match!',
                                //   //       ),
                                //   //     ),
                                //   //   );
                                //   //   return;
                                //   // }

                                //   // final user =
                                //   //     await authManager.createAccountWithEmail(
                                //   //   context,
                                //   //   _model.emailAddressTextController.text,
                                //   //   _model.passwordTextController.text,
                                //   // );
                                //   // if (user == null) {
                                //   //   return;
                                //   // }

                                //   // context.goNamedAuth(
                                //   //     'Main_Home', context.mounted);
                                // },
                                text: "Criar conta",
                                options: FFButtonOptions(
                                  height: 52.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      44.0, 0.0, 44.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 3.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                  hoverColor:
                                      FlutterFlowTheme.of(context).accent1,
                                  hoverBorderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 1.0,
                                  ),
                                  hoverTextColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  hoverElevation: 0.0,
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['buttonOnPageLoadAnimation']!),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                "Cadastrar usando conta google",
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ).animateOnPageLoad(
                              animationsMap['rowOnPageLoadAnimation2']!),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    // logFirebaseEvent(
                                    //     'AUTH_CREATE_Container_rjk5lwv9_ON_TAP');
                                    //GoRouter.of(context).prepareAuthEvent();
                                    // final user = await authManager
                                    //     .signInWithGoogle(context);
                                    // if (user == null) {
                                    //   return;
                                    // }

                                    // context.goNamedAuth(
                                    //     'Main_Home', context.mounted);
                                  },
                                  child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2.0,
                                      ),
                                    ),
                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.google,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'containerOnPageLoadAnimation1']!),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: InkWell(
                              //     splashColor: Colors.transparent,
                              //     focusColor: Colors.transparent,
                              //     hoverColor: Colors.transparent,
                              //     highlightColor: Colors.transparent,
                              //     onTap: () async {
                              //       // logFirebaseEvent(
                              //       //     'AUTH_CREATE_Container_hmm1h1o4_ON_TAP');
                              //       //GoRouter.of(context).prepareAuthEvent();
                              //       // final user = await authManager
                              //       //     .signInWithApple(context);
                              //       // if (user == null) {
                              //       //   return;
                              //       // }

                              //       // context.goNamedAuth(
                              //       //     'Main_Home', context.mounted);
                              //     },
                              //     child: Container(
                              //       width: 50.0,
                              //       height: 50.0,
                              //       decoration: BoxDecoration(
                              //         color:
                              //             FlutterFlowTheme.of(context).accent1,
                              //         shape: BoxShape.circle,
                              //         border: Border.all(
                              //           color: FlutterFlowTheme.of(context)
                              //               .primary,
                              //           width: 2.0,
                              //         ),
                              //       ),
                              //       alignment: const AlignmentDirectional(0.0, 0.0),
                              //       child: FaIcon(
                              //         FontAwesomeIcons.apple,
                              //         color: FlutterFlowTheme.of(context)
                              //             .primaryText,
                              //         size: 24.0,
                              //       ),
                              //     ),
                              //   ).animateOnPageLoad(animationsMap[
                              //       'containerOnPageLoadAnimation2']!),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 24.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Já possui conta , logue-se",
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      letterSpacing: 0.0,
                                      fontSize: 18,
                                    ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  // logFirebaseEvent(
                                  //     'AUTH_CREATE_PAGE_LOG_IN_BTN_ON_TAP');

                                  context.pushNamed(
                                    'auth_Login',
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: const TransitionInfo(
                                        hasTransition: true,
                                        transitionType: PageTransitionType.fade,
                                        duration: Duration(milliseconds: 0),
                                      ),
                                    },
                                  );
                                },
                                text: "Logar",
                                options: FFButtonOptions(
                                  width: 70.0,
                                  height: 30.0,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: const Color(0x00FFFFFF),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                  elevation: 0.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ).animateOnPageLoad(
                              animationsMap['rowOnPageLoadAnimation3']!),
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
    );
  }
}