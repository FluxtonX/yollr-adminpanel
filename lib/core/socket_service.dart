import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../core/constants.dart';

class AdminSocketService {
  late IO.Socket socket;

  void connect({
    required Function(int) onActiveUsersUpdate,
    required Function(Map<String, dynamic>) onNewPost,
  }) {
    socket = IO.io(
      AppConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print('Admin connected to socket');
    });

    socket.on('activeUsersUpdate', (data) {
      if (data is int) {
        onActiveUsersUpdate(data);
      }
    });

    socket.on('newPost', (data) {
      if (data != null) {
        onNewPost(data);
      }
    });

    socket.onDisconnect((_) => print('Admin disconnected from socket'));
  }

  void disconnect() {
    socket.disconnect();
  }
}
