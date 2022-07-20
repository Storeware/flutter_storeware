import 'package:flutter/material.dart';
import 'package:controls_web/controls/notice_activities.dart';
import 'package:flutter_storeware/index.dart';

class NoticeView extends StatelessWidget {
  const NoticeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NoticeTitle(
          title: 'NoticeTitle',
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: NoticeTag(
            //text: 'NoticeTag',
            icon: Icon(Icons.add_link),
            radius: 15,
            content: Text('NoticeTab.content'),
          ),
        ),
        const NoticeText('NoticeText'),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: NoticeHeader(
            title: 'NoticeHeader',
            subtitle: 'subtitle',
          ),
        ),
        const NoticeButton(
          child: Text('NoticeButton'),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: NoticeInfo(child: Text('NoticeInfo')),
        ),
        Column(
          children: const [
            Text('NoticeValue'),
            NoticeValue(
              value: '123.4',
            ),
          ],
        ),
      ],
    ).singleChildScrollView();
  }
}
