import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/constants/color_manager.dart';
import 'package:test_app/core/theme_provider.dart';
import 'package:test_app/common/bottom_nav_bar.dart';
import '../../core/services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<StorageService>? _storageServiceFuture;

  @override
  void initState() {
    super.initState();
    _storageServiceFuture = _initializeStorageService();
  }

  Future<StorageService> _initializeStorageService() async {
    final prefs = await SharedPreferences.getInstance();
    final secureStorage = const FlutterSecureStorage();
    return StorageService(prefs: prefs, secureStorage: secureStorage);
  }

  Future<void> _logout(
    BuildContext context,
    StorageService storageService,
  ) async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Confirm Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Log Out"),
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      await storageService.clearUserId();
      if (mounted) {
        context.replace('/login');
      }
    }
  }

  void _goToPage(BuildContext context, String route) {
    context.push(route);
  }

  Widget buildSettingsItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isRed = false,
    bool isSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 2, // Softer shadow
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ), // Slightly increased margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Softer corners
        side: BorderSide(
          color:
              isDarkMode
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8, // Slightly increased for better spacing
            horizontal: 20,
          ),
          leading: Icon(
            icon,
            color: isRed ? Colors.red : const Color(0xFF076372),
            size: 24,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15, // Slightly increased font size
              color:
                  isRed
                      ? Colors.red
                      : isDarkMode
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          trailing:
              isSwitch
                  ? AnimatedScale(
                    scale:
                        switchValue ? 1.0 : 0.9, // Subtle animation for switch
                    duration: const Duration(milliseconds: 200),
                    child: Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: switchValue,
                        onChanged: onSwitchChanged,
                        activeColor: const Color(0xFF076372),
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  )
                  : const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
          onTap: isSwitch ? null : onTap,
          splashColor: const Color(0xFF076372).withOpacity(0.1),
        ),
      ),
    );
  }

  Widget sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8), // Adjusted padding
      child: Row(
        children: [
          Icon(
            icon,
            size: 25, // Slightly larger icon
            color: const Color.fromARGB(255, 142, 138, 138),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 142, 138, 138),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    const primaryColor = Color(0xFF076372);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text(
          'settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        elevation: 0,
        foregroundColor: ColorManager.primaryColor,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      body: FutureBuilder<StorageService>(
        future: _storageServiceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error loading settings: ${snapshot.error}"),
            );
          }

          final storageService = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ), // Adjusted padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("General", Icons.settings),
                buildSettingsItem(
                  icon: Icons.person,
                  title: 'Account',
                  onTap: () => _goToPage(context, '/profile'),
                ),
                buildSettingsItem(
                  icon: Icons.notifications,
                  title: 'Notification',
                  onTap: () => _goToPage(context, '/notifications'),
                ),
                buildSettingsItem(
                  icon: Icons.brightness_6,
                  title: 'Dark Mode',
                  isSwitch: true,
                  switchValue: isDarkMode,
                  onSwitchChanged: (val) => themeProvider.toggleTheme(),
                ),
                buildSettingsItem(
                  icon: Icons.logout,
                  title: 'Log out',
                  isRed: true,
                  onTap: () => _logout(context, storageService),
                ),
                buildSettingsItem(
                  icon: Icons.delete,
                  title: 'Delete Account',
                  isRed: true,
                  onTap: () => _goToPage(context, '/delete-account'),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
