import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';

class ReportRemoteSource {
  final Dio _dio;

  ReportRemoteSource(this._dio);

  Future<Map<String, dynamic>> submitReport(Map<String, dynamic> data) async {
    final response = await _dio.post(Reports.create, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }
}
