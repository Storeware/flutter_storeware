import 'package:controls_web/controls/strap_widgets.dart';
import 'package:flutter/material.dart';

class CardPanel extends StatelessWidget {
  final Widget hideOption;
  final Widget title;
  final List<Widget> children;
  final Widget bottom;
  const CardPanel(
      {Key key, this.title, this.children, this.bottom, this.hideOption})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: title,
        elevation: 0,
        //backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: children ?? [],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Container()),
                bottom ??
                    StrapButton(
                      type: StrapButtonType.link,
                      width: 60,
                      height: 40,
                      text: 'OK',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                if (hideOption != null) Container(width: 100, child: hideOption)
              ]),
        ],
      ),
    );
  }
}
