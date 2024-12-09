import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'index.dart';

class MyApp extends StatefulWidget {
  //late String perfilacesso = "";
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  await initFirebase();

  await FlutterFlowTheme.initialize();

  runApp(const MyApp());
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    // Future.delayed(const Duration(milliseconds: 1000),
    //     () => setState(() => _appStateNotifier.stopShowingSplashImage())); // retirado a segunda imagem de splash screen

    _appStateNotifier.stopShowingSplashImage();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Finanças',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
        Locale('ta'),
        Locale('te'),
        Locale('or'),
        Locale('ml'),
        Locale('hi'),
        Locale('ur'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, this.initialPage, this.page, this.tipoacesso, this.nomeusuario, this.usuario_codigo, this.senhausuario,
  this.codigo_departamento_fornecedor, this.login_usuario , this.email_usuario, this.departamentos_gestor});

  final String? initialPage;
  final Widget? page;
  final String? tipoacesso;
  final String? nomeusuario;
  final int? usuario_codigo;
  final String? senhausuario;
  final String? codigo_departamento_fornecedor;
  final String? login_usuario;
  final String? email_usuario;
  final String? departamentos_gestor;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'Main_Home';
  late Widget? _currentPage;
  var recebe_codigo_departamento_fornecedor = 0;
  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {

    // if(widget.codigo_departamento_fornecedor == "nada"){
    //   recebe_codigo_departamento_fornecedor = 0;
    // }
    // else{
    //   var recebe_valor_codigo_departamento_fornecedor = widget.codigo_departamento_fornecedor;
    //   recebe_codigo_departamento_fornecedor = int.parse(recebe_valor_codigo_departamento_fornecedor!);
    // }

    final tabs = {
      'Main_Home': MainHomeWidget(codigousuario: widget.usuario_codigo,nomeusuario: widget.nomeusuario,senhausuario: widget.senhausuario,),
      //'Main_customerList': const MainCustomerListWidget(),
      'Main_Contracts': MainContractsWidget(usuariocodigo: widget.usuario_codigo,tipo_acesso: widget.tipoacesso, 
      codigo_departamento_fornecedor: recebe_codigo_departamento_fornecedor,email_usuario: widget.email_usuario,login_usuario:widget.login_usuario , nome_usuario: widget.nomeusuario,
      departamentos_gestor:widget.departamentos_gestor),
      'Main_messages': const MainMessagesWidget(),
      'Main_profilePage': MainProfilePageWidget(codigousuario: widget.usuario_codigo, senhausuario: widget.senhausuario),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: Visibility(
        visible: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() {
            _currentPage = null;
            _currentPageName = tabs.keys.toList()[i];
          }),
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          selectedItemColor: FlutterFlowTheme.of(context).primary,
          unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard_outlined,
                size: 24.0,
              ),
              activeIcon: Icon(
                Icons.dashboard_rounded,
                size: 32.0,
              ),
              label: 
                "Inicio",
              
              tooltip: '',
            ),
            // BottomNavigationBarItem(
            //   icon: const Icon(
            //     Icons.supervised_user_circle_outlined,
            //     size: 24.0,
            //   ),
            //   activeIcon: const Icon(
            //     Icons.supervised_user_circle_sharp,
            //     size: 32.0,
            //   ),
            //   label: FFLocalizations.of(context).getText(
            //     '3ourv2w9' /* __ */,
            //   ),
            //   tooltip: '',
            // ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.receipt,
                size: 24.0,
              ),
              activeIcon: Icon(
                Icons.receipt,
                size: 32.0,
              ),
              label: 
                "Gerenciar",
              
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                size: 24.0,
              ),
              activeIcon: Icon(
                Icons.map,
                size: 24.0,
              ),
              label: "Consultas",
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                size: 24.0,
              ),
              activeIcon: Icon(
                Icons.account_circle,
                size: 32.0,
              ),
              label: "Perfil",
              tooltip: '',
            )
          ],
        ),
      ),
    );
  }
}