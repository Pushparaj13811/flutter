import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/connection_model.dart';

class ConnectionRemoteSource {
  final Dio _dio;

  ConnectionRemoteSource(this._dio);

  Future<Map<String, dynamic>> getConnections() async {
    final response = await _dio.get(Connections.list);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<ConnectionModel>> getPendingRequests() async {
    final response = await _dio.get(Connections.pending);
    final data = response.data['data']['pending'] as List;
    return data
        .map((e) => ConnectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ConnectionModel>> getSentRequests() async {
    final response = await _dio.get(Connections.sent);
    final data = response.data['data']['sent'] as List;
    return data
        .map((e) => ConnectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ConnectionModel> sendRequest(
    String toUserId,
    String? message,
  ) async {
    final body = <String, dynamic>{'toUserId': toUserId};
    if (message != null && message.isNotEmpty) {
      body['message'] = message;
    }
    final response = await _dio.post(Connections.request, data: body);
    return ConnectionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<ConnectionModel> acceptRequest(String id) async {
    final response = await _dio.post(Connections.accept(id));
    return ConnectionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<ConnectionModel> rejectRequest(String id) async {
    final response = await _dio.post(Connections.reject(id));
    return ConnectionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> removeConnection(String id) async {
    await _dio.delete(Connections.remove(id));
  }
}
