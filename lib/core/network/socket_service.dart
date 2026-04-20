import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:skill_exchange/config/env/env_config.dart';

class SocketService {
  io.Socket? _socket;

  io.Socket? get socket => _socket;
  bool get isConnected => _socket?.connected ?? false;

  void connect(String token) {
    _socket = io.io(
      EnvConfig.wsUrl.replaceFirst('ws://', 'http://').replaceFirst('wss://', 'https://'),
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .build(),
    );
    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void emit(String event, dynamic data, {Function? ack}) {
    _socket?.emitWithAck(event, data, ack: ack);
  }

  void sendMessage(String receiverId, String content, {Function? callback}) {
    emit('send_message', {'receiverId': receiverId, 'content': content}, ack: callback);
  }

  void markRead(String threadId, {Function? callback}) {
    emit('mark_read', {'threadId': threadId}, ack: callback);
  }

  void sendTyping(String receiverId, bool isTyping) {
    _socket?.emit('typing', {'receiverId': receiverId, 'isTyping': isTyping});
  }

  // Video calling signaling
  void callUser(String toUserId, String sessionId, String callerName) {
    _socket?.emit('call_user', {
      'toUserId': toUserId,
      'sessionId': sessionId,
      'callerName': callerName,
    });
  }

  void answerCall(String toUserId, bool accepted) {
    _socket?.emit('answer_call', {'toUserId': toUserId, 'accepted': accepted});
  }

  void sendWebRTCOffer(String toUserId, dynamic offer) {
    _socket?.emit('webrtc_offer', {'toUserId': toUserId, 'offer': offer});
  }

  void sendWebRTCAnswer(String toUserId, dynamic answer) {
    _socket?.emit('webrtc_answer', {'toUserId': toUserId, 'answer': answer});
  }

  void sendICECandidate(String toUserId, dynamic candidate) {
    _socket?.emit('ice_candidate', {'toUserId': toUserId, 'candidate': candidate});
  }

  void sendWebRTCReady(String toUserId) {
    _socket?.emit('webrtc_ready', {'toUserId': toUserId});
  }

  void endCall(String toUserId) {
    _socket?.emit('end_call', {'toUserId': toUserId});
  }
}

final socketServiceProvider = Provider<SocketService>((ref) {
  return SocketService();
});
