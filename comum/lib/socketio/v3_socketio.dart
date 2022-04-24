// @dart=2.12

import 'dart:async';
import 'dart:convert';
//import 'package:web_socket_channel/io.dart';
import 'io_socket_io.dart' if (dart.library.js) 'js_socket_io.dart';

class SocketIOConfig {
  String? url;
  String? contaid;
  String? token;
  String? usuarioSender;
  String? driver;
  bool get inited => url != null;
  String encodeUrl() {
    var rt =
        '${this.url}/?contaid=$contaid&token=$token&sender=$usuarioSender&db-driver=$driver';
    print(rt);
    return rt;
  }
}

class V3SocketIOConfig extends SocketIOConfig {
  static final _singleton = V3SocketIOConfig._create();
  V3SocketIOConfig._create();
  factory V3SocketIOConfig() => _singleton;
  init({required String url, contaid, token, usuarioSender, driver}) {
    int port = int.tryParse(url.split(':').last) ?? 0;
    if (port == 0) url += ':8889';
    this.url = '$url/websocket';
    this.url =
        url.replaceAll('https://', 'ws://').replaceAll('http://', 'ws://');
    this.contaid = contaid;
    this.token = token;
    this.usuarioSender = usuarioSender;
    this.driver = driver;
    return this;
  }
}

class TopicEvent {
  String? topic;
  String? payload;
  int? count;
  String? sender;
  TopicEvent(this.topic, this.payload, {this.count, this.sender});
  Map<String, dynamic> toJson() {
    return {
      "topic": this.topic,
      "payload": this.payload,
      "count": this.count ?? 0,
      "sender": this.sender
    };
  }

  TopicEvent.fromJson(json) {
    this.topic = json['topic'];
    this.payload = json['payload'];

    this.count = int.tryParse('${json['count']}') ?? 0;
    this.sender = json['sender'] ?? '';
  }
  toString() => json.encode(toJson());
  static TopicEvent fromString(String value) =>
      TopicEvent.fromJson(json.decode(value));
}

class SocketIOClient {
  late SocketIOConfig config;
  String topicRegister = 'event/register';
  String topicResponse = 'event/response';

  // tem suporte somente para firebird
  bool get enabled => config.driver == 'fb';

  var socketStatusCallback;
  List<String?> events = [];
  SocketIOClient({SocketIOConfig? config, this.socketStatusCallback}) {
    this.config = config ?? V3SocketIOConfig();
  }

  Future<void> ensureInited(Function() callback) async {
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (config.inited) {
        timer.cancel();
        callback();
      }
    });
  }

  var channel;
  late StreamSubscription subscription;
  subscribeEvent(String eventName, {Function(TopicEvent)? onData}) async {
    if (!this.config.inited)
      throw 'Não inicializou a estrutura do SocketIO do V3, fazer isto na inicialização do APP. Use [ensureInited((){ ... }] para aguardar inicialização';

    if (enabled) {
      channel ??= createSocketIO(config.encodeUrl());
      subscription = channel.stream.listen((message) {
        TopicEvent event = TopicEvent.fromString(message);
        print(message);
        if (event.topic == 'connected')
          channel.sink
              .add(TopicEvent(this.topicRegister, eventName).toString());
        else if (event.topic == this.topicResponse) {
          if (contains(event.payload)) return;
          if (onData != null)
            onData(event);
          else
            push(event.payload);
        }
      });
    }
  }

  sendMessage(String message, data) {}
  unSubscribeEvent() {
    if (enabled) {
      //if (subscription != null) {
      subscription.cancel();
      //}
      channel.sink.add('close');
    }
  }

  dispose() {
    disconnect();
  }

  disconnect() {
    unSubscribeEvent();
    channel = null;
  }

  bool get hasEvent => events.length > 0;
  int get length => events.length;
  bool contains(String? eventName) => events.contains(eventName);
  bool remove(String eventName) {
    return events.remove(eventName);
  }

  removeAll() {
    events.clear();
  }

  push(String? eventName) {
    if (!contains(eventName)) events.add(eventName);
    // print(['events:', events.length]);
  }
}
