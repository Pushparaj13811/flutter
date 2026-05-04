# Reviews, Agora Video Call & UI/UX Overhaul — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add session-based reviews, in-app Agora video calling, and overhaul the entire UI to be compact and mobile-native.

**Architecture:** Three independent feature tracks: (1) Review system wired to session completion flow, (2) Agora RTC video call with Firestore signaling, (3) Global design token tightening + screen-by-screen UI polish. All use existing Riverpod + Firestore patterns.

**Tech Stack:** Flutter 3.11, Riverpod 2.6, Agora RTC Engine, Cloud Firestore, GoRouter

---

## File Structure

### New Files
| File | Responsibility |
|------|----------------|
| `lib/features/sessions/widgets/video_call_screen.dart` | Full-screen Agora video call UI (remote/local video, controls) |
| `lib/features/sessions/widgets/incoming_call_overlay.dart` | Incoming call UI (accept/decline) |
| `lib/features/sessions/providers/call_provider.dart` | Call state management (Riverpod StateNotifier) |
| `lib/core/services/agora_service.dart` | Agora RTC engine lifecycle wrapper |
| `lib/core/constants/agora_config.dart` | Agora App ID constant |

### Modified Files
| File | Changes |
|------|---------|
| `pubspec.yaml` | Add `agora_rtc_engine`, `permission_handler` |
| `lib/core/theme/app_spacing.dart` | Tighten spacing tokens |
| `lib/core/theme/app_radius.dart` | Tighten radius tokens |
| `lib/core/theme/app_text_styles.dart` | Adjust font sizes |
| `lib/core/theme/app_theme.dart` | Update component themes (buttons, inputs, nav) |
| `lib/core/widgets/app_card.dart` | Reduce default padding |
| `lib/core/widgets/app_button.dart` | Compact button padding |
| `lib/core/widgets/app_text_field.dart` | Compact input padding |
| `lib/core/widgets/skill_tag.dart` | Smaller chip padding |
| `lib/config/router/app_shell.dart` | 4-tab nav + center FAB |
| `lib/config/router/app_router.dart` | Add video call route, remove community tab route adjustments |
| `lib/data/models/session_model.dart` | Add `isReviewed` field |
| `lib/data/models/create_review_dto.dart` | Make `sessionId` required |
| `lib/data/sources/firebase/review_firestore_service.dart` | Add `hasReviewedSession` method |
| `lib/features/sessions/providers/session_provider.dart` | Parse `isReviewed` field |
| `lib/features/sessions/screens/sessions_screen.dart` | Wire review prompt on completion |
| `lib/features/sessions/widgets/session_card.dart` | Add "Leave Review" button for completed sessions |
| `lib/features/reviews/widgets/review_sheet.dart` | Pre-populate skills from session |
| `lib/features/settings/screens/settings_screen.dart` | Redesign to clean list style |
| `lib/features/dashboard/screens/dashboard_screen.dart` | Compact layout overhaul |
| `lib/features/profile/screens/profile_screen.dart` | Gradient header + settings link |
| `lib/features/matching/screens/matching_screen.dart` | Compact cards |
| `lib/features/connections/screens/connections_screen.dart` | Tight list items |
| `lib/features/messaging/screens/chat_screen.dart` | Add call button + compact bubbles |
| `lib/features/community/screens/community_screen.dart` | Compact posts |
| `lib/features/auth/screens/login_screen.dart` | Tighter form spacing |
| `lib/features/auth/screens/signup_screen.dart` | Tighter form spacing |

---

## Phase 1: UI/UX Overhaul — Design System & Global Tokens

### Task 1: Tighten Global Spacing & Radius Tokens

**Files:**
- Modify: `lib/core/theme/app_spacing.dart`
- Modify: `lib/core/theme/app_radius.dart`

- [ ] **Step 1: Update spacing tokens**

In `lib/core/theme/app_spacing.dart`, change these values:

```dart
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 6.0;
  static const double md = 10.0;
  static const double lg = 14.0;
  static const double xl = 20.0;
  static const double xxl = 28.0;
  static const double xxxl = 40.0;

  // Specific component spacing
  static const double cardPadding = 12.0;
  static const double screenPadding = 14.0;
  static const double sectionGap = 16.0;
  static const double listItemGap = 8.0;
  static const double inputGap = 12.0;
}
```

- [ ] **Step 2: Update radius tokens**

In `lib/core/theme/app_radius.dart`, change these values:

```dart
class AppRadius {
  const AppRadius._();

  static const double xs = 4.0;
  static const double sm = 6.0;
  static const double md = 10.0;
  static const double lg = 14.0;
  static const double xl = 20.0;
  static const double xxl = 28.0;
  static const double full = 9999.0;

  // Specific component radii
  static const double button = 10.0;
  static const double card = 10.0;
  static const double input = 8.0;
  static const double chip = 9999.0;
  static const double avatar = 9999.0;
  static const double sheet = 14.0;
}
```

- [ ] **Step 3: Verify the app still builds**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`
Expected: BUILD SUCCESSFUL

- [ ] **Step 4: Commit**

```bash
git add lib/core/theme/app_spacing.dart lib/core/theme/app_radius.dart
git commit -m "refactor: tighten global spacing and radius tokens for compact mobile UI"
```

---

### Task 2: Update Typography Sizes

**Files:**
- Modify: `lib/core/theme/app_text_styles.dart`

- [ ] **Step 1: Reduce body and label font sizes slightly**

In `lib/core/theme/app_text_styles.dart`, update these lines:

```dart
  // Headings — keep as-is (they're already good)
  static final TextStyle h1 = _base(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2);
  static final TextStyle h2 = _base(fontSize: 22, fontWeight: FontWeight.w600, height: 1.25);
  static final TextStyle h3 = _base(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3);
  static final TextStyle h4 = _base(fontSize: 16, fontWeight: FontWeight.w600, height: 1.35);

  // Body
  static final TextStyle bodyLarge = _base(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5);
  static final TextStyle bodyMedium = _base(fontSize: 13, fontWeight: FontWeight.w400, height: 1.5);
  static final TextStyle bodySmall = _base(fontSize: 11, fontWeight: FontWeight.w400, height: 1.5);

  // Labels
  static final TextStyle labelLarge = _base(fontSize: 13, fontWeight: FontWeight.w500, height: 1.4);
  static final TextStyle labelMedium = _base(fontSize: 11, fontWeight: FontWeight.w500, height: 1.4);
  static final TextStyle labelSmall = _base(fontSize: 10, fontWeight: FontWeight.w500, height: 1.4);

  // Caption
  static final TextStyle caption = _base(fontSize: 11, fontWeight: FontWeight.w400, height: 1.4);
```

- [ ] **Step 2: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 3: Commit**

```bash
git add lib/core/theme/app_text_styles.dart
git commit -m "refactor: reduce typography sizes for compact mobile layout"
```

---

### Task 3: Update Theme Component Styles

**Files:**
- Modify: `lib/core/theme/app_theme.dart`

- [ ] **Step 1: Compact button and input padding in light theme**

In `lib/core/theme/app_theme.dart`, update the `elevatedButtonTheme` padding in `lightTheme()`:

Change `padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)` to `padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)` for both `elevatedButtonTheme` and `outlinedButtonTheme` in BOTH `lightTheme()` and `darkTheme()`.

Also update `bottomNavigationBarTheme` in both themes to remove elevation:

```dart
bottomNavigationBarTheme: const BottomNavigationBarThemeData(
  backgroundColor: AppColors.card,
  selectedItemColor: AppColors.primary,
  unselectedItemColor: AppColors.mutedForeground,
  type: BottomNavigationBarType.fixed,
  elevation: 0,
),
```

- [ ] **Step 2: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 3: Commit**

```bash
git add lib/core/theme/app_theme.dart
git commit -m "refactor: compact theme component padding, remove nav bar elevation"
```

---

### Task 4: Compact Core Widgets

**Files:**
- Modify: `lib/core/widgets/app_card.dart`
- Modify: `lib/core/widgets/app_button.dart`
- Modify: `lib/core/widgets/skill_tag.dart`

- [ ] **Step 1: Reduce AppCard default padding**

In `lib/core/widgets/app_card.dart`, the default padding is already `AppSpacing.cardPadding` which we changed to 12 in Task 1. But also remove the shadow for a flatter look, use a border instead:

Replace the `BoxDecoration` in both the `onTap` and non-`onTap` branches:

```dart
decoration: BoxDecoration(
  color: colors.card,
  borderRadius: borderRadius,
  border: Border.all(color: colors.border.withValues(alpha: 0.5)),
),
```

Remove the import of `app_shadows.dart` if it becomes unused.

- [ ] **Step 2: Add icon variant to AppButton with compact sizing**

In `lib/core/widgets/app_button.dart`, reduce the loading indicator and icon sizes. In `_buildLabelRow`, change icon size from 18 to 16:

```dart
Icon(icon, size: 16, color: foreground),
```

- [ ] **Step 3: Compact SkillTag padding**

In `lib/core/widgets/skill_tag.dart`, the padding already uses `AppSpacing.sm` and `AppSpacing.xs` which we reduced. No code change needed — the token change handles it.

- [ ] **Step 4: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/app_card.dart lib/core/widgets/app_button.dart
git commit -m "refactor: flatten cards with border, compact button icon size"
```

---

### Task 5: Redesign Bottom Navigation with FAB

**Files:**
- Modify: `lib/config/router/app_shell.dart`
- Modify: `lib/config/router/app_router.dart`

- [ ] **Step 1: Redesign AppShell with 4 tabs + center FAB**

Replace `lib/config/router/app_shell.dart` entirely:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home', path: RouteNames.dashboard),
    _TabItem(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Discover', path: RouteNames.matching),
    _TabItem(icon: Icons.people_outline, activeIcon: Icons.people, label: 'Connects', path: RouteNames.connections),
    _TabItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', path: RouteNames.profile),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final colors = context.colors;

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.search),
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.card,
          border: Border(
            top: BorderSide(color: colors.border.withValues(alpha: 0.3)),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // First two tabs
                _buildNavItem(context, 0, currentIndex, colors),
                _buildNavItem(context, 1, currentIndex, colors),
                // Space for FAB
                const SizedBox(width: 56),
                // Last two tabs
                _buildNavItem(context, 2, currentIndex, colors),
                _buildNavItem(context, 3, currentIndex, colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, int currentIndex, AppColorsExtension colors) {
    final tab = _tabs[index];
    final isSelected = index == currentIndex;
    final color = isSelected ? colors.primary : colors.mutedForeground;

    return Expanded(
      child: InkWell(
        onTap: () => context.go(tab.path),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? tab.activeIcon : tab.icon,
              size: 22,
              color: color,
            ),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
  });
}
```

- [ ] **Step 2: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 3: Commit**

```bash
git add lib/config/router/app_shell.dart
git commit -m "feat: redesign bottom nav with 4 tabs and center FAB"
```

---

### Task 6: Redesign Settings Screen (Clean List Style)

**Files:**
- Modify: `lib/features/settings/screens/settings_screen.dart`

- [ ] **Step 1: Rewrite settings screen with flat list design**

Replace the `_buildSettings` method body and the `_SectionCard` widget with a flat list design. The new settings screen should use simple `ListTile`-style rows with leading icons in colored circles, thin dividers, and section headers as small text labels.

Replace `_SectionCard` with a simpler `_SectionHeader` widget:

```dart
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.screenPadding,
        top: AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: context.colors.mutedForeground,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
```

Replace `_SettingsTile` with a version that has a colored circle icon:

```dart
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.colors,
    required this.icon,
    required this.title,
    this.titleColor,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.iconColor,
  });

  final AppColorsExtension colors;
  final IconData icon;
  final String title;
  final Color? titleColor;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = iconColor ?? colors.primary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: effectiveColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, size: 18, color: effectiveColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: titleColor ?? colors.foreground,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!
            else Icon(Icons.chevron_right, size: 18, color: colors.mutedForeground),
          ],
        ),
      ),
    );
  }
}
```

Update the `_buildSettings` method to use the new flat layout:

```dart
Widget _buildSettings(
  BuildContext context,
  WidgetRef ref,
  SettingsState settings,
  AppColorsExtension colors,
) {
  final themeMode = ref.watch(themeModeProvider);
  final notifier = ref.read(settingsNotifierProvider.notifier);

  return ListView(
    children: [
      // Account
      const _SectionHeader(title: 'Account'),
      _SettingsTile(
        colors: colors,
        icon: Icons.lock_outline,
        title: 'Change Password',
        onTap: () => _showChangePasswordDialog(context),
      ),
      _thinDivider(colors),
      _SettingsTile(
        colors: colors,
        icon: Icons.email_outlined,
        title: 'Change Email',
        onTap: () => _showChangeEmailDialog(context),
      ),
      _thinDivider(colors),
      _SettingsTile(
        colors: colors,
        icon: Icons.delete_outline,
        title: 'Delete Account',
        titleColor: colors.destructive,
        iconColor: colors.destructive,
        onTap: () => _showDeleteAccountDialog(context, ref),
      ),

      // Notifications
      const _SectionHeader(title: 'Notifications'),
      _SettingsToggle(
        colors: colors,
        icon: Icons.notifications_active_outlined,
        title: 'Push Notifications',
        value: settings.pushNotifications,
        onChanged: (v) => notifier.updatePushNotifications(v),
      ),
      _thinDivider(colors),
      _SettingsToggle(
        colors: colors,
        icon: Icons.mark_email_read_outlined,
        title: 'Email Notifications',
        value: settings.emailNotifications,
        onChanged: (v) => notifier.updateEmailNotifications(v),
      ),
      _thinDivider(colors),
      _SettingsToggle(
        colors: colors,
        icon: Icons.alarm_outlined,
        title: 'Session Reminders',
        value: settings.sessionReminders,
        onChanged: (v) => notifier.updateSessionReminders(v),
      ),

      // Privacy
      const _SectionHeader(title: 'Privacy'),
      _SettingsTile(
        colors: colors,
        icon: Icons.visibility_outlined,
        title: 'Profile Visibility',
        trailing: _VisibilityDropdown(
          colors: colors,
          value: settings.profileVisibility,
          onChanged: (v) => notifier.updateProfileVisibility(v),
        ),
        onTap: null,
      ),
      _thinDivider(colors),
      _SettingsToggle(
        colors: colors,
        icon: Icons.alternate_email,
        title: 'Show Email',
        value: settings.showEmail,
        onChanged: (v) => notifier.updateShowEmail(v),
      ),
      _thinDivider(colors),
      _SettingsToggle(
        colors: colors,
        icon: Icons.schedule_outlined,
        title: 'Show Availability',
        value: settings.showAvailability,
        onChanged: (v) => notifier.updateShowAvailability(v),
      ),

      // Appearance
      const _SectionHeader(title: 'Appearance'),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(Icons.brightness_6_outlined, size: 18, color: colors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Theme',
                style: AppTextStyles.bodyMedium.copyWith(color: colors.foreground),
              ),
            ),
            _ThemeSegmentedControl(
              colors: colors,
              value: themeMode,
              onChanged: (mode) => ref.read(themeModeProvider.notifier).setThemeMode(mode),
            ),
          ],
        ),
      ),

      const SizedBox(height: AppSpacing.xl),

      // Log Out
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: _SettingsTile(
          colors: colors,
          icon: Icons.logout,
          title: 'Log Out',
          titleColor: colors.destructive,
          iconColor: colors.destructive,
          trailing: const SizedBox.shrink(),
          onTap: () => _handleLogout(context, ref),
        ),
      ),

      // Version
      Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Text(
            'Skill Exchange v1.0.0',
            style: AppTextStyles.caption.copyWith(color: colors.mutedForeground),
          ),
        ),
      ),
    ],
  );
}

Widget _thinDivider(AppColorsExtension colors) {
  return Divider(
    height: 1,
    indent: AppSpacing.screenPadding + 36 + AppSpacing.md,
    color: colors.border.withValues(alpha: 0.3),
  );
}
```

Also update `_SettingsToggle` to use the colored circle icon style:

```dart
class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({
    required this.colors,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final AppColorsExtension colors;
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 18, color: colors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(color: colors.foreground),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: colors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 3: Commit**

```bash
git add lib/features/settings/screens/settings_screen.dart
git commit -m "feat: redesign settings screen with clean flat list style"
```

---

### Task 7: Compact Dashboard Screen

**Files:**
- Modify: `lib/features/dashboard/screens/dashboard_screen.dart`

- [ ] **Step 1: Update the SectionHeader to include View All**

Replace the `_SectionHeader` widget in dashboard_screen.dart:

```dart
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.h4.copyWith(color: colors.foreground),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'View All',
                style: AppTextStyles.labelMedium.copyWith(color: colors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Compact the session reminder card padding**

In `_SessionReminderCard`, change `padding: const EdgeInsets.all(AppSpacing.lg)` to `padding: const EdgeInsets.all(AppSpacing.md)`.

- [ ] **Step 3: Compact the suggested user card**

In `_SuggestedUserCard`, reduce `width: 140` to `width: 120`, reduce `CircleAvatar radius: 28` to `radius: 24`, reduce the overall `height: 190` to `height: 170` in `_SuggestedUsersSection`.

- [ ] **Step 4: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 5: Commit**

```bash
git add lib/features/dashboard/screens/dashboard_screen.dart
git commit -m "refactor: compact dashboard with tighter cards and section headers"
```

---

### Task 8: Compact Remaining Screens (Sessions, Connections, Auth)

**Files:**
- Modify: `lib/features/sessions/widgets/session_card.dart`
- Modify: `lib/features/connections/screens/connections_screen.dart`
- Modify: `lib/features/auth/screens/login_screen.dart`
- Modify: `lib/features/auth/screens/signup_screen.dart`

- [ ] **Step 1: Compact session card spacing**

In `lib/features/sessions/widgets/session_card.dart`:
- Change all `SizedBox(height: AppSpacing.md)` between sections to `SizedBox(height: AppSpacing.sm)`
- Change `SizedBox(height: AppSpacing.lg)` before actions to `SizedBox(height: AppSpacing.md)`

- [ ] **Step 2: Compact connections screen**

In `lib/features/connections/screens/connections_screen.dart`, look for any explicit padding/spacing values and reduce them. Specifically ensure list item vertical padding is 6-8px and avatar sizes are 40px max.

- [ ] **Step 3: Compact auth screen form spacing**

In login_screen.dart and signup_screen.dart, reduce spacing between form fields. Replace any `SizedBox(height: 16)` or `SizedBox(height: AppSpacing.lg)` between form fields with `SizedBox(height: AppSpacing.md)`.

- [ ] **Step 4: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 5: Commit**

```bash
git add lib/features/sessions/widgets/session_card.dart lib/features/connections/screens/connections_screen.dart lib/features/auth/screens/login_screen.dart lib/features/auth/screens/signup_screen.dart
git commit -m "refactor: compact session cards, connections list, and auth forms"
```

---

## Phase 2: Session-Based Review System

### Task 9: Update Session Model with isReviewed Flag

**Files:**
- Modify: `lib/data/models/session_model.dart`

- [ ] **Step 1: Add isReviewed field to SessionModel**

Add `isReviewed` to the SessionModel class:

After `final UserProfileModel? participant;` add:
```dart
final bool isReviewed;
```

In the constructor, add:
```dart
this.isReviewed = false,
```

In `fromMap`, add:
```dart
isReviewed: map['isReviewed'] as bool? ?? false,
```

In `toMap`, add:
```dart
'isReviewed': isReviewed,
```

In `copyWith`, add the parameter:
```dart
bool? isReviewed,
```

And in the return:
```dart
isReviewed: isReviewed ?? this.isReviewed,
```

- [ ] **Step 2: Update session parser in provider**

In `lib/features/sessions/providers/session_provider.dart`, update `_parseSession` to include:

```dart
isReviewed: d['isReviewed'] as bool? ?? false,
```

Add it after the `updatedAt` line.

- [ ] **Step 3: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 4: Commit**

```bash
git add lib/data/models/session_model.dart lib/features/sessions/providers/session_provider.dart
git commit -m "feat: add isReviewed flag to SessionModel"
```

---

### Task 10: Make sessionId Required in CreateReviewDto

**Files:**
- Modify: `lib/data/models/create_review_dto.dart`

- [ ] **Step 1: Change sessionId from optional to required**

In `lib/data/models/create_review_dto.dart`, change:

```dart
class CreateReviewDto {
  final String toUserId;
  final int rating;
  final String comment;
  final List<String> skillsReviewed;
  final String sessionId;

  const CreateReviewDto({
    this.toUserId = '',
    this.rating = 0,
    this.comment = '',
    this.skillsReviewed = const [],
    this.sessionId = '',
  });

  factory CreateReviewDto.fromMap(Map<String, dynamic> map) {
    return CreateReviewDto(
      toUserId: map['toUserId'] as String? ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['comment'] as String? ?? '',
      skillsReviewed: (map['skillsReviewed'] as List?)?.cast<String>() ?? [],
      sessionId: map['sessionId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'toUserId': toUserId,
        'rating': rating,
        'comment': comment,
        'skillsReviewed': skillsReviewed,
        'sessionId': sessionId,
      };

  Map<String, dynamic> toJson() => toMap();
}
```

- [ ] **Step 2: Update ReviewSheet to require sessionId**

In `lib/features/reviews/widgets/review_sheet.dart`, change `this.sessionId` from optional to required:

```dart
const ReviewSheet({
  super.key,
  required this.toUserId,
  required this.toUserName,
  required this.sessionId,
  this.prePopulatedSkills = const [],
});

final String toUserId;
final String toUserName;
final String sessionId;
final List<String> prePopulatedSkills;
```

Update `initState` to pre-populate skills:

```dart
@override
void initState() {
  super.initState();
  _skillsReviewed.addAll(widget.prePopulatedSkills);
}
```

Update `_submit` to use the non-nullable sessionId:

```dart
final dto = CreateReviewDto(
  toUserId: widget.toUserId,
  rating: _rating,
  comment: _commentController.text.trim(),
  skillsReviewed: _skillsReviewed,
  sessionId: widget.sessionId,
);
```

- [ ] **Step 3: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

Note: There may be compilation errors from other call sites of ReviewSheet — fix those in the next task.

- [ ] **Step 4: Commit**

```bash
git add lib/data/models/create_review_dto.dart lib/features/reviews/widgets/review_sheet.dart
git commit -m "feat: make sessionId required for reviews, add pre-populated skills"
```

---

### Task 11: Wire Review into Session Completion Flow

**Files:**
- Modify: `lib/features/sessions/screens/sessions_screen.dart`
- Modify: `lib/features/sessions/widgets/session_card.dart`

- [ ] **Step 1: Add review sheet trigger after session completion**

In `lib/features/sessions/screens/sessions_screen.dart`, add the ReviewSheet import at the top:

```dart
import 'package:skill_exchange/features/reviews/widgets/review_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
```

Then update the `_onComplete` method. After the success snackbar, show the review sheet:

```dart
void _onComplete(
  BuildContext context,
  WidgetRef ref,
  SessionModel session,
) {
  showDialog<bool>(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      title: const Text('Complete Session'),
      content: Text('Mark "${session.title}" as completed?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogCtx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogCtx).pop(true),
          child: const Text('Complete'),
        ),
      ],
    ),
  ).then((confirmed) async {
    if (confirmed == true) {
      try {
        await ref
            .read(sessionsNotifierProvider.notifier)
            .completeSession(session.id);
        ref.invalidate(upcomingSessionsProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session marked as completed'),
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Auto-prompt review
          final currentUid = fb.FirebaseAuth.instance.currentUser?.uid ?? '';
          final otherUserId = session.hostId == currentUid
              ? session.participantId
              : session.hostId;
          final otherUserName = session.hostId == currentUid
              ? (session.participant?.fullName ?? session.participantId)
              : (session.host?.fullName ?? session.hostId);

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => ReviewSheet(
              toUserId: otherUserId,
              toUserName: otherUserName,
              sessionId: session.id,
              prePopulatedSkills: session.skillsToCover,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to complete session: $e'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: context.colors.destructive,
            ),
          );
        }
      }
    }
  });
}
```

- [ ] **Step 2: Add "Leave Review" button to completed session cards**

In `lib/features/sessions/widgets/session_card.dart`:

Add a new callback parameter:

```dart
final VoidCallback? onLeaveReview;
```

Add it to the constructor:

```dart
const SessionCard({
  super.key,
  required this.session,
  this.onJoinMeeting,
  this.onComplete,
  this.onReschedule,
  this.onCancel,
  this.onLeaveReview,
});
```

After the existing scheduled action buttons block, add a completed + not reviewed block:

```dart
if (session.status == SessionStatus.completed && !session.isReviewed) ...[
  const SizedBox(height: AppSpacing.md),
  SizedBox(
    width: double.infinity,
    child: AppButton.outline(
      label: 'Leave Review',
      onPressed: onLeaveReview,
    ),
  ),
],
```

Add this right before the closing `]` of the main Column children.

- [ ] **Step 3: Wire the review callback in SessionsScreen**

In `lib/features/sessions/screens/sessions_screen.dart`, update the `SessionCard` builder to include `onLeaveReview`:

```dart
return SessionCard(
  session: session,
  onJoinMeeting: () => _onJoinMeeting(context, session),
  onComplete: () => _onComplete(context, ref, session),
  onReschedule: () => _onReschedule(context, session),
  onCancel: () => _onCancel(context, ref, session),
  onLeaveReview: session.status == SessionStatus.completed && !session.isReviewed
      ? () {
          final currentUid = fb.FirebaseAuth.instance.currentUser?.uid ?? '';
          final otherUserId = session.hostId == currentUid
              ? session.participantId
              : session.hostId;
          final otherUserName = session.hostId == currentUid
              ? (session.participant?.fullName ?? session.participantId)
              : (session.host?.fullName ?? session.hostId);

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => ReviewSheet(
              toUserId: otherUserId,
              toUserName: otherUserName,
              sessionId: session.id,
              prePopulatedSkills: session.skillsToCover,
            ),
          );
        }
      : null,
);
```

- [ ] **Step 4: Fix any remaining ReviewSheet call sites**

Search the codebase for other uses of `ReviewSheet(` and update them to pass the required `sessionId` parameter. If ReviewSheet is used from profile or other places without a session context, those call sites should be removed since reviews are now session-based only.

Run: `grep -rn 'ReviewSheet(' lib/` to find all call sites.

- [ ] **Step 5: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 6: Commit**

```bash
git add lib/features/sessions/screens/sessions_screen.dart lib/features/sessions/widgets/session_card.dart
git commit -m "feat: wire review prompt on session completion, add Leave Review button"
```

---

## Phase 3: Agora Video Call

### Task 12: Add Agora Dependencies

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/core/constants/agora_config.dart`

- [ ] **Step 1: Add agora_rtc_engine and permission_handler to pubspec.yaml**

Add under `dependencies:` after the `# Utilities` section:

```yaml
  # Video Call
  agora_rtc_engine: ^6.3.2
  permission_handler: ^11.3.1
```

- [ ] **Step 2: Create Agora config file**

Create `lib/core/constants/agora_config.dart`:

```dart
class AgoraConfig {
  const AgoraConfig._();

  // TODO: Replace with your Agora App ID from https://console.agora.io
  static const String appId = 'YOUR_AGORA_APP_ID';

  // For development: no token authentication
  // For production: implement a token server (Cloud Function)
  static const String? token = null;
}
```

- [ ] **Step 3: Run flutter pub get**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter pub get`

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/core/constants/agora_config.dart
git commit -m "feat: add Agora RTC and permission_handler dependencies"
```

---

### Task 13: Create Agora Service Wrapper

**Files:**
- Create: `lib/core/services/agora_service.dart`

- [ ] **Step 1: Create the Agora RTC service**

Create `lib/core/services/agora_service.dart`:

```dart
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skill_exchange/core/constants/agora_config.dart';

class AgoraService {
  RtcEngine? _engine;
  bool _isInitialized = false;

  RtcEngine? get engine => _engine;
  bool get isInitialized => _isInitialized;

  Future<bool> requestPermissions() async {
    final camera = await Permission.camera.request();
    final mic = await Permission.microphone.request();
    return camera.isGranted && mic.isGranted;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: AgoraConfig.appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    await _engine!.enableVideo();
    await _engine!.startPreview();

    _isInitialized = true;
  }

  Future<void> joinChannel(String channelId, int uid) async {
    if (!_isInitialized) await initialize();

    await _engine!.joinChannel(
      token: AgoraConfig.token ?? '',
      channelId: channelId,
      uid: uid,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
  }

  Future<void> toggleMute(bool muted) async {
    await _engine?.muteLocalAudioStream(muted);
  }

  Future<void> toggleCamera(bool enabled) async {
    if (enabled) {
      await _engine?.enableLocalVideo(true);
    } else {
      await _engine?.enableLocalVideo(false);
    }
  }

  Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  Future<void> dispose() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    _isInitialized = false;
  }
}

final agoraServiceProvider = Provider<AgoraService>((ref) {
  final service = AgoraService();
  ref.onDispose(() => service.dispose());
  return service;
});
```

- [ ] **Step 2: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 3: Commit**

```bash
git add lib/core/services/agora_service.dart
git commit -m "feat: create Agora RTC service wrapper with permissions"
```

---

### Task 14: Create Call State Provider

**Files:**
- Create: `lib/features/sessions/providers/call_provider.dart`

- [ ] **Step 1: Create the call state notifier**

Create `lib/features/sessions/providers/call_provider.dart`:

```dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/services/agora_service.dart';
import 'package:skill_exchange/data/sources/firebase/call_firestore_service.dart';

enum CallStatus { idle, ringing, connecting, active, ended, declined }

class CallState {
  final CallStatus status;
  final String? callId;
  final String? remoteUserId;
  final String? remoteUserName;
  final bool isMuted;
  final bool isCameraOn;
  final int? remoteUid;
  final Duration duration;

  const CallState({
    this.status = CallStatus.idle,
    this.callId,
    this.remoteUserId,
    this.remoteUserName,
    this.isMuted = false,
    this.isCameraOn = true,
    this.remoteUid,
    this.duration = Duration.zero,
  });

  CallState copyWith({
    CallStatus? status,
    String? callId,
    String? remoteUserId,
    String? remoteUserName,
    bool? isMuted,
    bool? isCameraOn,
    int? remoteUid,
    Duration? duration,
  }) {
    return CallState(
      status: status ?? this.status,
      callId: callId ?? this.callId,
      remoteUserId: remoteUserId ?? this.remoteUserId,
      remoteUserName: remoteUserName ?? this.remoteUserName,
      isMuted: isMuted ?? this.isMuted,
      isCameraOn: isCameraOn ?? this.isCameraOn,
      remoteUid: remoteUid ?? this.remoteUid,
      duration: duration ?? this.duration,
    );
  }
}

class CallNotifier extends StateNotifier<CallState> {
  final AgoraService _agora;
  final CallFirestoreService _callService;
  StreamSubscription? _callStreamSub;
  Timer? _durationTimer;

  CallNotifier(this._agora, this._callService) : super(const CallState());

  Future<bool> startCall(String calleeUid, String calleeName) async {
    final hasPerms = await _agora.requestPermissions();
    if (!hasPerms) return false;

    try {
      await _agora.initialize();
      final callId = await _callService.createCall(calleeUid);

      state = state.copyWith(
        status: CallStatus.ringing,
        callId: callId,
        remoteUserId: calleeUid,
        remoteUserName: calleeName,
      );

      _listenToCall(callId);
      await _agora.joinChannel(callId, 0);

      return true;
    } catch (e) {
      state = const CallState();
      return false;
    }
  }

  Future<bool> acceptCall(String callId, String callerName) async {
    final hasPerms = await _agora.requestPermissions();
    if (!hasPerms) return false;

    try {
      await _agora.initialize();
      await _callService.setAnswer(callId, {'accepted': true});

      state = state.copyWith(
        status: CallStatus.connecting,
        callId: callId,
        remoteUserName: callerName,
      );

      await _agora.joinChannel(callId, 1);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> declineCall(String callId) async {
    await _callService.declineCall(callId);
    state = const CallState();
  }

  Future<void> endCall() async {
    final callId = state.callId;
    if (callId != null) {
      await _callService.endCall(callId);
    }
    await _cleanup();
    state = const CallState();
  }

  void toggleMute() {
    final muted = !state.isMuted;
    _agora.toggleMute(muted);
    state = state.copyWith(isMuted: muted);
  }

  void toggleCamera() {
    final on = !state.isCameraOn;
    _agora.toggleCamera(on);
    state = state.copyWith(isCameraOn: on);
  }

  void switchCamera() {
    _agora.switchCamera();
  }

  void onRemoteUserJoined(int uid) {
    state = state.copyWith(
      status: CallStatus.active,
      remoteUid: uid,
    );
    _startDurationTimer();
  }

  void onRemoteUserLeft(int uid) {
    endCall();
  }

  void _listenToCall(String callId) {
    _callStreamSub = _callService.callStream(callId).listen((snapshot) {
      final data = snapshot.data();
      if (data == null) return;
      final status = data['status'] as String?;
      if (status == 'ended' || status == 'declined') {
        _cleanup();
        state = state.copyWith(
          status: status == 'declined' ? CallStatus.declined : CallStatus.ended,
        );
      } else if (status == 'active') {
        state = state.copyWith(status: CallStatus.connecting);
      }
    });
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(
        duration: state.duration + const Duration(seconds: 1),
      );
    });
  }

  Future<void> _cleanup() async {
    _callStreamSub?.cancel();
    _durationTimer?.cancel();
    await _agora.leaveChannel();
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }
}

final callNotifierProvider =
    StateNotifierProvider<CallNotifier, CallState>((ref) {
  final agora = ref.watch(agoraServiceProvider);
  final callService = ref.watch(callFirestoreServiceProvider);
  return CallNotifier(agora, callService);
});

final incomingCallsProvider = StreamProvider((ref) {
  final service = ref.watch(callFirestoreServiceProvider);
  return service.incomingCallsStream();
});
```

- [ ] **Step 2: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 3: Commit**

```bash
git add lib/features/sessions/providers/call_provider.dart
git commit -m "feat: create call state provider with Agora integration"
```

---

### Task 15: Create Video Call Screen

**Files:**
- Create: `lib/features/sessions/widgets/video_call_screen.dart`

- [ ] **Step 1: Create the full-screen video call UI**

Create `lib/features/sessions/widgets/video_call_screen.dart`:

```dart
import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/services/agora_service.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/features/sessions/providers/call_provider.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  const VideoCallScreen({
    super.key,
    required this.channelId,
    required this.remoteUserName,
    required this.isCaller,
  });

  final String channelId;
  final String remoteUserName;
  final bool isCaller;

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  bool _controlsVisible = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _setupAgoraCallbacks();
    _resetControlsTimer();
  }

  void _setupAgoraCallbacks() {
    final agora = ref.read(agoraServiceProvider);
    final engine = agora.engine;
    if (engine == null) return;

    engine.registerEventHandler(RtcEngineEventHandler(
      onUserJoined: (connection, remoteUid, elapsed) {
        ref.read(callNotifierProvider.notifier).onRemoteUserJoined(remoteUid);
      },
      onUserOffline: (connection, remoteUid, reason) {
        ref.read(callNotifierProvider.notifier).onRemoteUserLeft(remoteUid);
      },
    ));
  }

  void _resetControlsTimer() {
    _hideControlsTimer?.cancel();
    setState(() => _controlsVisible = true);
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _controlsVisible = false);
    });
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callNotifierProvider);
    final agora = ref.read(agoraServiceProvider);
    final colors = context.colors;

    // Auto-pop when call ends
    if (callState.status == CallStatus.ended ||
        callState.status == CallStatus.declined) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _resetControlsTimer,
        child: Stack(
          children: [
            // Remote video (full screen)
            if (callState.remoteUid != null && agora.engine != null)
              AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: agora.engine!,
                  canvas: VideoCanvas(uid: callState.remoteUid!),
                  connection: RtcConnection(channelId: widget.channelId),
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: colors.muted,
                      child: Text(
                        widget.remoteUserName.isNotEmpty
                            ? widget.remoteUserName[0].toUpperCase()
                            : '?',
                        style: AppTextStyles.h1.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.remoteUserName,
                      style: AppTextStyles.h3.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      callState.status == CallStatus.ringing
                          ? 'Ringing...'
                          : callState.status == CallStatus.connecting
                              ? 'Connecting...'
                              : 'Waiting...',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

            // Local video (PIP - top right)
            if (callState.isCameraOn && agora.engine != null)
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                right: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 140,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: agora.engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ),

            // Top bar (name + duration)
            if (_controlsVisible)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.remoteUserName,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (callState.status == CallStatus.active)
                        Text(
                          _formatDuration(callState.duration),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            // Bottom controls
            if (_controlsVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    top: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ControlButton(
                        icon: callState.isMuted
                            ? Icons.mic_off
                            : Icons.mic,
                        label: callState.isMuted ? 'Unmute' : 'Mute',
                        isActive: callState.isMuted,
                        onTap: () => ref.read(callNotifierProvider.notifier).toggleMute(),
                      ),
                      _ControlButton(
                        icon: callState.isCameraOn
                            ? Icons.videocam
                            : Icons.videocam_off,
                        label: callState.isCameraOn ? 'Camera Off' : 'Camera On',
                        isActive: !callState.isCameraOn,
                        onTap: () => ref.read(callNotifierProvider.notifier).toggleCamera(),
                      ),
                      _ControlButton(
                        icon: Icons.cameraswitch,
                        label: 'Flip',
                        onTap: () => ref.read(callNotifierProvider.notifier).switchCamera(),
                      ),
                      _ControlButton(
                        icon: Icons.call_end,
                        label: 'End',
                        isDestructive: true,
                        onTap: () => ref.read(callNotifierProvider.notifier).endCall(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDestructive
                  ? Colors.red
                  : isActive
                      ? Colors.white
                      : Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDestructive
                  ? Colors.white
                  : isActive
                      ? Colors.black
                      : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 3: Commit**

```bash
git add lib/features/sessions/widgets/video_call_screen.dart
git commit -m "feat: create full-screen video call UI with Agora"
```

---

### Task 16: Create Incoming Call Overlay

**Files:**
- Create: `lib/features/sessions/widgets/incoming_call_overlay.dart`

- [ ] **Step 1: Create the incoming call overlay widget**

Create `lib/features/sessions/widgets/incoming_call_overlay.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';

class IncomingCallOverlay extends StatelessWidget {
  const IncomingCallOverlay({
    super.key,
    required this.callerName,
    required this.onAccept,
    required this.onDecline,
  });

  final String callerName;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            CircleAvatar(
              radius: 56,
              backgroundColor: Colors.white24,
              child: Text(
                callerName.isNotEmpty ? callerName[0].toUpperCase() : '?',
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              callerName,
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Incoming Video Call',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white70,
              ),
            ),
            const Spacer(flex: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Decline
                GestureDetector(
                  onTap: onDecline,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Decline',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                // Accept
                GestureDetector(
                  onTap: onAccept,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.videocam,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Accept',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 3: Commit**

```bash
git add lib/features/sessions/widgets/incoming_call_overlay.dart
git commit -m "feat: create incoming call overlay UI"
```

---

### Task 17: Wire Video Call into Chat Screen and Listen for Incoming Calls

**Files:**
- Modify: `lib/features/messaging/screens/chat_screen.dart`
- Modify: `lib/main.dart` (or wherever the top-level widget is)

- [ ] **Step 1: Add video call button to chat screen app bar**

In `lib/features/messaging/screens/chat_screen.dart`, add a video call icon button in the AppBar actions:

```dart
import 'package:skill_exchange/features/sessions/providers/call_provider.dart';
import 'package:skill_exchange/features/sessions/widgets/video_call_screen.dart';
```

In the AppBar actions, add:

```dart
IconButton(
  icon: const Icon(Icons.videocam_outlined),
  tooltip: 'Video Call',
  onPressed: () async {
    final notifier = ref.read(callNotifierProvider.notifier);
    // Get the other user's ID and name from the conversation
    final otherUserId = /* extract from conversation data */;
    final otherUserName = /* extract from conversation data */;
    
    final success = await notifier.startCall(otherUserId, otherUserName);
    if (success && context.mounted) {
      final callState = ref.read(callNotifierProvider);
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => VideoCallScreen(
            channelId: callState.callId!,
            remoteUserName: otherUserName,
            isCaller: true,
          ),
        ),
      );
    }
  },
),
```

Note: The exact way to extract `otherUserId` and `otherUserName` depends on the ChatScreen's existing data model. Read the ChatScreen code to determine the correct field names.

- [ ] **Step 2: Add incoming call listener in main app**

In `lib/main.dart` (or the root widget), add a consumer that listens for incoming calls and shows the `IncomingCallOverlay`. This should be a global listener wrapped around the main app content.

Add a widget that listens to `incomingCallsProvider` and pushes the incoming call overlay when a call comes in:

```dart
import 'package:skill_exchange/features/sessions/providers/call_provider.dart';
import 'package:skill_exchange/features/sessions/widgets/incoming_call_overlay.dart';
import 'package:skill_exchange/features/sessions/widgets/video_call_screen.dart';
```

Use a `ref.listen` in the root widget's build or a separate listener widget to detect incoming calls and show the overlay.

- [ ] **Step 3: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 4: Commit**

```bash
git add lib/features/messaging/screens/chat_screen.dart lib/main.dart
git commit -m "feat: wire video call button in chat, add incoming call listener"
```

---

## Phase 4: Final Polish

### Task 18: Compact Community and Messaging Screens

**Files:**
- Modify: `lib/features/community/screens/community_screen.dart`
- Modify: `lib/features/messaging/screens/chat_screen.dart`
- Modify: `lib/features/messaging/screens/conversations_screen.dart`

- [ ] **Step 1: Compact community post cards**

In `lib/features/community/screens/community_screen.dart`, reduce any explicit padding values. The global token changes already handle most of it, but look for hardcoded padding values (e.g., `16`, `24`) and replace with `AppSpacing` tokens.

- [ ] **Step 2: Compact chat bubbles**

In `lib/features/messaging/screens/chat_screen.dart`, reduce message bubble padding from any `12` values to `8`, and reduce spacing between messages.

- [ ] **Step 3: Compact conversations list**

In `lib/features/messaging/screens/conversations_screen.dart`, ensure list items use 40px avatars and tight vertical padding.

- [ ] **Step 4: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 5: Commit**

```bash
git add lib/features/community/screens/community_screen.dart lib/features/messaging/screens/chat_screen.dart lib/features/messaging/screens/conversations_screen.dart
git commit -m "refactor: compact community posts, chat bubbles, and conversations"
```

---

### Task 19: Profile Screen Polish with Settings Access

**Files:**
- Modify: `lib/features/profile/screens/profile_screen.dart`

- [ ] **Step 1: Add settings icon to profile app bar**

In the profile screen's AppBar (when viewing own profile), add a settings gear icon:

```dart
actions: [
  if (isOwnProfile)
    IconButton(
      icon: const Icon(Icons.settings_outlined),
      tooltip: 'Settings',
      onPressed: () => context.push(RouteNames.settings),
    ),
],
```

This ensures settings is accessible from the profile tab since we removed it from the bottom nav.

- [ ] **Step 2: Verify build**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter build apk --debug 2>&1 | tail -5`

- [ ] **Step 3: Commit**

```bash
git add lib/features/profile/screens/profile_screen.dart
git commit -m "feat: add settings gear icon to profile screen app bar"
```

---

### Task 20: Final Build Verification

- [ ] **Step 1: Full clean build**

Run:
```bash
cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange
flutter clean && flutter pub get && flutter build apk --debug 2>&1 | tail -20
```

Expected: BUILD SUCCESSFUL

- [ ] **Step 2: Fix any compilation errors**

If there are errors, fix them one by one and commit each fix.

- [ ] **Step 3: Final commit**

```bash
git add -A
git commit -m "fix: resolve any remaining compilation issues after UI overhaul"
```
