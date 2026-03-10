import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_exchange/core/constants/storage_keys.dart';

class SecureStorageSource {
  final FlutterSecureStorage _storage;

  SecureStorageSource(this._storage);

  // ── Access Token ──────────────────────────────────────────────────────

  Future<String?> getAccessToken() async {
    return _storage.read(key: StorageKeys.accessToken);
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: StorageKeys.accessToken, value: token);
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: StorageKeys.accessToken);
  }

  // ── Refresh Token ─────────────────────────────────────────────────────

  Future<String?> getRefreshToken() async {
    return _storage.read(key: StorageKeys.refreshToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: StorageKeys.refreshToken, value: token);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: StorageKeys.refreshToken);
  }

  // ── Bulk Operations ───────────────────────────────────────────────────

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      deleteAccessToken(),
      deleteRefreshToken(),
    ]);
  }

  Future<bool> hasTokens() async {
    final token = await getAccessToken();
    return token != null;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
