// @dart=2.12
import 'dart:async';
import 'package:comum/services/config_service.dart';
import 'const_colors.dart';
import 'firebase_adapter.dart';
import 'package:flutter_storeware/index.dart';
import 'config.dart';
import 'const_colors.dart' as cnt;
import 'curvas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'veja_nossos_produtos_widget.dart';

enum LoginPageTreinarPosition {
  normal,
  left,
}

bool isFirebase = false;

class DefaultLoginPage extends InheritedWidget {
  DefaultLoginPage(
      {Key? key,
      Widget Function()? loginBuilder,
      required Widget Function() homeBuilder})
      : super(
            key: key,
            child: DefaultLoginPage.doBuilder(
                homeBuilder: homeBuilder, loginBuilder: loginBuilder));

  @override
  bool updateShouldNotify(DefaultLoginPage oldWidget) {
    return true;
  }

  static Widget doBuilder(
      {required Widget Function() homeBuilder, loginBuilder}) {
    ConfigX().init();
    return ChangeNotifierProvider<LoginChanged>(
      create: (ctx) => LoginChanged(),
      builder: (ctx, wg) => StreamBuilder(
        stream: LoginTokenChanged().stream,
        builder: (context, snapshot) => Consumer<LoginChanged>(
          builder: (ctx, ch, wg) => Builder(builder: (ctx) {
            if (configInstance!.logado) {
              return homeBuilder();
            } else {
              return (loginBuilder != null) ? loginBuilder!() : LoginPage();
            }
          }),
        ),
      ),
    );
  }

  static of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<DefaultLoginPage>();
}

class LoginPage extends StatefulWidget {
  final Color? curveColor;
  final Widget? logo;
  final List<Widget>? stackedChildren;
  final EdgeInsets? padding;
  final double? top;
  final double? left;
  final InputBorder? inputBorder;
  final double spacing;
  final double radius;
  final Color? backgroundColor;
  final bool? conhecaNossosProdutos;
  final bool filial;
  final LoginPageTreinarPosition treinarPosition;
  final double gapHeight;
  final StrapButtonType strapButtonType;
  final double buttonHeight;
  LoginPage(
      {Key? key,
      this.treinarPosition = LoginPageTreinarPosition.normal,
      this.logo,
      this.top,
      this.left,
      this.padding,
      this.curveColor,
      this.inputBorder,
      this.backgroundColor,
      this.spacing = 1,
      this.filial = false,
      this.radius = 15,
      this.buttonHeight = 30,
      this.strapButtonType = StrapButtonType.primary,
      this.gapHeight = 1,
      this.conhecaNossosProdutos = true,
      this.stackedChildren})
      : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _contaController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final _saveState = ValueNotifier<StrapButtonState>(StrapButtonState.none);
  final _treinarState = ValueNotifier<StrapButtonState>(StrapButtonState.none);
  get config => configInstance;
  var carregando = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    var obscureText = true.obs;
    ResponsiveInfo responsive = ResponsiveInfo(context);
    isFirebase = Firebase.isFirebase;
    var w = 300.0;
    var h = 700.0;
    //ResponsiveInfo responsive = ResponsiveInfo(context);
    ThemeData theme = Theme.of(context);
    var focusUsuario = FocusNode();
    if (_contaController.text.isEmpty) {
      _contaController.text = config.conta;
      _usuarioController.text = config.usuario;
    }

    return Scaffold(
      // backgroundColor:
      //     widget.backgroundColor ?? AppResourcesConst().backgroundColor,
      //appBar:  ,
      body: Stack(
        children: [
          AppResourcesConst().loginBackgroundWidget ??
              Positioned(
                  top: 0,
                  child: Container(
                    width: w,
                    height: h,
                    child: CustomPaint(
                      painter: CurvePainter(
                          color: widget.curveColor ?? curvaColor,
                          startAt: Point(0, 0),
                          points: [
                            CurvaPoint(0, 0, w, 0),
                            CurvaPoint(w * .40, h * .09, w * .34, h * .43),
                            CurvaPoint(w * .28, h * .83, 0, h)
                          ],
                          endAt: Point(0, h)),

                      //),
                    ),
                  )),
          AppResourcesConst().logoAppWidget ??
              Positioned(
                  top: 40,
                  left: 30,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        launch('https://wbagestao.com');
                      },
                      child: widget.logo ??
                          Image.asset(
                            AppResourcesConst().logoApp!,
                            height: 50,
                            color: Colors.white,
                          ),
                    ),
                  )),
          if (widget.stackedChildren != null) ...widget.stackedChildren!,
          //if (AppResourcesConst().loginChildren != null)
          ...AppResourcesConst().loginChildren,
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: widget.padding ??
                    EdgeInsets.only(
                      top: widget.top ??
                          (((UniversalPlatform.isIOS) ? 60 : 0) +
                              ((responsive.isSmall) ? 70.0 : 120.0)),
                      left:
                          widget.left ?? ((responsive.isSmall) ? 130.0 : 30.0),
                    ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: UniversalPlatform.isWeb ? 32.0 : 10.0),
                  child: Card(
                    color: Colors
                        .transparent, // theme.backgroundColor.withOpacity(0.3),
                    elevation: AppResourcesConst().elevation,
                    child: Container(
                      width: 330,
                      alignment: Alignment.center,
                      child: Consumer<LoginChanged>(
                        builder: (_, d, w) {
                          _senhaController.text = (config.lembrarSenha ?? false)
                              ? config.password
                              : '';

                          return Padding(
                              padding: EdgeInsets.all(8),
                              child: Form(
                                key: _formKey,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: widget.gapHeight),
                                      Theme(
                                        data: theme.copyWith(
                                          primaryColor: cnt.primaryColor,
                                          scaffoldBackgroundColor:
                                              cnt.scaffoldBackgroundColor,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (widget.treinarPosition ==
                                                LoginPageTreinarPosition.normal)
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: treinarWidget(),
                                              ),
                                            TextFormField(
                                                enabled: true,
                                                readOnly: false,
                                                textInputAction:
                                                    TextInputAction.next,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                onFieldSubmitted: (x) {
                                                  focusUsuario.nextFocus();
                                                },
                                                focusNode: focusUsuario,
                                                autofocus: !configInstance!
                                                    .resources.isMobile,
                                                controller: _contaController,
                                                //                        initialValue: contaId,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle:
                                                        FontStyle.normal),
                                                decoration: InputDecoration(
                                                    labelText: 'Conta',
                                                    border: widget.inputBorder),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Falta informar a conta';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (x) {
                                                  config.conta = x;
                                                }),
                                            SizedBox(height: widget.spacing),
                                            TextFormField(
                                                //initialValue: config.usuario,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                textInputAction:
                                                    TextInputAction.next,
                                                onFieldSubmitted: (x) {
                                                  focusUsuario.nextFocus();
                                                },
                                                focusNode: FocusNode(),
                                                controller: _usuarioController,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle:
                                                        FontStyle.normal),
                                                decoration: InputDecoration(
                                                  labelText: 'Usuário',
                                                  border: widget.inputBorder,
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Falta informar usuário';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (x) {
                                                  config.usuario = x;
                                                }),
                                            SizedBox(height: widget.spacing),
                                            Obx(() => TextFormField(
                                                textInputAction:
                                                    TextInputAction.done,
                                                onFieldSubmitted: (x) {
                                                  config.password = x;
                                                  _save(carregando);
                                                },
                                                focusNode: FocusNode(),
                                                controller: _senhaController,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontStyle:
                                                        FontStyle.normal),
                                                decoration: InputDecoration(
                                                    labelText: 'Senha',
                                                    border: widget.inputBorder,
                                                    suffixIcon: IconButton(
                                                        icon: Icon(obscureText
                                                                .value
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off),
                                                        onPressed: () {
                                                          obscureText.value =
                                                              !obscureText
                                                                  .value;
                                                        })),
                                                obscureText: obscureText.value,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Falta informar a senha';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (x) {
                                                  config.password = x;
                                                })),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                child:
                                                    LinearDataProgressIndicator()),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Flex(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              direction: Axis.horizontal,
                                              children: [
                                                // Expanded(
                                                //     flex: 1, child: Container()),
                                                StrapButton(
                                                  stateNotifier: _saveState,
                                                  //type: StrapButtonType.warning,
                                                  width: 200,
                                                  text: 'Entrar',
                                                  minHeight:
                                                      widget.buttonHeight,
                                                  radius: widget.radius,
                                                  type: widget.strapButtonType,
                                                  onPressed: () {
                                                    //_saveState.value =
                                                    //    StrapButtonState
                                                    //        .processing;
                                                    Timer.run(() {
                                                      _save(carregando);
                                                    });
                                                  },
                                                ),
                                                /* MaskedCheckbox(
                                                  //trailing: Text('lembrar'),
                                                  label: 'lembrar',
                                                  value: config.lembrarSenha,
                                                  onChanged: (b) {
                                                    config.lembrarSenha = b;
                                                  },
                                                ),*/
                                              ],
                                            ),
                                            /*ValueListenableBuilder<bool>(
                                              builder: (ct, v, w) {
                                                return (v)
                                                    ? CircularProgressIndicator()
                                                    : Container();
                                              },
                                              valueListenable: carregando,
                                            ),
                                            */
                                            SizedBox(
                                              height: 10,
                                            ),
                                            if (isFirebase)
                                              StrapButton(
//                                                type: StrapButtonType.secondary,
                                                  text: 'Entrar com Google',
                                                  width: 200,
                                                  minHeight:
                                                      widget.buttonHeight,
                                                  radius: widget.radius,
                                                  type: widget.strapButtonType,
                                                  onPressed: () {
                                                    _saveState.value =
                                                        StrapButtonState
                                                            .processing;
                                                    _loginGoogle();
                                                  }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.treinarPosition == LoginPageTreinarPosition.left)
            Positioned(top: 15, left: 10, child: treinarWidget()),
          Positioned(
            right: 20,
            top: UniversalPlatform.isIOS ? 40 : 15,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: theme.scaffoldBackgroundColor,
                    onPrimary: theme.primaryColor,
                    elevation: 0),
                child: Text('Não tenho uma conta'),
                onPressed: () {
                  // Get.to(AbrirContaView());
                  launch(AppResourcesConst().linkAbrirNovaConta,
                      enableJavaScript: true);
                }),
          ),
          if (widget.conhecaNossosProdutos ?? true)
            Positioned(
                child: VejaNossosProdutos(
                    style: TextStyle(fontSize: 10, color: Colors.black)),
                bottom: 50,
                left: 50),
        ],
      ),
    );
  }

  treinar() {
    var r = configInstance!.resources;
    _contaController.text = r.contaDemo['conta']!;
    _usuarioController.text = r.contaDemo['usuario']!;
    _senhaController.text = r.contaDemo['senha']!;
    config.lembrarSenha = true;
    // _treinarState.value = StrapButtonState.processing;
  }

  treinarWidget() => StrapButton(
      radius: widget.radius,
      type: StrapButtonType.none,
      stateNotifier: _treinarState,
      text: 'treinar',
      //style: TextStyle(
      //    color: Colors.blue)),
      onPressed: () {
        treinar();
        Timer.run(() {
          _save(carregando);
        });
      });

  _loginGoogle() {
    var config = configInstance;
    if (Firebase.isFirebase)
      Firebase.signInWithGoogle().then((user) {
        if (user != null) {
          // print(['signInWithGoogle', user]);
          return config!.loginSignInByEmail(config.conta, user.email);
        }
      });
  }

  _save(ValueNotifier<bool> carregando) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var config = configInstance!;
      carregando.value = true;
      return config
          .firebaseLogin(config.conta, config.usuario, config.password)
          .then((x) {
        _saveState.value = StrapButtonState.none;
        _treinarState.value = StrapButtonState.none;
        carregando.value = false;

        config.lembrarSenha = true;
      });
    } else
      _saveState.value = StrapButtonState.none;
  }
}
