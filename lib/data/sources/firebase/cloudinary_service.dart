import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skill_exchange/core/constants/cloudinary_config.dart';

class CloudinaryService {
  /// Upload an image file to Cloudinary. Returns the secure URL.
  Future<String> uploadImage(File file, {String? folder}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final params = <String, String>{
      'timestamp': timestamp.toString(),
      if (folder != null) 'folder': folder,
    };

    final signature = _generateSignature(params);

    final request = http.MultipartRequest('POST', Uri.parse(CloudinaryConfig.uploadUrl));
    request.fields['api_key'] = CloudinaryConfig.apiKey;
    request.fields['timestamp'] = timestamp.toString();
    request.fields['signature'] = signature;
    if (folder != null) request.fields['folder'] = folder;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Cloudinary upload failed: $body');
    }

    final json = jsonDecode(body) as Map<String, dynamic>;
    return json['secure_url'] as String;
  }

  /// Upload a video file to Cloudinary. Returns the secure URL.
  Future<String> uploadVideo(File file, {String? folder}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final params = <String, String>{
      'timestamp': timestamp.toString(),
      if (folder != null) 'folder': folder,
    };

    final signature = _generateSignature(params);

    final request = http.MultipartRequest('POST', Uri.parse(CloudinaryConfig.videoUploadUrl));
    request.fields['api_key'] = CloudinaryConfig.apiKey;
    request.fields['timestamp'] = timestamp.toString();
    request.fields['signature'] = signature;
    if (folder != null) request.fields['folder'] = folder;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Cloudinary video upload failed: $body');
    }

    final json = jsonDecode(body) as Map<String, dynamic>;
    return json['secure_url'] as String;
  }

  String _generateSignature(Map<String, String> params) {
    final sortedKeys = params.keys.toList()..sort();
    final paramString = sortedKeys.map((k) => '$k=${params[k]}').join('&');
    final toSign = '$paramString${CloudinaryConfig.apiSecret}';
    return sha1.convert(utf8.encode(toSign)).toString();
  }
}

final cloudinaryServiceProvider = Provider<CloudinaryService>((ref) {
  return CloudinaryService();
});
