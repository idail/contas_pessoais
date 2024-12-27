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
  const NavBarPage({super.key, this.initialPage, this.page, this.tipoacesso, this.nomeusuario, this.usuario_codigo, this.senhausuario, this.login_usuario , this.email_usuario, });

  final String? initialPage;
  final Widget? page;
  final String? tipoacesso;
  final String? nomeusuario;
  final int? usuario_codigo;
  final String? senhausuario;
  final String? login_usuario;
  final String? email_usuario;
  @override
  _NavBarPageState createState() => _NavBarPageState();
}

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
    final tabs = {
      'Main_Home': MainHomeWidget(codigousuario: widget.usuario_codigo, nomeusuario: widget.nomeusuario, senhausuario: widget.senhausuario),
      'Main_Contracts': MainContractsWidget(usuariocodigo: widget.usuario_codigo, tipo_acesso: widget.tipoacesso, email_usuario: widget.email_usuario, login_usuario: widget.login_usuario, nome_usuario: widget.nomeusuario),
      'Main_messages': MainMessagesWidget(nomeusuario: widget.nomeusuario, codigousuario: widget.usuario_codigo,),
      'Main_profilePage': MainProfilePageWidget(codigousuario: widget.usuario_codigo, senhausuario: widget.senhausuario, nomeusuario: widget.nomeusuario),
    };

    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      // Adicionando o Drawer aqui para aparecer em todas as telas
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary,
              ),
              child: Text(
                FFLocalizations.of(context).getText('menuTitle' /* Menu */),
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.help, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    FFLocalizations.of(context).getText('menuHelp' /* Ajuda */),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            // Adicione outros itens do Drawer aqui, se necessário
          ],
        ),
      ),
      // Corpo da tela com a navegação entre as páginas
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
              icon: Icon(Icons.dashboard_outlined, size: 24.0),
              activeIcon: Icon(Icons.dashboard_rounded, size: 32.0),
              label: "Inicio",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt, size: 24.0),
              activeIcon: Icon(Icons.receipt, size: 32.0),
              label: "Renda",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet, size: 24.0),
              activeIcon: Icon(Icons.account_balance_wallet, size: 24.0),
              label: "Despesa",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, size: 24.0),
              activeIcon: Icon(Icons.account_circle, size: 32.0),
              label: "Perfil",
            ),
          ],
        ),
      ),
    );
  }
}
