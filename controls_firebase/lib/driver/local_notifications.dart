import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  Function(String)? _onMessage;
  Function(Map<String, dynamic>)? _onDidNotifier;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final _singleton = LocalNotifications._create();
  LocalNotifications._create() {
    initNotifications();
  }
  factory LocalNotifications() => _singleton;

  listen(onDidNotifier) => _onDidNotifier = onDidNotifier;
  message(messageEvent) => _onMessage = messageEvent;

  Future<void> showNotification(
      {String? title, String? body, String? payload}) async {
    // compativel com a versão 9.2.0 - AL - 2022-01-20
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'console', 'Storeware',
        channelDescription: 'Storeware channel',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    //var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android:
            androidPlatformChannelSpecifics /*,
        iOS: iOSPlatformChannelSpecifics*/
        );
    print('showNotification $title - $body');
    await flutterLocalNotificationsPlugin.show(
        0, title ?? '', body ?? '', platformChannelSpecifics,
        payload: payload ?? 'Default_Sound');
  }

  Future<void> initNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    // AndroidInitializationSettings('app_icon');
    /*var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          if (_onDidNotifier != null)
            _onDidNotifier!({
              "notification": {"title": title, "body": body},
              "data": payload
            });
        });*/
    var initializationSettings = InitializationSettings(
        android:
            initializationSettingsAndroid /*, iOS: initializationSettingsIOS*/);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse resp) async {
      String? payload = resp.payload;
      if (payload != null) {
        if (_onMessage != null) _onMessage!(payload);
      }
    });
  }
}
