class AgoraConfig {
  const AgoraConfig._();

  // Replace with your Agora App ID from https://console.agora.io
  static const String appId = 'YOUR_AGORA_APP_ID';

  // For development: no token authentication
  // For production: implement a token server (Cloud Function)
  static const String? token = null;
}
