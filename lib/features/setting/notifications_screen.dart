import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_app/common/bottom_nav_bar.dart';
import 'package:test_app/core/constants/color_manager.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('https://mockapi.io/api/notifications'),
      );
      if (!mounted) return; // ✅ تجنب استدعاء setState بعد التخلص من الواجهة

      if (response.statusCode == 200) {
        setState(() {
          notifications = List<Map<String, dynamic>>.from(
            json.decode(response.body),
          );
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      if (!mounted) {
        return; // ✅ منع استدعاء setState إذا تم التخلص من الـ Widget
      }
      setState(() {
        isLoading = false;
      });
      print('Error fetching notifications: $e');
    }
  }

  void _markAsRead(int index) {
    if (!mounted) return; // ✅ تأكد أن الواجهة لا تزال نشطة
    setState(() {
      notifications[index]["isRead"] = true;
    });
  }

  void _clearNotifications() {
    if (!mounted) return; // ✅ تأكد أن الواجهة لا تزال نشطة
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        elevation: 0,
        foregroundColor: ColorManager.primaryColor,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF076372)),
              )
              : notifications.isEmpty
              ? const Center(
                child: Text(
                  "No notifications available.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
              : RefreshIndicator(
                onRefresh: _fetchNotifications,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      color:
                          notification["isRead"]
                              ? Colors.white
                              : Colors.grey[200],
                      child: ListTile(
                        leading: Icon(
                          notification["isRead"]
                              ? Icons.notifications_none
                              : Icons.notifications_active,
                          color:
                              notification["isRead"]
                                  ? Colors.grey
                                  : const Color(0xFF076372),
                        ),
                        title: Text(
                          notification["title"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                notification["isRead"]
                                    ? Colors.black54
                                    : Colors.black,
                          ),
                        ),
                        subtitle: Text(notification["body"]),
                        trailing:
                            notification["isRead"]
                                ? null
                                : IconButton(
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF076372),
                                  ),
                                  onPressed: () => _markAsRead(index),
                                ),
                      ),
                    );
                  },
                ),
              ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
