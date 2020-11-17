import 'dart:async';

import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';
import 'package:controls_web/controls/notice_activities.dart';
import 'package:controls_web/controls/strap_widgets.dart';

class Dialogs {
  static showModal(context,
      {String title,
      Widget child,
      double width,
      double height,
      Color color,
      Widget bottom}) async {
    double _height = 40;
    return showPage(context,
        label: title ?? '',
        width: width,
        height: height,
        child: Scaffold(
          appBar: (title == null)
              ? null
              : AppBar(toolbarHeight: _height, title: Text(title ?? '')),
          body: Column(
            children: [
              if (child != null) child,
              if (bottom != null) bottom,
            ],
          ),
        ));
  }

  static showPage(context,
      {Widget child,
      double width,
      double height,
      Alignment alignment,
      bool fullPage = false,
      Widget Function(BuildContext) builder,
      RouteTransitionsBuilder transitionBuilder,
      int transitionDuration,
      String label = ''}) async {
    Size size = MediaQuery.of(context).size;
    double plus = 0.0;
    if (size.width < 400) plus = 0.07;
    return showGeneralDialog(
      context: context,
      barrierLabel: label,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: transitionDuration ?? 500),
      barrierDismissible: true,
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Align(
          alignment: alignment ?? Alignment.center,
          child: Material(
              child: Container(
            width: (fullPage) ? size.width : width ?? size.width * 0.90 + plus,
            height: (fullPage) ? size.height : height ?? size.height * 0.90,
            child: (builder != null) ? builder(context) : child,
          )),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        if (transitionBuilder != null)
          return transitionBuilder(_, anim, __, child);
        return ScaleTransition(
          scale: anim,
          child: child,
        );
      },
    );
  }

  static showTimedDialog(context,
      {int seconds = 10,
      width: 250,
      height: 150,
      @required Widget child}) async {
    var _closed = false;
    Timer(Duration(seconds: seconds), () {
      if (!_closed) Navigator.pop(context);
    });
    return showDialog(
        context: context,
        child: new SimpleDialog(
          title: child,
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text('Ok'),
              onPressed: () {
                _closed = true;
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  static future<T>(T Function() builder) async {
    return builder();
  }

  static showWaitDialog(context,
      {String title, @required dynamic Function() onWaiting}) {
    return showDialog(
        context: context,
        child: new SimpleDialog(title: Text(title ?? ''), children: <Widget>[
          new SimpleDialogOption(
            child: FutureBuilder(future: future(() {
              return onWaiting();
            }), builder: (x, y) {
              if (!y.hasData) return Align(child: CircularProgressIndicator());
              Timer.run(() {
                Navigator.pop(context);
              });
              return Container();
            }),
          )
        ]));
  }

  /// await Dialogs.showWaiting<bool>(context,title:'Processando',onWaiting:(){...},onDone:(v){...});
  static Future<T> showWaiting<T>(BuildContext context,
      {Future<T> Function() onWaiting,
      String title,
      Function(T) onDone}) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(children: [
            Center(
                child: Text(title ?? 'Processando',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            FutureBuilder<T>(
                future: onWaiting(),
                builder: (a, b) {
                  print(b.connectionState);
                  if (b.connectionState == ConnectionState.waiting)
                    return Align(child: CircularProgressIndicator());
                  if (onDone != null) onDone(b.data);
                  Timer.run(() {
                    Navigator.pop(context, b.data);
                  });
                  return Container();
                })
          ]);
        });
  }

  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key,
      {Widget title, Widget content}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  title: title,
                  key: key,
                  backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Processando....",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        if (content != null) content,
                      ]),
                    )
                  ]));
        });
  }

  static show(context,
      {Widget title, List<Widget> children, List<Widget> actions}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: title,
            children: <Widget>[...children ?? [], ...actions ?? []],
          );
        });
  }

  static info(
    BuildContext context, {
    String text,
    double width: 300,
    double height = 150,
    Widget icon,
    Color color,
    double tagWidth,
    Widget content,
    double radius = 15,
  }) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (x) => SimpleDialog(
              contentPadding: EdgeInsets.zero,
              titlePadding: EdgeInsets.zero,
              children: [
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: Row(
                    children: [
                      Container(
                          height: height,
                          width: tagWidth ?? 8,
                          color: Theme.of(context).primaryColor),
                      Expanded(
                        child: Row(children: [
                          if (icon != null)
                            Align(alignment: Alignment.topLeft, child: icon),
                          Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (text != null)
                                    Text(text ?? '',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18)),
                                  if (content != null) content,
                                  SizedBox(
                                    height: 20,
                                  ),
                                  StrapButton(
                                    text: 'OK',
                                    type: StrapButtonType.info,
                                    radius: 30,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ]),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  static alert<T>(BuildContext context,
          {Color backgoundColor,
          double elevation,
          String text,
          Widget title,
          List<Widget> actions,
          Widget content}) =>
      showDialog<T>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: content ?? Text(text ?? ''),
              title: title,
              backgroundColor: backgoundColor,
              elevation: elevation,
              actions: [
                if (actions != null) ...actions,
              ],
            );
          });

  static okDlg(context,
          {Widget content,
          String text,
          Widget title,
          String textButton,
          Color backgoundColor,
          double elevation,
          List<Widget> actions}) =>
      showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
                content: content ?? Text(text ?? 'Continuar ?'),
                title: title,
                backgroundColor: backgoundColor,
                elevation: elevation,
                actions: [
                  if (actions != null) ...actions,
                  StrapButton(
                      text: textButton ?? 'OK',
                      onPressed: () {
                        Navigator.pop(context, true);
                      }),
                ],
              ));
  static simNao(BuildContext context,
          {String text, Widget title, List<Widget> actions, Widget content}) =>
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: content ?? Text(text ?? ''),
              title: title,
              actions: [
                StrapButton(
                    text: 'Sim',
                    onPressed: () {
                      Navigator.pop(context, true);
                    }),
                if (actions != null) ...actions,
                StrapButton(
                    text: 'Não',
                    onPressed: () {
                      Navigator.pop(context, false);
                    }),
              ],
            );
          });
}

enum ProgressDialogType { Normal, Download, Percent }

String _dialogMessage = "Carregando...";
double _progress = 0.0, _maxProgress = 100.0;

Widget _customBody;

TextAlign _textAlign = TextAlign.left;
Alignment _progressWidgetAlignment = Alignment.centerLeft;

bool _isShowing = false;
BuildContext _context, _dismissingContext;
ProgressDialogType _progressDialogType;
bool _barrierDismissible = true, _showLogs = false;

TextStyle _progressTextStyle = TextStyle(
        color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w400),
    _messageStyle = TextStyle(
        color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600);

double _dialogElevation = 8.0, _borderRadius = 8.0;
Color _backgroundColor = Colors.white;
Curve _insetAnimCurve = Curves.easeInOut;
EdgeInsets _dialogPadding = const EdgeInsets.all(8.0);

Widget _progressWidget = Image.asset(
  'assets/double_ring_loading_io.gif',
  package: 'progress_dialog',
);

class ProgressDialog {
  _Body _dialog;

  ProgressDialog(BuildContext context,
      {ProgressDialogType type,
      bool isDismissible,
      bool showLogs,
      Widget customBody}) {
    _context = context;
    _progressDialogType = type ?? ProgressDialogType.Normal;
    _barrierDismissible = isDismissible ?? true;
    _showLogs = showLogs ?? false;
    _customBody = customBody ?? null;
  }

  void style(
      {Widget child,
      double progress,
      double maxProgress,
      String message,
      Widget progressWidget,
      Color backgroundColor,
      TextStyle progressTextStyle,
      TextStyle messageTextStyle,
      double elevation,
      TextAlign textAlign,
      double borderRadius,
      Curve insetAnimCurve,
      EdgeInsets padding,
      Alignment progressWidgetAlignment}) {
    if (_isShowing) return;
    if (_progressDialogType == ProgressDialogType.Download) {
      _progress = progress ?? _progress;
    }

    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _backgroundColor = backgroundColor ?? _backgroundColor;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;
    _dialogElevation = elevation ?? _dialogElevation;
    _borderRadius = borderRadius ?? _borderRadius;
    _insetAnimCurve = insetAnimCurve ?? _insetAnimCurve;
    _textAlign = textAlign ?? _textAlign;
    _progressWidget = child ?? _progressWidget;
    _dialogPadding = padding ?? _dialogPadding;
    _progressWidgetAlignment =
        progressWidgetAlignment ?? _progressWidgetAlignment;
  }

  void update(
      {double progress,
      double maxProgress,
      String message,
      Widget progressWidget,
      TextStyle progressTextStyle,
      TextStyle messageTextStyle}) {
    if (_progressDialogType == ProgressDialogType.Download) {
      _progress = progress ?? _progress;
    }

    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;
    _progress = progress ?? _progress;

    if (_isShowing) _dialog.update();
  }

  bool isShowing() {
    return _isShowing;
  }

  Future<bool> hide() async {
    try {
      if (_isShowing) {
        _isShowing = false;
        Navigator.of(_dismissingContext).pop();
        if (_showLogs) debugPrint('ProgressDialog dismissed');
        return Future.value(true);
      } else {
        if (_showLogs) debugPrint('ProgressDialog already dismissed');
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('Seems there is an issue hiding dialog');
      debugPrint(err);
      return Future.value(false);
    }
  }

  Future<bool> show() async {
    try {
      if (!_isShowing) {
        _dialog = new _Body();
        showDialog<dynamic>(
          context: _context,
          barrierDismissible: _barrierDismissible,
          builder: (BuildContext context) {
            _dismissingContext = context;
            return WillPopScope(
              onWillPop: () async => _barrierDismissible,
              child: Dialog(
                  backgroundColor: _backgroundColor,
                  insetAnimationCurve: _insetAnimCurve,
                  insetAnimationDuration: Duration(milliseconds: 100),
                  elevation: _dialogElevation,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(_borderRadius))),
                  child: _dialog),
            );
          },
        );
        // Delaying the function for 200 milliseconds
        // [Default transitionDuration of DialogRoute]
        await Future.delayed(Duration(milliseconds: 200));
        if (_showLogs) debugPrint('ProgressDialog shown');
        _isShowing = true;
        return true;
      } else {
        if (_showLogs) debugPrint("ProgressDialog already shown/showing");
        return false;
      }
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err);
      return false;
    }
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  _BodyState _dialog = _BodyState();

  update() {
    _dialog.update();
  }

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _BodyState extends State<_Body> {
  update() {
    setState(() {});
  }

  @override
  void dispose() {
    _isShowing = false;
    if (_showLogs) debugPrint('ProgressDialog dismissed by back button');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _customBody ??
        Container(
          padding: _dialogPadding,
          child: _progressDialogType == ProgressDialogType.Percent
              ? Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                      height: 100,
                      constraints: BoxConstraints(maxWidth: 500),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                            child: Align(
                          child: Text(_dialogMessage, style: _messageStyle),
                        )),
                        LinearProgressIndicator(
                            value: _progress / _maxProgress),
                      ])))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(width: 8.0),
                        Align(
                          alignment: _progressWidgetAlignment,
                          child: SizedBox(
                            width: 60.0,
                            height: 60.0,
                            child: _progressWidget,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: _progressDialogType ==
                                  ProgressDialogType.Normal
                              ? Text(
                                  _dialogMessage,
                                  textAlign: _textAlign,
                                  style: _messageStyle,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(height: 8.0),
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: Text(_dialogMessage,
                                                    style: _messageStyle)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text("$_progress/$_maxProgress",
                                            style: _progressTextStyle),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8.0)
                      ],
                    ),
                  ],
                ),
        );
  }
}
