import 'package:equatable/equatable.dart';

/// Represents a user in the app with all relevant details.
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? firstName; // Added: User's first name
  final String? lastName; // Added: User's last name
  final String? fullName;
  final String? avatar; // Added: User's avatar (replaces profileImage in API)
  final String? profileImage; // Kept for backward compatibility
  final String? bio;
  final String? location;
  final String? gender;
  final int? age;
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
    this.firstName, // Added
    this.lastName, // Added
    this.fullName,
    this.avatar, // Added
    this.profileImage,
    this.bio,
    this.location,
    this.gender,
    this.age,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  /// Checks if the user has completed their profile by verifying required fields.
  bool get hasCompletedProfile {
    return gender != null &&
        gender!.trim().isNotEmpty &&
        age != null &&
        age! > 0 &&
        firstName != null && // Added: Require firstName
        firstName!.trim().isNotEmpty &&
        lastName != null && // Added: Require lastName
        lastName!.trim().isNotEmpty;
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
      firstName: json['firstName']?.toString(), // Added: Parse firstName
      lastName: json['lastName']?.toString(), // Added: Parse lastName
      fullName: json['fullName']?.toString(),
      avatar: json['avatar']?.toString(), // Added: Parse avatar (API uses this)
      profileImage:
          json['profileImage']?.toString() ?? json['avatar']?.toString(),
      bio: json['bio']?.toString(),
      location: json['location']?.toString(),
      gender: json['gender']?.toString(),
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
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
    if (firstName != null) 'firstName': firstName, // Added
    if (lastName != null) 'lastName': lastName, // Added
    if (fullName != null) 'fullName': fullName,
    if (avatar != null) 'avatar': avatar, // Added: Include avatar
    if (profileImage != null) 'profileImage': profileImage,
    if (bio != null) 'bio': bio,
    if (location != null) 'location': location,
    if (gender != null) 'gender': gender,
    if (age != null) 'age': age,
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
    String? firstName, // Added
    String? lastName, // Added
    String? fullName,
    String? avatar, // Added
    String? profileImage,
    String? bio,
    String? location,
    String? gender,
    int? age,
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
      firstName: firstName ?? this.firstName, // Added
      lastName: lastName ?? this.lastName, // Added
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar, // Added
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      age: age ?? this.age,
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
    firstName, // Added
    lastName, // Added
    fullName,
    avatar, // Added
    profileImage,
    bio,
    location,
    gender,
    age,
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
        'firstName: $firstName, ' // Added
        'lastName: $lastName, ' // Added
        'fullName: $fullName, '
        'avatar: $avatar, ' // Added
        'profileImage: $profileImage, '
        'bio: $bio, '
        'location: $location, '
        'gender: $gender, '
        'age: $age, '
        'isVerified: $isVerified, '
        'createdAt: ${createdAt?.toIso8601String() ?? 'N/A'}, '
        'accessToken: ${accessToken?.isNotEmpty ?? false ? '✅' : '❌'})';
  }
}
