class CloudinaryConfig {
  CloudinaryConfig._();

  static const String cloudName = 'dqqyq68df';
  static const String apiKey = '389891321894538';
  static const String apiSecret = 'aiTdLzMx1StFoE5EarbW-KFYDok';
  static const String uploadPreset = 'skill_exchange';

  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
  static String get videoUploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/video/upload';
}
