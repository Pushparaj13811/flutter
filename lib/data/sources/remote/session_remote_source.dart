import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/create_session_dto.dart';
import 'package:skill_exchange/data/models/reschedule_session_dto.dart';
import 'package:skill_exchange/data/models/session_model.dart';

class SessionRemoteSource {
  final Dio _dio;

  SessionRemoteSource(this._dio);

  Future<List<SessionModel>> getUpcomingSessions({int? limit}) async {
    final params = <String, dynamic>{};
    if (limit != null) params['limit'] = limit;

    final response = await _dio.get(
      Sessions.upcoming,
      queryParameters: params,
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SessionModel> createSession(CreateSessionDto dto) async {
    final response = await _dio.post(Sessions.create, data: dto.toJson());
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<SessionModel> cancelSession(String id, {String? reason}) async {
    final body = <String, dynamic>{};
    if (reason != null) body['reason'] = reason;

    final response = await _dio.put(Sessions.cancel(id), data: body);
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<SessionModel> completeSession(String id) async {
    final response = await _dio.put(Sessions.complete(id));
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
