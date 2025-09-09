import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:test_app/core/constants/color_manager.dart';
import 'package:test_app/features/auth/logic/auth_cubit.dart';
import 'package:test_app/features/auth/logic/auth_state.dart';
import 'package:test_app/navigation/routes.dart';
import 'package:test_app/common/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> items = [
    {"title": "Suggest", "icon": LucideIcons.heart, "route": Routes.suggest},
    {
      "title": "Reboot",
      "icon": LucideIcons.messageSquare,
      "route": Routes.report,
    },
    {
      "title": "Usage",
      "icon": FontAwesomeIcons.chartBar,
      "route": Routes.usage,
    },
    {
      "title": "Linked Accounts",
      "icon": LucideIcons.users,
      "route": Routes.linkedAccounts,
    },
    {
      "title": "Therapy",
      "icon": LucideIcons.heartPulse,
      "route": Routes.therapy,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isTablet = screenWidth > 600; // Responsive threshold for tablets

    // Responsive childAspectRatio
    final childAspectRatio =
        isTablet
            ? screenWidth / (screenHeight * 0.25)
            : screenWidth / (screenHeight * 0.2);

    // Calculate grid item height
    final gridItemHeight =
        screenWidth / childAspectRatio / 2; // Divide by 2 for crossAxisCount

    // Responsive font/icon sizes
    final baseIconSize = isTablet ? 24.0 : 20.0;
    final baseFontSize = isTablet ? 16.0 : 14.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Discover",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 36 : 32,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: CircleAvatar(
                  backgroundImage: const AssetImage("assets/images/user.png"),
                  radius: isTablet ? 24 : 20,
                ),
                items: [
                  DropdownMenuItem(
                    value: "profile",
                    child: Text(
                      "Profile",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: baseFontSize,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "logout",
                    child: Text(
                      "Logout",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: baseFontSize,
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == "profile") {
                    context.go(Routes.profile);
                  } else if (value == "logout") {
                    context.read<AuthCubit>().logout();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLogoutSuccess) {
            context.go(Routes.login);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(
                        Icons.search,
                        color:
                            isDarkMode
                                ? theme.textTheme.bodySmall?.color
                                : theme.textTheme.bodyLarge?.color,
                        size: isTablet ? 28 : 24,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
              ),

              // Grid for other items (without Therapy)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable grid scrolling
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemCount: 4, // Exclude Therapy
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {
                          final route = items[index]["route"];
                          if (route != null && Routes.isValid(route)) {
                            context.go(route);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Route "${items[index]["title"]}" is not available',
                                ),
                                backgroundColor: Colors.orange,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(isTablet ? 11 : 7),
                          elevation: 2,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              items[index]["icon"],
                              color: Colors.white,
                              size: baseIconSize,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              items[index]["title"],
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: baseFontSize,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Therapy item (full width, same height as grid items)
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 84, // Match grid item height
                  child: ElevatedButton(
                    onPressed: () {
                      final route = items[4]["route"];
                      if (route != null && Routes.isValid(route)) {
                        context.go(route);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Route "${items[4]["title"]}" is not available',
                            ),
                            backgroundColor: Colors.orange,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(isTablet ? 11 : 7),
                      elevation: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[4]["icon"],
                          color: Colors.white,
                          size: 24, // Match grid items
                        ),
                        const SizedBox(width: 12),
                        Text(
                          items[4]["title"],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18, // Match grid items
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Last Week Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last Week",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: isTablet ? 24 : 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: isTablet ? 320 : 260,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/chart_last_week.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
