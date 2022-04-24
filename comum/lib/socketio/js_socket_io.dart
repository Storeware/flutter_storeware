// @dart=2.12
import 'package:web_socket_channel/html.dart' as IO;

createSocketIO(url) {
  return IO.HtmlWebSocketChannel.connect(url);
}
