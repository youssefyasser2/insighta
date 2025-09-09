import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_app/features/profile/logic/bloc/profile_bloc.dart';
import 'package:test_app/common/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userId;
  late StorageService storageService;

  @override
  void initState() {
    super.initState();
    _initializeStorageService();
  }

  Future<void> _initializeStorageService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final secureStorage = FlutterSecureStorage();
      storageService = StorageService(
        prefs: prefs,
        secureStorage: secureStorage,
      );
      await _loadUserId();
    } catch (e) {
      debugPrint("⚠️ Error initializing storage: $e");
    }
  }

  Future<void> _loadUserId() async {
    try {
      String? id = await storageService.getUserId();
      setState(() {
        userId = id ?? "Unavailable";
      });
    } catch (e) {
      debugPrint("⚠️ Error loading user ID: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(FetchProfileData(userId ?? '')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.teal.shade800,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return _buildErrorUI(
                "Oops! We couldn't load your profile. Please try again later.",
              );
            } else if (state is ProfileLoaded) {
              return _buildProfileUI(state.profileData);
            } else {
              return _buildErrorUI(
                "Something went wrong! Please restart the app.",
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }

  Widget _buildErrorUI(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildProfileUI(dynamic profileData) {
    if (profileData is List && profileData.isNotEmpty) {
      profileData =
          profileData[0]; // Ensure we get the first item if it's a list
    }
    if (profileData is! Map<String, dynamic>) {
      return _buildErrorUI(
        "Oops! The data format is incorrect. Please try again later.",
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                profileData['avatar'] != null &&
                        profileData['avatar'].isNotEmpty
                    ? NetworkImage(profileData['avatar'])
                    : const AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
          ),
          const SizedBox(height: 10),
          Text(
            profileData['name'] ?? 'Unknown',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}

class StorageService {
  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;

  StorageService({required this.prefs, required this.secureStorage});

  Future<String?> getUserId() async {
    try {
      return await secureStorage.read(key: 'userId');
    } catch (e) {
      debugPrint("⚠️ Error retrieving user ID: $e");
      return null;
    }
  }
}
