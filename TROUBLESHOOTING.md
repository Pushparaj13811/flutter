# Troubleshooting Guide — Flutter/Dart Version & Common Issues

## Project Requirements

| Tool | Required Version | Check Command |
|------|-----------------|---------------|
| Flutter | 3.41.x or higher | `flutter --version` |
| Dart SDK | 3.11.x or higher | `dart --version` |
| Android SDK | API 21+ (minSdk) | Android Studio → SDK Manager |
| Java/JDK | 17+ | `java -version` |
| Gradle | 8.x | Auto-managed by Flutter |

---

## Issue 1: Dart SDK Version Mismatch

**Error:**
```
The current Dart SDK version is 3.x.x.
Because skill_exchange requires SDK version ^3.11.1, version solving failed.
```

**Cause:** Your Dart SDK is older than 3.11.1.

**Fix:**
```bash
flutter upgrade
```

If that doesn't work:
```bash
flutter channel stable
flutter upgrade --force
```

If you're stuck on an old Flutter version (e.g., 3.19.x), you can temporarily lower the SDK constraint in `pubspec.yaml`:
```yaml
environment:
  sdk: ^3.x.x  # Replace with your Dart version
```
But this may cause compilation errors if the code uses newer Dart features.

---

## Issue 2: Flutter Version Too Old

**Error:**
```
Error: This requires Flutter 3.41 or higher.
```

**Cause:** Your Flutter SDK is outdated.

**Fix:**
```bash
flutter upgrade
```

To check your current version:
```bash
flutter --version
```

To install a specific version:
```bash
# Switch to stable channel first
flutter channel stable
flutter upgrade
```

---

## Issue 3: Gradle Build Failure (Android)

**Error:**
```
FAILURE: Build failed with an exception.
What went wrong: Could not determine the dependencies of task ':app:compileDebugJavaWithJavac'.
```

**Fix:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

---

## Issue 4: Kotlin Version Mismatch

**Error:**
```
Module was compiled with an incompatible version of Kotlin.
```

**Fix:** Update `android/settings.gradle` or `android/build.gradle` Kotlin version:
```gradle
plugins {
    id "org.jetbrains.kotlin.android" version "1.9.0" apply false
}
```

---

## Issue 5: Java Version Issue

**Error:**
```
Could not target platform: 'Java SE 17' using tool chain: 'JDK 11'
```

**Fix:** Install JDK 17:
```bash
# macOS
brew install openjdk@17

# Ubuntu
sudo apt install openjdk-17-jdk

# Set JAVA_HOME
export JAVA_HOME=/path/to/jdk-17
```

Verify:
```bash
java -version
flutter doctor
```

---

## Issue 6: google-services.json Missing (Android)

**Error:**
```
File google-services.json is missing. The Google Services Plugin cannot function without it.
```

**Cause:** Firebase hasn't been configured for this project.

**Fix:** Follow the steps in `FIREBASE_SETUP.md`:
```bash
flutterfire configure --project=YOUR_PROJECT_ID
```

This generates `android/app/google-services.json` automatically.

---

## Issue 7: Firebase Initialization Error

**Error:**
```
[core/no-app] No Firebase App '[DEFAULT]' has been created
```

**Cause:** `Firebase.initializeApp()` not called or `firebase_options.dart` missing.

**Fix:**
1. Ensure `lib/firebase_options.dart` exists (run `flutterfire configure`)
2. Check `lib/main.dart` has:
```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

---

## Issue 8: MinSdk Version Error (Android)

**Error:**
```
uses-sdk:minSdkVersion 16 cannot be smaller than version 21 declared in library
```

**Fix:** In `android/app/build.gradle`, ensure:
```gradle
android {
    defaultConfig {
        minSdk = 21  // or higher
    }
}
```

---

## Issue 9: CocoaPods Issues (iOS/macOS)

**Error:**
```
Error running pod install
```

**Fix:**
```bash
cd ios  # or cd macos
pod deintegrate
pod install --repo-update
cd ..
flutter clean
flutter pub get
```

If CocoaPods is not installed:
```bash
sudo gem install cocoapods
```

---

## Issue 10: Dependency Version Conflicts

**Error:**
```
Because X depends on Y ^1.0.0 and Z depends on Y ^2.0.0, version solving failed.
```

**Fix:**
```bash
flutter pub upgrade --major-versions
```

Or manually resolve by checking `pubspec.yaml` and adjusting version constraints.

---

## Issue 11: Null Safety Issues

**Error:**
```
Error: This requires the 'non-nullable' language feature to be enabled.
```

**Cause:** Very old Flutter/Dart version that doesn't support null safety.

**Fix:** Upgrade to Dart 3.x+:
```bash
flutter upgrade
```

---

## Issue 12: Platform Not Configured in firebase_options.dart

**Error:**
```
UnsupportedError: DefaultFirebaseOptions have not been configured for ios
```

**Cause:** `flutterfire configure` was only run for Android.

**Fix:**
```bash
flutterfire configure --project=YOUR_PROJECT_ID --platforms=android,ios,macos
```

---

## Issue 13: google_fonts Package Network Error

**Error:**
```
SocketException: Failed to fetch font
```

**Cause:** The `google_fonts` package downloads fonts at runtime. No internet = no fonts.

**Fix:** The app will fall back to system fonts. This is a cosmetic issue only. For offline support, you can bundle fonts:
1. Download Urbanist font from Google Fonts
2. Place in `assets/fonts/`
3. Declare in `pubspec.yaml` under `flutter: fonts:`

---

## Issue 14: Cloudinary Upload Fails

**Error:**
```
Cloudinary upload failed: {"error":{"message":"Invalid API Key"}}
```

**Cause:** Wrong Cloudinary credentials.

**Fix:** Update `lib/core/constants/cloudinary_config.dart` with your own Cloudinary credentials. Sign up at [cloudinary.com](https://cloudinary.com) for free.

---

## Issue 15: SHA-1 Fingerprint Error (Google Sign-In)

**Error:**
```
E/GoogleApiManager: Failed to get service from broker.
SecurityException: Unknown calling package name 'com.google.android.gms'
```

**Cause:** Debug SHA-1 fingerprint not registered in Firebase.

**Fix:**
```bash
# Get SHA-1
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android

# Register in Firebase
firebase apps:android:sha:create YOUR_APP_ID YOUR_SHA1 --project YOUR_PROJECT_ID
```

Or add manually in Firebase Console → Project Settings → Your App → Add Fingerprint.

---

## Quick Reset (Nuclear Option)

If nothing else works, do a full reset:

```bash
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm -rf android/.gradle/
rm -rf ios/Pods/
rm pubspec.lock
flutter pub get
flutter run
```

---

## Environment Check

Run this to verify everything is set up correctly:

```bash
flutter doctor -v
```

Fix any issues it reports before running the app.
