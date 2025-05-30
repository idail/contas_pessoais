import 'dart:convert';

import '/components/web_nav/web_nav_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'main_home_model.dart';
export 'main_home_model.dart';
import 'package:http/http.dart' as http;

class MainHomeWidget extends StatefulWidget {
  final String? nomeusuario;
  final int? codigousuario;
  final String? senhausuario;

  String? recebeNomeUsuario = "";
  MainHomeWidget(
      {Key? key,
      required this.nomeusuario,
      required this.codigousuario,
      required this.senhausuario})
      : super(key: key);

  @override
  State<MainHomeWidget> createState() => _MainHomeWidgetState();
}

class _MainHomeWidgetState extends State<MainHomeWidget>
    with TickerProviderStateMixin {
  //late MainHomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  double totalRenda = 0;
  double totalDespesa = 0;
  double totalFinal = 0;

  //var recebeNomeUsuario = "";

  @override
  void initState() {
    super.initState();

    print(widget.nomeusuario);

    widget.recebeNomeUsuario = widget.nomeusuario!;

    //String recebe = "${widget.tipoacesso} - ${widget.nomeusuario}";

    //print(recebe);

    // var recebe_tipo_acesso = "";

    // if(widget.tipoacesso != "")
    //   recebe_tipo_acesso = widget.tipoacesso!;

    var recebe_codigo_usuario = 0;

    if (widget.codigousuario != 0)
      recebe_codigo_usuario = widget.codigousuario!;

    carregaInformacoes(recebe_codigo_usuario);

    //_model = createModel(context, () => MainHomeModel());

    //logFirebaseEvent('screen_view', parameters: {'screen_name': 'Main_Home'});
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
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation1': AnimationInfo(
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
            begin: const Offset(100.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
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
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 180.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: const Offset(20.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation4': AnimationInfo(
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
            begin: const Offset(40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation3': AnimationInfo(
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
            begin: const Offset(120.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation4': AnimationInfo(
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
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 220.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 220.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 220.0.ms,
            duration: 600.0.ms,
            begin: const Offset(20.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation6': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 240.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 240.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 240.0.ms,
            duration: 600.0.ms,
            begin: const Offset(40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation5': AnimationInfo(
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
            begin: const Offset(120.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation6': AnimationInfo(
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
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation7': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 220.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 220.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 220.0.ms,
            duration: 600.0.ms,
            begin: const Offset(20.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation8': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 240.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 240.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 240.0.ms,
            duration: 600.0.ms,
            begin: const Offset(40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation9': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 600.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation7': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 600.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 600.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 50.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'progressBarOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 900.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 900.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 900.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'progressBarOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'progressBarOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 400.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'dividerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1400.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1400.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 1400.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation10': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1600.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1600.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 1600.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 30.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation11': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1600.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1600.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 1600.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 50.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation8': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1600.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1600.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 1600.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 70.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation12': AnimationInfo(
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
            begin: const Offset(40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation13': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 180.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: const Offset(20.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation9': AnimationInfo(
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
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation10': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1600.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1600.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 1600.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 90.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation14': AnimationInfo(
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
            begin: const Offset(40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation15': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 180.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: const Offset(20.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation11': AnimationInfo(
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
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation12': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 70.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation16': AnimationInfo(
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
            begin: const Offset(40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation17': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 180.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: const Offset(20.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation13': AnimationInfo(
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
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation14': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 300.0.ms,
            begin: const Offset(0.0, 90.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation18': AnimationInfo(
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
            begin: const Offset(40.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation19': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 180.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 180.0.ms,
            duration: 600.0.ms,
            begin: const Offset(20.0, 0.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation15': AnimationInfo(
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
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation20': AnimationInfo(
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

  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final Map<String, dynamic>? queryParams = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

  //   // Acessando os valores específicos
  //   final String? tipoAcesso = queryParams?['tipoAcesso'];
  //   final String? nomeUsuario = queryParams?['nomeUsuario'];
  //   final String? usuarioCodigo = queryParams?['usuario_codigo'];
  //   final String? codigoDepartamentoFornecedor = queryParams?['codigo_departamento_fornecedor'];
  //   final String? loginUsuario = queryParams?['login_usuario'];
  //   final String? emailUsuario = queryParams?['email_usuario'];

  //   print(tipoAcesso);
  // }

  @override
  void dispose() {
    // _model.dispose();

    super.dispose();
  }

  // double valorEmpenhoGestor = 0;
  // double valorEmpenhoRecebido = 0;
  // double valorConsumido = 0;
  // double saldoAtual = 0;
  // double valorRecebido = 0;
  // double valorPendente = 0;
  // double valorTotal = 0;
  // String valorConsumidoString = "";

  Future<void> carregaInformacoes(int codigo_usuario) async {
    String opcao = "visualizar_tudo";

    const String uriBuscaDespesa =
        'https://idailneto.com.br/contas_pessoais/API/Despesa.php';

    try {
      final uri = Uri.parse(uriBuscaDespesa).replace(queryParameters: {
        "execucao": "busca_despesas",
        "opcao": opcao,
        "filtro": "",
        "codigo_usuario": codigo_usuario.toString()
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        var retorno = jsonDecode(response.body);

        for (var i = 0; i < retorno.length; i++) {
          var valorDespesaTotal = retorno[i]['sum(valor_despesa)'];
          totalDespesa = double.parse(valorDespesaTotal);
          print(totalDespesa);
        }

        //String valorDespesaTotal = retorno['sum(valor_despesa)'];

        //print(totalDespesa);
        // if (retorno.length > 0) {
        //   print(retorno);
        // }
        //final data = json.decode(response.body) as List;
        //return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Erro ao buscar dados: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar-se à API: $e');
    }

    String opcao_renda = "visualizar_tudo";

    const String uriBuscaRenda =
        'https://idailneto.com.br/contas_pessoais/API/Renda.php';

    try {
      final uri = Uri.parse(uriBuscaRenda).replace(queryParameters: {
        "execucao": "busca_rendas",
        "opcao": opcao_renda,
        "filtro": "",
        "codigo_usuario_renda": codigo_usuario.toString()
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // final data = json.decode(response.body) as List;
        // return data.map((item) => Map<String, dynamic>.from(item)).toList();

        var retorno = jsonDecode(response.body);
        for (var i = 0; i < retorno.length; i++) {
          var valorRendaTotal = retorno[i]["sum(valor_renda)"];
          totalRenda = double.parse(valorRendaTotal);
          print(totalRenda);
        }
      } else {
        throw Exception('Erro ao buscar dados: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar-se à API: $e');
    }

    setState(() {
      totalFinal = totalRenda - totalDespesa;
    });

    // var busca_empenho = "valor_empenho";
    // var busca_valor_cotacao = "valor_cotacao";
    // var busca_cotacao_pago = "valor_cotacao_pago";
    // var busca_cotacao_aberto = "valor_cotacao_aberto";
    // if(perfil == "gestor")
    // {
    //   var uri = Uri.parse(
    //     "http://192.168.15.200/np3beneficios_appphp/api/pedidos/grafico.php?perfil=$perfil&codigo_usuario=$codigo_usuario&tipo_busca=$busca_empenho");
    //   var resposta = await http.get(uri, headers: {"Accept": "application/json"});
    //   var retorno = jsonDecode(resposta.body);

    //   for (var i = 0; i < retorno.length; i++) {
    //     var valor_empenho_string = retorno[i]["valor_empenho"];
    //     double valorEmpenho = double.parse(valor_empenho_string);
    //     if(valorEmpenho > 0){
    //       print(retorno[i]["valor_empenho"]);
    //       valorEmpenhoRecebido = double.parse(retorno[i]["valor_empenho"]);
    //       print(valorEmpenho);
    //     }else{
    //       print("zerado");
    //     }
    //   }

    //   var uri_cotacao = Uri.parse(
    //     "http://192.168.15.200/np3beneficios_appphp/api/pedidos/grafico.php?perfil=$perfil&codigo_usuario=$codigo_usuario&tipo_busca=$busca_valor_cotacao");
    //   var resposta_cotacao = await http.get(uri_cotacao, headers: {"Accept": "application/json"});
    //   var retorno_cotacao = jsonDecode(resposta_cotacao.body);

    //   print(retorno_cotacao);

    //   var recebeGestor = retorno_cotacao[0]['SUM(valor_total_cotacao)'];

    //   // Suponha que você tenha o valor assim:
    //   //List<Map<String, int>> resultado = retorno_cotacao[0];

    //   // Acessar o primeiro item da lista (que é um mapa)
    //   //Map<String, int> mapa = resultado[0];

    //   // Acessar o valor do mapa usando a chave
    //   //int valorC = mapa['SUM(valor_total_cotacao)'] ?? 0;

    //   //print(valorConsumido); // Output: 662

    //   print(valorConsumido);

    //     setState(() {
    //       valorEmpenhoGestor = valorEmpenhoRecebido;

    //       valorConsumido = double.parse(recebeGestor);
    //       if(valorEmpenhoGestor != "" && valorConsumido != "")
    //         saldoAtual = valorEmpenhoGestor - valorConsumido;
    //     });
    // }else{
    //   var uri = Uri.parse(
    //   "http://192.168.15.200/np3beneficios_appphp/api/pedidos/grafico.php?perfil=$perfil&codigo_usuario=$codigo_usuario&tipo_busca=$busca_cotacao_pago");
    //   var resposta_fornecedor = await http.get(uri, headers: {"Accept": "application/json"});
    //   var retorno_fornecedor = jsonDecode(resposta_fornecedor.body);

    //   print(retorno_fornecedor);

    //   // Acessa o primeiro item da lista que retorna da API
    //   var recebeFornecedor = retorno_fornecedor[0]['sum(valor_total_cotacao)'];

    //   // Acessar o valor associado à chave "SUM(valor_total_cotacao)"
    //   //double valorConsumido = recebe['SUM(valor_total_cotacao)'] ?? 0.0;

    //   print(valorConsumido); // Output: 662.0 (por exemplo)

    //   var uri_cotacao_aberto = Uri.parse(
    //   "http://192.168.15.200/np3beneficios_appphp/api/pedidos/grafico.php?perfil=$perfil&codigo_usuario=$codigo_usuario&tipo_busca=$busca_cotacao_aberto");
    //   var resposta_fornecedor_aberto = await http.get(uri_cotacao_aberto, headers: {"Accept": "application/json"});
    //   var retorno_fornecedor_aberto = jsonDecode(resposta_fornecedor_aberto.body);

    //   var recebeFornecedorAberto = retorno_fornecedor_aberto[0]["sum(valor_total_cotacao)"];

    //   print(retorno_fornecedor_aberto);

    //   setState(() {
    //     //valorRecebido = recebeFornecedor.toDouble();
    //     valorPendente = double.parse(recebeFornecedor);
    //     //valorPendente = recebeFornecedorAberto.toDouble();
    //     valorPendente = double.parse(recebeFornecedorAberto);

    //     if(valorRecebido != "" && valorPendente != "")
    //     saldoAtual = valorRecebido - valorPendente;
    //   });
    // }
  }

  double calcularPercentual(double totalRenda, double totalDespesa) {
    // Calcule o total e a proporção
    double total = totalRenda + totalDespesa;

    // Garanta que o total não seja zero para evitar divisão por zero
    if (total == 0) return 0.1;

    // Calcule o percentual baseado em um valor máximo (exemplo: 1000)
    double percentual = total / 1000;

    // Limite o valor entre 0.1 e 1.0
    return max(0.1, min(percentual, 1.0));
  }

  // Função para exibir o diálogo de ajuda
// Função para exibir o diálogo de ajuda
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController messageController = TextEditingController();

        return AlertDialog(
          title: Text("Informar erro ou sugestão"),
          content: Container(
            width: MediaQuery.of(context).size.width, // Largura total da tela
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TextArea para o usuário digitar a mensagem
                TextField(
                  controller: messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Digite sua mensagem...",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Botão de envio
                ElevatedButton(
                  onPressed: () {
                    // Aqui você pode capturar o texto e realizar a ação desejada
                    String message = messageController.text;
                    print("Mensagem enviada: $message");
                    Navigator.of(context).pop(); // Fecha o diálogo após enviar
                  },
                  child: Text("Enviar"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        // Comentando a appBar com o título "Dashboard"
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
                  child: Text(
                    'Olá, ${widget.nomeusuario ?? "Usuário"}',
                    textAlign: TextAlign.center,
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
                    // Exibe o diálogo ao clicar no item
                    _showHelpDialog(context);
                  },
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
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
            ],
          ),
        ),

        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 10,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                          SizedBox(
                            height: 230.0,
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 1.0,
                                  height: 110.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0.0, 0.0, 0.0, 8.0),
                                          child: Center(
                                            // Centraliza o conteúdo horizontal e verticalmente
                                            child: Text(
                                              "Informações",
                                              textAlign: TextAlign.center,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .displaySmall
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ).animateOnPageLoad(
                                              animationsMap[
                                                  'textOnPageLoadAnimation1']!,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16.0, 0.0, 16.0, 16.0),
                                          child: Text(
                                            "",
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  letterSpacing: 0.0,
                                                ),
                                          ).animateOnPageLoad(animationsMap[
                                              'textOnPageLoadAnimation2']!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(0.0, 1.0),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 30.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 140.0,
                                      decoration: const BoxDecoration(),
                                      child: ListView(
                                        padding: const EdgeInsets.fromLTRB(
                                          0,
                                          0,
                                          44.0,
                                          0,
                                        ),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 0.0, 0.0, 12.0),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              curve: Curves.easeInOut,
                                              width: double.infinity,
                                              constraints: const BoxConstraints(
                                                minHeight: 70.0,
                                                maxWidth: 300.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        12.0, 0.0, 12.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: 60.0,
                                                      height: 60.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Card(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.0),
                                                        ),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: Icon(
                                                            Icons.money_rounded,
                                                            color: Colors.white,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                            'containerOnPageLoadAnimation2']!),
                                                    Text(
                                                      'R\$${totalRenda.toStringAsFixed(2)}', // Exibe R$ e o valor formatado
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: Colors
                                                                    .blue, // Cor azul para o texto
                                                                fontSize: 40.0,
                                                              ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                                'containerOnPageLoadAnimation1']!),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 0.0, 0.0, 12.0),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              curve: Curves.easeInOut,
                                              constraints: const BoxConstraints(
                                                minHeight: 70.0,
                                                maxWidth: 300.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        12.0, 0.0, 12.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: 60.0,
                                                      height: 60.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Card(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.0),
                                                        ),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: Icon(
                                                            Icons
                                                                .account_balance_wallet,
                                                            color: Colors.white,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                            'containerOnPageLoadAnimation4']!),
                                                    Text(
                                                      'R\$${totalDespesa.toStringAsFixed(2)}', // Exibe R$ e o valor formatado
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: Colors
                                                                    .blue, // Cor azul para o texto
                                                                fontSize: 40.0,
                                                              ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                                'containerOnPageLoadAnimation3']!),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16.0, 0.0, 0.0, 12.0),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              curve: Curves.easeInOut,
                                              constraints: const BoxConstraints(
                                                minHeight: 70.0,
                                                maxWidth: 300.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        12.0, 0.0, 12.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      width: 60.0,
                                                      height: 60.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Card(
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40.0),
                                                        ),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child: Icon(
                                                            Icons
                                                                .account_balance_wallet,
                                                            color: Colors.white,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ).animateOnPageLoad(
                                                        animationsMap[
                                                            'containerOnPageLoadAnimation6']!),
                                                    Text(
                                                      'R\$${totalFinal.toStringAsFixed(2)}', // Exibe R$ e o valor formatado
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: Colors
                                                                    .blue, // Cor azul para o texto
                                                                fontSize: 40.0,
                                                              ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                                'containerOnPageLoadAnimation5']!),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 0.0, 0.0),
                            child: Text(
                              "",
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    letterSpacing: 0.0,
                                  ),
                            ).animateOnPageLoad(
                                animationsMap['textOnPageLoadAnimation9']!),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 16.0, 0.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x1F000000),
                                    offset: Offset(
                                      0.0,
                                      2.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 12.0, 0.0, 0.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Saldo Total
                                            Column(
                                              children: [
                                                CircularPercentIndicator(
                                                  percent: 1,
                                                  radius: 55.0,
                                                  lineWidth: 12.0,
                                                  animation: true,
                                                  animateFromLastPercent: true,
                                                  progressColor: Colors.blue,
                                                  backgroundColor:
                                                      const Color(0x4CFFFFFF),
                                                ),
                                                const SizedBox(height: 8.0),
                                                _buildLegenda(
                                                    "Saldo Total",
                                                    totalRenda - totalDespesa,
                                                    Colors.blue),
                                              ],
                                            ),
                                            const SizedBox(width: 20.0),
                                            // Total de Despesas
                                            Column(
                                              children: [
                                                CircularPercentIndicator(
                                                  percent: 1,
                                                  radius: 55.0,
                                                  lineWidth: 12.0,
                                                  animation: true,
                                                  animateFromLastPercent: true,
                                                  progressColor: Colors.red,
                                                  backgroundColor:
                                                      const Color(0x4CFFFFFF),
                                                ),
                                                const SizedBox(height: 8.0),
                                                _buildLegenda(
                                                    "Total de Despesas",
                                                    totalDespesa,
                                                    Colors.red),
                                              ],
                                            ),
                                            const SizedBox(width: 20.0),
                                            // Total de Renda
                                            Column(
                                              children: [
                                                CircularPercentIndicator(
                                                  percent: 1,
                                                  radius: 55.0,
                                                  lineWidth: 12.0,
                                                  animation: true,
                                                  animateFromLastPercent: true,
                                                  progressColor: Colors.green,
                                                  backgroundColor:
                                                      const Color(0x4CFFFFFF),
                                                ),
                                                const SizedBox(height: 8.0),
                                                _buildLegenda("Total de Renda",
                                                    totalRenda, Colors.green),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 24.0,
                                      thickness: 1.0,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ).animateOnPageLoad(animationsMap[
                                        'dividerOnPageLoadAnimation']!),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 8.0),
                                      child: Text(
                                        "Saldo Atual:$totalFinal",
                                        style: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ).animateOnPageLoad(animationsMap[
                                          'textOnPageLoadAnimation10']!),
                                    ),
                                    Text(
                                      "",
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: const Color(0x9AFFFFFF),
                                            letterSpacing: 0.0,
                                          ),
                                    ).animateOnPageLoad(animationsMap[
                                        'textOnPageLoadAnimation11']!),
                                  ],
                                ),
                              ),
                            ).animateOnPageLoad(animationsMap[
                                'containerOnPageLoadAnimation7']!),
                          ),
                          if (responsiveVisibility(
                            context: context,
                            phone: false,
                            tablet: false,
                          ))
                            // Align(
                            //   alignment: const AlignmentDirectional(0.0, 0.0),
                            //   child: Padding(
                            //     padding: const EdgeInsetsDirectional.fromSTEB(
                            //         16.0, 16.0, 16.0, 0.0),
                            //     child: Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: [
                            //         Expanded(
                            //           child: AnimatedContainer(
                            //             duration:
                            //                 const Duration(milliseconds: 100),
                            //             curve: Curves.easeInOut,
                            //             width: double.infinity,
                            //             constraints: const BoxConstraints(
                            //               minHeight: 70.0,
                            //               maxWidth: 770.0,
                            //             ),
                            //             decoration: BoxDecoration(
                            //               color: FlutterFlowTheme.of(context)
                            //                   .secondaryBackground,
                            //               boxShadow: const [
                            //                 BoxShadow(
                            //                   blurRadius: 3.0,
                            //                   color: Color(0x33000000),
                            //                   offset: Offset(
                            //                     0.0,
                            //                     1.0,
                            //                   ),
                            //                 )
                            //               ],
                            //               borderRadius:
                            //                   BorderRadius.circular(12.0),
                            //               border: Border.all(
                            //                 color: FlutterFlowTheme.of(context)
                            //                     .alternate,
                            //                 width: 1.0,
                            //               ),
                            //             ),
                            //             child: Padding(
                            //               padding: const EdgeInsetsDirectional
                            //                   .fromSTEB(0.0, 0.0, 0.0, 12.0),
                            //               child: Column(
                            //                 mainAxisSize: MainAxisSize.max,
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.center,
                            //                 children: [
                            //                   Padding(
                            //                     padding:
                            //                         const EdgeInsetsDirectional
                            //                             .fromSTEB(
                            //                             12.0, 8.0, 16.0, 4.0),
                            //                     child: Row(
                            //                       mainAxisSize:
                            //                           MainAxisSize.max,
                            //                       mainAxisAlignment:
                            //                           MainAxisAlignment
                            //                               .spaceBetween,
                            //                       children: [
                            //                         Padding(
                            //                           padding:
                            //                               const EdgeInsetsDirectional
                            //                                   .fromSTEB(4.0,
                            //                                   12.0, 12.0, 12.0),
                            //                           child: Column(
                            //                             mainAxisSize:
                            //                                 MainAxisSize.max,
                            //                             mainAxisAlignment:
                            //                                 MainAxisAlignment
                            //                                     .center,
                            //                             crossAxisAlignment:
                            //                                 CrossAxisAlignment
                            //                                     .start,
                            //                             children: [
                            //                               Text(
                            //                                 FFLocalizations.of(
                            //                                         context)
                            //                                     .getText(
                            //                                   'puy8obok' /* Contract Activity */,
                            //                                 ),
                            //                                 style: FlutterFlowTheme
                            //                                         .of(context)
                            //                                     .titleLarge
                            //                                     .override(
                            //                                       fontFamily:
                            //                                           'Plus Jakarta Sans',
                            //                                       letterSpacing:
                            //                                           0.0,
                            //                                     ),
                            //                               ).animateOnPageLoad(
                            //                                   animationsMap[
                            //                                       'textOnPageLoadAnimation12']!),
                            //                               Padding(
                            //                                 padding:
                            //                                     const EdgeInsetsDirectional
                            //                                         .fromSTEB(
                            //                                         0.0,
                            //                                         4.0,
                            //                                         0.0,
                            //                                         0.0),
                            //                                 child: Text(
                            //                                   FFLocalizations.of(
                            //                                           context)
                            //                                       .getText(
                            //                                     'zlovh0zt' /* Below is an a summary of activ... */,
                            //                                   ),
                            //                                   style: FlutterFlowTheme
                            //                                           .of(context)
                            //                                       .labelMedium
                            //                                       .override(
                            //                                         fontFamily:
                            //                                             'Plus Jakarta Sans',
                            //                                         letterSpacing:
                            //                                             0.0,
                            //                                       ),
                            //                                 ).animateOnPageLoad(
                            //                                     animationsMap[
                            //                                         'textOnPageLoadAnimation13']!),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                         Container(
                            //                           width: 60.0,
                            //                           height: 60.0,
                            //                           decoration: BoxDecoration(
                            //                             color: FlutterFlowTheme
                            //                                     .of(context)
                            //                                 .primaryBackground,
                            //                             shape: BoxShape.circle,
                            //                           ),
                            //                           alignment:
                            //                               const AlignmentDirectional(
                            //                                   0.0, 0.0),
                            //                           child: Card(
                            //                             clipBehavior: Clip
                            //                                 .antiAliasWithSaveLayer,
                            //                             color:
                            //                                 FlutterFlowTheme.of(
                            //                                         context)
                            //                                     .alternate,
                            //                             shape:
                            //                                 RoundedRectangleBorder(
                            //                               borderRadius:
                            //                                   BorderRadius
                            //                                       .circular(
                            //                                           40.0),
                            //                             ),
                            //                             child: Padding(
                            //                               padding:
                            //                                   const EdgeInsets
                            //                                       .all(12.0),
                            //                               child: Icon(
                            //                                 Icons
                            //                                     .folder_open_outlined,
                            //                                 color: FlutterFlowTheme
                            //                                         .of(context)
                            //                                     .primaryText,
                            //                                 size: 24.0,
                            //                               ),
                            //                             ),
                            //                           ),
                            //                         ).animateOnPageLoad(
                            //                             animationsMap[
                            //                                 'containerOnPageLoadAnimation9']!),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                   if (responsiveVisibility(
                            //                     context: context,
                            //                     tabletLandscape: false,
                            //                     desktop: false,
                            //                   ))
                            //                     Padding(
                            //                       padding:
                            //                           const EdgeInsetsDirectional
                            //                               .fromSTEB(
                            //                               16.0, 0.0, 16.0, 0.0),
                            //                       child: LinearPercentIndicator(
                            //                         percent: 0.5,
                            //                         width: MediaQuery.sizeOf(
                            //                                     context)
                            //                                 .width *
                            //                             0.82,
                            //                         lineHeight: 16.0,
                            //                         animation: true,
                            //                         animateFromLastPercent:
                            //                             true,
                            //                         progressColor:
                            //                             FlutterFlowTheme.of(
                            //                                     context)
                            //                                 .primary,
                            //                         backgroundColor:
                            //                             const Color(0x4D91D0E8),
                            //                         barRadius:
                            //                             const Radius.circular(
                            //                                 24.0),
                            //                         padding: EdgeInsets.zero,
                            //                       ),
                            //                     ),
                            //                   if (responsiveVisibility(
                            //                     context: context,
                            //                     phone: false,
                            //                     tablet: false,
                            //                   ))
                            //                     Padding(
                            //                       padding:
                            //                           const EdgeInsetsDirectional
                            //                               .fromSTEB(
                            //                               16.0, 0.0, 16.0, 0.0),
                            //                       child: LinearPercentIndicator(
                            //                         percent: 0.5,
                            //                         width: MediaQuery.sizeOf(
                            //                                     context)
                            //                                 .width *
                            //                             0.3,
                            //                         lineHeight: 16.0,
                            //                         animation: true,
                            //                         animateFromLastPercent:
                            //                             true,
                            //                         progressColor:
                            //                             FlutterFlowTheme.of(
                            //                                     context)
                            //                                 .primary,
                            //                         backgroundColor:
                            //                             FlutterFlowTheme.of(
                            //                                     context)
                            //                                 .accent1,
                            //                         barRadius:
                            //                             const Radius.circular(
                            //                                 24.0),
                            //                         padding: EdgeInsets.zero,
                            //                       ),
                            //                     ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ).animateOnPageLoad(animationsMap[
                            //               'containerOnPageLoadAnimation8']!),
                            //         ),
                            //         Expanded(
                            //           child: AnimatedContainer(
                            //             duration:
                            //                 const Duration(milliseconds: 100),
                            //             curve: Curves.easeInOut,
                            //             width: double.infinity,
                            //             constraints: const BoxConstraints(
                            //               minHeight: 70.0,
                            //               maxWidth: 770.0,
                            //             ),
                            //             decoration: BoxDecoration(
                            //               color: FlutterFlowTheme.of(context)
                            //                   .secondaryBackground,
                            //               boxShadow: const [
                            //                 BoxShadow(
                            //                   blurRadius: 3.0,
                            //                   color: Color(0x33000000),
                            //                   offset: Offset(
                            //                     0.0,
                            //                     1.0,
                            //                   ),
                            //                 )
                            //               ],
                            //               borderRadius:
                            //                   BorderRadius.circular(12.0),
                            //               border: Border.all(
                            //                 color: FlutterFlowTheme.of(context)
                            //                     .alternate,
                            //                 width: 1.0,
                            //               ),
                            //             ),
                            //             child: Padding(
                            //               padding: const EdgeInsetsDirectional
                            //                   .fromSTEB(0.0, 0.0, 0.0, 12.0),
                            //               child: Column(
                            //                 mainAxisSize: MainAxisSize.max,
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.center,
                            //                 children: [
                            //                   Padding(
                            //                     padding:
                            //                         const EdgeInsetsDirectional
                            //                             .fromSTEB(
                            //                             12.0, 8.0, 16.0, 4.0),
                            //                     child: Row(
                            //                       mainAxisSize:
                            //                           MainAxisSize.max,
                            //                       mainAxisAlignment:
                            //                           MainAxisAlignment
                            //                               .spaceBetween,
                            //                       children: [
                            //                         Padding(
                            //                           padding:
                            //                               const EdgeInsetsDirectional
                            //                                   .fromSTEB(4.0,
                            //                                   12.0, 12.0, 12.0),
                            //                           child: Column(
                            //                             mainAxisSize:
                            //                                 MainAxisSize.max,
                            //                             mainAxisAlignment:
                            //                                 MainAxisAlignment
                            //                                     .center,
                            //                             crossAxisAlignment:
                            //                                 CrossAxisAlignment
                            //                                     .start,
                            //                             children: [
                            //                               Text(
                            //                                 FFLocalizations.of(
                            //                                         context)
                            //                                     .getText(
                            //                                   'g1uaaovn' /* Customer Activity */,
                            //                                 ),
                            //                                 style: FlutterFlowTheme
                            //                                         .of(context)
                            //                                     .titleLarge
                            //                                     .override(
                            //                                       fontFamily:
                            //                                           'Plus Jakarta Sans',
                            //                                       letterSpacing:
                            //                                           0.0,
                            //                                     ),
                            //                               ).animateOnPageLoad(
                            //                                   animationsMap[
                            //                                       'textOnPageLoadAnimation14']!),
                            //                               Padding(
                            //                                 padding:
                            //                                     const EdgeInsetsDirectional
                            //                                         .fromSTEB(
                            //                                         0.0,
                            //                                         4.0,
                            //                                         0.0,
                            //                                         0.0),
                            //                                 child: Text(
                            //                                   FFLocalizations.of(
                            //                                           context)
                            //                                       .getText(
                            //                                     'e5q3ows1' /* Below is an a summary of activ... */,
                            //                                   ),
                            //                                   style: FlutterFlowTheme
                            //                                           .of(context)
                            //                                       .labelMedium
                            //                                       .override(
                            //                                         fontFamily:
                            //                                             'Plus Jakarta Sans',
                            //                                         letterSpacing:
                            //                                             0.0,
                            //                                       ),
                            //                                 ).animateOnPageLoad(
                            //                                     animationsMap[
                            //                                         'textOnPageLoadAnimation15']!),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                         Container(
                            //                           width: 60.0,
                            //                           height: 60.0,
                            //                           decoration: BoxDecoration(
                            //                             color: FlutterFlowTheme
                            //                                     .of(context)
                            //                                 .primaryBackground,
                            //                             shape: BoxShape.circle,
                            //                           ),
                            //                           alignment:
                            //                               const AlignmentDirectional(
                            //                                   0.0, 0.0),
                            //                           child: Card(
                            //                             clipBehavior: Clip
                            //                                 .antiAliasWithSaveLayer,
                            //                             color:
                            //                                 FlutterFlowTheme.of(
                            //                                         context)
                            //                                     .alternate,
                            //                             shape:
                            //                                 RoundedRectangleBorder(
                            //                               borderRadius:
                            //                                   BorderRadius
                            //                                       .circular(
                            //                                           40.0),
                            //                             ),
                            //                             child: Padding(
                            //                               padding:
                            //                                   const EdgeInsets
                            //                                       .all(12.0),
                            //                               child: Icon(
                            //                                 Icons.group,
                            //                                 color: FlutterFlowTheme
                            //                                         .of(context)
                            //                                     .primaryText,
                            //                                 size: 24.0,
                            //                               ),
                            //                             ),
                            //                           ),
                            //                         ).animateOnPageLoad(
                            //                             animationsMap[
                            //                                 'containerOnPageLoadAnimation11']!),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                   if (responsiveVisibility(
                            //                     context: context,
                            //                     tabletLandscape: false,
                            //                     desktop: false,
                            //                   ))
                            //                     Padding(
                            //                       padding:
                            //                           const EdgeInsetsDirectional
                            //                               .fromSTEB(
                            //                               16.0, 0.0, 16.0, 0.0),
                            //                       child: LinearPercentIndicator(
                            //                         percent: 0.2,
                            //                         width: MediaQuery.sizeOf(
                            //                                     context)
                            //                                 .width *
                            //                             0.82,
                            //                         lineHeight: 16.0,
                            //                         animation: true,
                            //                         animateFromLastPercent:
                            //                             true,
                            //                         progressColor:
                            //                             FlutterFlowTheme.of(
                            //                                     context)
                            //                                 .primary,
                            //                         backgroundColor:
                            //                             const Color(0x4D91D0E8),
                            //                         barRadius:
                            //                             const Radius.circular(
                            //                                 24.0),
                            //                         padding: EdgeInsets.zero,
                            //                       ),
                            //                     ),
                            //                   if (responsiveVisibility(
                            //                     context: context,
                            //                     phone: false,
                            //                     tablet: false,
                            //                   ))
                            //                     Padding(
                            //                       padding:
                            //                           const EdgeInsetsDirectional
                            //                               .fromSTEB(
                            //                               16.0, 0.0, 16.0, 0.0),
                            //                       child: LinearPercentIndicator(
                            //                         percent: 0.2,
                            //                         width: MediaQuery.sizeOf(
                            //                                     context)
                            //                                 .width *
                            //                             0.3,
                            //                         lineHeight: 16.0,
                            //                         animation: true,
                            //                         animateFromLastPercent:
                            //                             true,
                            //                         progressColor:
                            //                             FlutterFlowTheme.of(
                            //                                     context)
                            //                                 .primary,
                            //                         backgroundColor:
                            //                             FlutterFlowTheme.of(
                            //                                     context)
                            //                                 .accent1,
                            //                         barRadius:
                            //                             const Radius.circular(
                            //                                 24.0),
                            //                         padding: EdgeInsets.zero,
                            //                       ),
                            //                     ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ).animateOnPageLoad(animationsMap[
                            //               'containerOnPageLoadAnimation10']!),
                            //         ),
                            //       ].divide(const SizedBox(width: 16.0)),
                            //     ),
                            //   ),
                            // ),
                            if (responsiveVisibility(
                              context: context,
                              tabletLandscape: false,
                              desktop: false,
                            ))
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 12.0, 16.0, 0.0),
                                // child: Container(
                                //   width: double.infinity,
                                //   decoration: BoxDecoration(
                                //     color: FlutterFlowTheme.of(context)
                                //         .secondaryBackground,
                                //     boxShadow: const [
                                //       BoxShadow(
                                //         blurRadius: 4.0,
                                //         color: Color(0x1F000000),
                                //         offset: Offset(
                                //           0.0,
                                //           2.0,
                                //         ),
                                //       )
                                //     ],
                                //     borderRadius: BorderRadius.circular(8.0),
                                //     border: Border.all(
                                //       color: FlutterFlowTheme.of(context)
                                //           .primaryBackground,
                                //       width: 1.0,
                                //     ),
                                //   ),
                                //   child: Padding(
                                //     padding: const EdgeInsetsDirectional.fromSTEB(
                                //         0.0, 0.0, 0.0, 12.0),
                                //     child: Column(
                                //       mainAxisSize: MainAxisSize.max,
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.center,
                                //       children: [
                                //         Padding(
                                //           padding: const EdgeInsetsDirectional
                                //               .fromSTEB(12.0, 8.0, 16.0, 4.0),
                                //           child: Row(
                                //             mainAxisSize: MainAxisSize.max,
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.spaceBetween,
                                //             children: [
                                //               Padding(
                                //                 padding:
                                //                     const EdgeInsetsDirectional
                                //                         .fromSTEB(
                                //                         4.0, 12.0, 12.0, 12.0),
                                //                 child: Column(
                                //                   mainAxisSize: MainAxisSize.max,
                                //                   mainAxisAlignment:
                                //                       MainAxisAlignment.center,
                                //                   crossAxisAlignment:
                                //                       CrossAxisAlignment.start,
                                //                   children: [
                                //                     Text(
                                //                       FFLocalizations.of(context)
                                //                           .getText(
                                //                         'uj7jsxmo' /* Contract Activity */,
                                //                       ),
                                //                       style: FlutterFlowTheme.of(
                                //                               context)
                                //                           .titleLarge
                                //                           .override(
                                //                             fontFamily:
                                //                                 'Plus Jakarta Sans',
                                //                             letterSpacing: 0.0,
                                //                           ),
                                //                     ).animateOnPageLoad(animationsMap[
                                //                         'textOnPageLoadAnimation16']!),
                                //                     Padding(
                                //                       padding:
                                //                           const EdgeInsetsDirectional
                                //                               .fromSTEB(
                                //                               0.0, 4.0, 0.0, 0.0),
                                //                       child: Text(
                                //                         FFLocalizations.of(
                                //                                 context)
                                //                             .getText(
                                //                           'hkk2zmjw' /* Below is an a summary of activ... */,
                                //                         ),
                                //                         style: FlutterFlowTheme
                                //                                 .of(context)
                                //                             .labelMedium
                                //                             .override(
                                //                               fontFamily:
                                //                                   'Plus Jakarta Sans',
                                //                               letterSpacing: 0.0,
                                //                             ),
                                //                       ).animateOnPageLoad(
                                //                           animationsMap[
                                //                               'textOnPageLoadAnimation17']!),
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ),
                                //               Container(
                                //                 width: 60.0,
                                //                 height: 60.0,
                                //                 decoration: BoxDecoration(
                                //                   color:
                                //                       FlutterFlowTheme.of(context)
                                //                           .primaryBackground,
                                //                   shape: BoxShape.circle,
                                //                 ),
                                //                 alignment:
                                //                     const AlignmentDirectional(
                                //                         0.0, 0.0),
                                //                 child: Card(
                                //                   clipBehavior:
                                //                       Clip.antiAliasWithSaveLayer,
                                //                   color:
                                //                       FlutterFlowTheme.of(context)
                                //                           .alternate,
                                //                   shape: RoundedRectangleBorder(
                                //                     borderRadius:
                                //                         BorderRadius.circular(
                                //                             40.0),
                                //                   ),
                                //                   child: Padding(
                                //                     padding: const EdgeInsets.all(
                                //                         12.0),
                                //                     child: Icon(
                                //                       Icons.folder_open_outlined,
                                //                       color: FlutterFlowTheme.of(
                                //                               context)
                                //                           .primaryText,
                                //                       size: 24.0,
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ).animateOnPageLoad(animationsMap[
                                //                   'containerOnPageLoadAnimation13']!),
                                //             ],
                                //           ),
                                //         ),
                                //         if (responsiveVisibility(
                                //           context: context,
                                //           tabletLandscape: false,
                                //           desktop: false,
                                //         ))
                                //           Padding(
                                //             padding: const EdgeInsetsDirectional
                                //                 .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                //             child: LinearPercentIndicator(
                                //               percent: 0.5,
                                //               width: MediaQuery.sizeOf(context)
                                //                       .width *
                                //                   0.82,
                                //               lineHeight: 16.0,
                                //               animation: true,
                                //               animateFromLastPercent: true,
                                //               progressColor:
                                //                   FlutterFlowTheme.of(context)
                                //                       .primary,
                                //               backgroundColor:
                                //                   FlutterFlowTheme.of(context)
                                //                       .accent1,
                                //               barRadius:
                                //                   const Radius.circular(24.0),
                                //               padding: EdgeInsets.zero,
                                //             ),
                                //           ),
                                //         if (responsiveVisibility(
                                //           context: context,
                                //           phone: false,
                                //           tablet: false,
                                //         ))
                                //           Padding(
                                //             padding: const EdgeInsetsDirectional
                                //                 .fromSTEB(16.0, 0.0, 16.0, 0.0),
                                //             child: LinearPercentIndicator(
                                //               percent: 0.5,
                                //               width: MediaQuery.sizeOf(context)
                                //                       .width *
                                //                   0.3,
                                //               lineHeight: 16.0,
                                //               animation: true,
                                //               animateFromLastPercent: true,
                                //               progressColor:
                                //                   FlutterFlowTheme.of(context)
                                //                       .primary,
                                //               backgroundColor:
                                //                   const Color(0x4D91D0E8),
                                //               barRadius:
                                //                   const Radius.circular(24.0),
                                //               padding: EdgeInsets.zero,
                                //             ),
                                //           ),
                                //       ],
                                //     ),
                                //   ),
                                // ).animateOnPageLoad(animationsMap[
                                //     'containerOnPageLoadAnimation12']!),
                              ),
                          if (responsiveVisibility(
                            context: context,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 12.0, 16.0, 16.0),
                              // child: Container(
                              //   width: double.infinity,
                              //   decoration: BoxDecoration(
                              //     color: FlutterFlowTheme.of(context)
                              //         .secondaryBackground,
                              //     boxShadow: const [
                              //       BoxShadow(
                              //         blurRadius: 4.0,
                              //         color: Color(0x1F000000),
                              //         offset: Offset(
                              //           0.0,
                              //           2.0,
                              //         ),
                              //       )
                              //     ],
                              //     borderRadius: BorderRadius.circular(8.0),
                              //     border: Border.all(
                              //       color: FlutterFlowTheme.of(context)
                              //           .primaryBackground,
                              //       width: 1.0,
                              //     ),
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsetsDirectional.fromSTEB(
                              //         0.0, 0.0, 0.0, 12.0),
                              //     child: Column(
                              //       mainAxisSize: MainAxisSize.max,
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.center,
                              //       children: [
                              //         Padding(
                              //           padding: const EdgeInsetsDirectional
                              //               .fromSTEB(12.0, 8.0, 16.0, 4.0),
                              //           child: Row(
                              //             mainAxisSize: MainAxisSize.max,
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Padding(
                              //                 padding:
                              //                     const EdgeInsetsDirectional
                              //                         .fromSTEB(
                              //                         4.0, 12.0, 12.0, 12.0),
                              //                 child: Column(
                              //                   mainAxisSize: MainAxisSize.max,
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment.center,
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     Text(
                              //                       FFLocalizations.of(context)
                              //                           .getText(
                              //                         'jkgae0vc' /* Customer Activity */,
                              //                       ),
                              //                       style: FlutterFlowTheme.of(
                              //                               context)
                              //                           .titleLarge
                              //                           .override(
                              //                             fontFamily:
                              //                                 'Plus Jakarta Sans',
                              //                             letterSpacing: 0.0,
                              //                           ),
                              //                     ).animateOnPageLoad(animationsMap[
                              //                         'textOnPageLoadAnimation18']!),
                              //                     Padding(
                              //                       padding:
                              //                           const EdgeInsetsDirectional
                              //                               .fromSTEB(
                              //                               0.0, 4.0, 0.0, 0.0),
                              //                       child: Text(
                              //                         FFLocalizations.of(
                              //                                 context)
                              //                             .getText(
                              //                           'g4os7kcp' /* Below is an a summary of activ... */,
                              //                         ),
                              //                         style: FlutterFlowTheme
                              //                                 .of(context)
                              //                             .labelMedium
                              //                             .override(
                              //                               fontFamily:
                              //                                   'Plus Jakarta Sans',
                              //                               letterSpacing: 0.0,
                              //                             ),
                              //                       ).animateOnPageLoad(
                              //                           animationsMap[
                              //                               'textOnPageLoadAnimation19']!),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               Container(
                              //                 width: 60.0,
                              //                 height: 60.0,
                              //                 decoration: BoxDecoration(
                              //                   color:
                              //                       FlutterFlowTheme.of(context)
                              //                           .primaryBackground,
                              //                   shape: BoxShape.circle,
                              //                 ),
                              //                 alignment:
                              //                     const AlignmentDirectional(
                              //                         0.0, 0.0),
                              //                 child: Card(
                              //                   clipBehavior:
                              //                       Clip.antiAliasWithSaveLayer,
                              //                   color:
                              //                       FlutterFlowTheme.of(context)
                              //                           .alternate,
                              //                   shape: RoundedRectangleBorder(
                              //                     borderRadius:
                              //                         BorderRadius.circular(
                              //                             40.0),
                              //                   ),
                              //                   child: Padding(
                              //                     padding: const EdgeInsets.all(
                              //                         12.0),
                              //                     child: Icon(
                              //                       Icons.group,
                              //                       color: FlutterFlowTheme.of(
                              //                               context)
                              //                           .primaryText,
                              //                       size: 24.0,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ).animateOnPageLoad(animationsMap[
                              //                   'containerOnPageLoadAnimation15']!),
                              //             ],
                              //           ),
                              //         ),
                              //         if (responsiveVisibility(
                              //           context: context,
                              //           tabletLandscape: false,
                              //           desktop: false,
                              //         ))
                              //           Padding(
                              //             padding: const EdgeInsetsDirectional
                              //                 .fromSTEB(16.0, 0.0, 16.0, 0.0),
                              //             child: LinearPercentIndicator(
                              //               percent: 0.2,
                              //               width: MediaQuery.sizeOf(context)
                              //                       .width *
                              //                   0.82,
                              //               lineHeight: 16.0,
                              //               animation: true,
                              //               animateFromLastPercent: true,
                              //               progressColor:
                              //                   FlutterFlowTheme.of(context)
                              //                       .primary,
                              //               backgroundColor:
                              //                   FlutterFlowTheme.of(context)
                              //                       .accent1,
                              //               barRadius:
                              //                   const Radius.circular(24.0),
                              //               padding: EdgeInsets.zero,
                              //             ),
                              //           ),
                              //         if (responsiveVisibility(
                              //           context: context,
                              //           phone: false,
                              //           tablet: false,
                              //         ))
                              //           Padding(
                              //             padding: const EdgeInsetsDirectional
                              //                 .fromSTEB(16.0, 0.0, 16.0, 0.0),
                              //             child: LinearPercentIndicator(
                              //               percent: 0.2,
                              //               width: MediaQuery.sizeOf(context)
                              //                       .width *
                              //                   0.3,
                              //               lineHeight: 16.0,
                              //               animation: true,
                              //               animateFromLastPercent: true,
                              //               progressColor:
                              //                   FlutterFlowTheme.of(context)
                              //                       .primary,
                              //               backgroundColor:
                              //                   const Color(0x4D91D0E8),
                              //               barRadius:
                              //                   const Radius.circular(24.0),
                              //               padding: EdgeInsets.zero,
                              //             ),
                              //           ),
                              //       ],
                              //     ),
                              //   ),
                              // ).animateOnPageLoad(animationsMap[
                              //     'containerOnPageLoadAnimation14']!),
                            ),
                        ],
                      ),
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
}

// void _exibirInformacao(BuildContext context,
//     {required String titulo, required double valor}) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text(titulo),
//         content: Text('Valor: R\$ ${valor.toStringAsFixed(2)}'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }

Widget _buildLegenda(String titulo, double valor, Color cor) {
  return Row(
    children: [
      Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
          color: cor,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 8.0),
      Text(
        '$titulo: R\$ ${valor.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    ],
  );
}
