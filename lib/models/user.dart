import 'enums.dart';

class AppUserProfile {
  const AppUserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    required this.role,
    this.active = true,
    this.preferences = const {},
    this.communicationProfile,
  });

  final String id;
  final String displayName;
  final String email;
  final AppRole role;
  final bool active;
  final Map<String, dynamic> preferences;
  final CommunicationProfile? communicationProfile;

  factory AppUserProfile.fromMap(String id, Map<String, dynamic> data) {
    return AppUserProfile(
      id: id,
      displayName: data['displayName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] == 'admin' ? AppRole.admin : AppRole.individual,
      active: data['active'] as bool? ?? true,
      preferences: data['preferences'] as Map<String, dynamic>? ?? const {},
      communicationProfile: CommunicationProfile.fromName(
        data['communicationProfile'],
      ),
    );
  }
}
