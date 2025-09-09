import 'package:equatable/equatable.dart';

/// Represents a user in the app with all relevant details.
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? fullName;
  final String? profileImage;
  final String? bio;
  final String? location;
  final bool? isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresIn;

  /// Creates a new [UserModel] instance.
  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.fullName,
    this.profileImage,
    this.bio,
    this.location,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  /// Checks if the user has completed their profile by verifying required fields.
  bool get hasCompletedProfile {
    return fullName != null &&
        fullName!.trim().isNotEmpty &&
        bio != null &&
        bio!.trim().isNotEmpty &&
        profileImage != null &&
        profileImage!.trim().isNotEmpty;
  }

  /// Checks if the access token is valid (non-empty and not expired).
  bool get hasValidToken {
    return accessToken != null &&
        accessToken!.isNotEmpty &&
        (expiresIn == null || expiresIn!.isAfter(DateTime.now()));
  }

  /// Parses a JSON map into a [UserModel] instance.
  /// Throws an exception if required fields like email are missing.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? 'unknown-id',
      email:
          json['email']?.toString() ??
          (throw Exception('Email is required but missing in API response')),
      name: json['name']?.toString(),
      fullName: json['fullName']?.toString(),
      profileImage:
          json['profileImage']?.toString() ?? json['avatar']?.toString(),
      bio: json['bio']?.toString(),
      location: json['location']?.toString(),
      isVerified:
          json['isVerified'] != null ? json['isVerified'] as bool : null,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'].toString())
              : null,
      accessToken: json['accessToken']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
      expiresIn:
          json['expiresIn'] != null
              ? DateTime.tryParse(json['expiresIn'].toString())
              : null,
    );
  }

  /// Parses a login response JSON into a minimal [UserModel] instance.
  factory UserModel.fromLoginResponse(Map<String, dynamic> response) {
    // Since login doesn't return a user object, we'll create a minimal UserModel
    return UserModel(
      id: 'temp-id', // Will be updated later (e.g., via /me)
      email: '', // Email isn't returned, will be updated later
      accessToken: response['accessToken']?.toString(),
    );
  }

  /// Parses a register response JSON into a [UserModel] instance.
  factory UserModel.fromRegisterResponse(Map<String, dynamic> response) {
    final user = response['user'] as Map<String, dynamic>? ?? response;
    return UserModel.fromJson(user);
  }

  /// Converts the [UserModel] instance to a JSON map.
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    if (name != null) 'name': name,
    if (fullName != null) 'fullName': fullName,
    if (profileImage != null) 'profileImage': profileImage,
    if (bio != null) 'bio': bio,
    if (location != null) 'location': location,
    if (isVerified != null) 'isVerified': isVerified,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    if (accessToken != null) 'accessToken': accessToken,
    if (refreshToken != null) 'refreshToken': refreshToken,
    if (expiresIn != null) 'expiresIn': expiresIn!.toIso8601String(),
  };

  /// Creates a copy of the [UserModel] with updated fields.
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? fullName,
    String? profileImage,
    String? bio,
    String? location,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresIn,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accessToken:
          accessToken?.isNotEmpty ?? false ? accessToken : this.accessToken,
      refreshToken:
          refreshToken?.isNotEmpty ?? false ? refreshToken : this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    fullName,
    profileImage,
    bio,
    location,
    isVerified,
    createdAt,
    updatedAt,
    accessToken,
    refreshToken,
    expiresIn,
  ];

  @override
  String toString() {
    return 'UserModel('
        'id: $id, '
        'email: $email, '
        'name: $name, '
        'fullName: $fullName, '
        'bio: $bio, '
        'location: $location, '
        'isVerified: $isVerified, '
        'createdAt: ${createdAt?.toIso8601String() ?? 'N/A'}, '
        'accessToken: ${accessToken?.isNotEmpty ?? false ? '✅' : '❌'})';
  }
}
