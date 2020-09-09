import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {

 static  Future<void> showNotification(
      {String title, String body, String payload}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title ?? '', body ?? '', platformChannelSpecifics,
        payload: payload ?? '');
  }

}
