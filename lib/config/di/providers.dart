import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Re-export all Firebase service providers
export 'package:skill_exchange/data/sources/firebase/firebase_auth_service.dart';
export 'package:skill_exchange/data/sources/firebase/cloudinary_service.dart';
export 'package:skill_exchange/data/sources/firebase/profile_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/connection_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/session_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/messaging_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/review_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/notification_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/community_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/matching_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/search_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/admin_firestore_service.dart';
export 'package:skill_exchange/data/sources/firebase/call_firestore_service.dart';

// ── Local Storage ─────────────────────────────────────────────────────────

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with a real instance.',
  );
});
