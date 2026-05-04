class AgoraConfig {
  const AgoraConfig._();

  // Replace with your Agora App ID from https://console.agora.io
  static const String appId = 'a8cbc37d234d428c9c3220a100b59924';

  // For development: no token authentication
  // For production: implement a token server (Cloud Function)
  static const String? token = null;
}
