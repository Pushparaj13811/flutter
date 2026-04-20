import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/create_session_dto.dart';
import 'package:skill_exchange/data/models/reschedule_session_dto.dart';
import 'package:skill_exchange/data/models/session_model.dart';

class SessionRemoteSource {
  final Dio _dio;

  SessionRemoteSource(this._dio);

  /// Returns {upcoming: [...], past: [...]}
  Future<Map<String, dynamic>> getSessions() async {
    final response = await _dio.get(Sessions.list);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<SessionModel> getSession(String id) async {
    final response = await _dio.get(Sessions.byId(id));
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<SessionModel> bookSession(CreateSessionDto dto) async {
    final response = await _dio.post(Sessions.book, data: dto.toJson());
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<SessionModel> cancelSession(String id, {String? reason}) async {
    final body = <String, dynamic>{};
    if (reason != null) body['reason'] = reason;
    final response = await _dio.post(Sessions.cancel(id), data: body);
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<SessionModel> completeSession(String id, {String? notes}) async {
    final body = <String, dynamic>{};
    if (notes != null) body['notes'] = notes;
    final response = await _dio.post(Sessions.complete(id), data: body);
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<SessionModel> rescheduleSession(
    String id,
    RescheduleSessionDto dto,
  ) async {
    final response = await _dio.put(
      Sessions.reschedule(id),
      data: dto.toJson(),
    );
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}
