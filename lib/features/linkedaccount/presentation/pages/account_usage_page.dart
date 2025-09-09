import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/core/constants/color_manager.dart';
import '../../domain/entities/linked_account.dart';

class AccountUsagePage extends StatelessWidget {
  final LinkedAccount account;

  const AccountUsagePage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        foregroundColor: Colors.black,
        title: Text(
          'Usage Statistics',
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/linked-accounts');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        account.avatarImage != null
                            ? AssetImage(account.avatarImage!)
                            : null,
                    child:
                        account.avatarImage == null
                            ? Text(
                              account.name
                                  .split(' ')
                                  .map((e) => e[0])
                                  .join()
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            )
                            : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          account.username,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Usage sections
            _buildUsageSection('Daily Activity', [
              _buildUsageItem(
                'Screen Time',
                '3h 24m',
                Icons.access_time,
                ColorManager.primaryColor,
              ),
              _buildUsageItem('Posts Created', '5', Icons.create),
              _buildUsageItem('Messages Sent', '23', Icons.message),
              _buildUsageItem('Stories Viewed', '12', Icons.visibility),
            ]),

            const SizedBox(height: 16),

            _buildUsageSection('Weekly Summary', [
              _buildUsageItem(
                'Total Screen Time',
                '18h 45m',
                Icons.schedule,
                Colors.orange,
              ),
              _buildUsageItem(
                'Most Active Day',
                'Wednesday',
                Icons.calendar_today,
              ),
              _buildUsageItem('Average Daily Posts', '3.2', Icons.trending_up),
              _buildUsageItem(
                'Peak Usage Time',
                '8:00 PM',
                Icons.access_time_filled,
              ),
            ]),

            const SizedBox(height: 16),

            _buildUsageSection('App Features', [
              _buildUsageItem('Feed Browsing', '65%', Icons.feed, Colors.green),
              _buildUsageItem('Direct Messages', '20%', Icons.chat),
              _buildUsageItem('Story Creation', '10%', Icons.add_a_photo),
              _buildUsageItem('Settings', '5%', Icons.settings),
            ]),

            const SizedBox(height: 16),

            _buildUsageSection('Data Usage', [
              _buildUsageItem(
                'Photos Uploaded',
                '156 MB',
                Icons.photo_library,
                Colors.purple,
              ),
              _buildUsageItem('Videos Uploaded', '2.3 GB', Icons.video_library),
              _buildUsageItem('Total Data', '2.5 GB', Icons.data_usage),
              _buildUsageItem('Storage Used', '1.8 GB', Icons.storage),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageSection(String title, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildUsageItem(
    String label,
    String value,
    IconData icon, [
    Color? iconColor,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor ?? Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
