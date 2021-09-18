// @dart=2.12
import 'package:comum/services/config_service.dart';
import 'package:console/views/login/login_view.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_web/controls/strap_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';
import 'settings/config.dart';
import 'login_background.dart';

class LoggedView extends StatefulWidget {
  final Widget child;
  const LoggedView({Key? key, required this.child}) : super(key: key);

  @override
  _LoggedViewState createState() => _LoggedViewState();
}

class _LoggedViewState extends State<LoggedView> {
  // StreamSubscription diretivasBloc;
  //var _context;
  @override
  void initState() {
    super.initState();
    /*  diretivasBloc = (DiretivasBloc().stream as Stream).listen((x) {
      diretivas.register(_context);
    });*/
  }

  @override
  void dispose() {
    // diretivasBloc.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return StreamBuilder(
        stream: LoginTokenChanged().stream,
        builder: (context, snapshot) {
          return Consumer<LoginChanged>(builder: (x, a, b) {
            print('Login changed');
            if (Config().logado) {
              return widget.child;
            }

            var lg = !inDev;
            if (!lg && (Platform.isWindows || Platform.isLinux)) lg = true;

            if (lg && (!Config().logado)) {
              return LoginBackground(
                  body: LoginPage(
                treinarPosition: LoginPageTreinarPosition.left,
                padding: EdgeInsets.only(top: 20),
                curveColor: theme.primaryColor,
                strapButtonType: StrapButtonType.light,

                // Image.asset('assets/wba.png', height: 50),
                stackedChildren: [],
              ));
            }

            print('lg -> child');
            if (lg) {
              return widget.child;
            }

            print('logged -> streambuilder');
            if (!snapshot.hasData)
              return Align(child: CircularProgressIndicator());

            return Scaffold(backgroundColor: Colors.grey, body: widget.child);
          });
        });
  }
}
