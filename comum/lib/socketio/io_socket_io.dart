
// @dart=2.12
import 'package:web_socket_channel/io.dart' as IO;

createSocketIO(url) {
  return IO.IOWebSocketChannel.connect(url);
}
