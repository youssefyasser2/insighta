import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/core/constants/color_manager.dart';
import '../../domain/entities/linked_account.dart';

class AccountReportPage extends StatelessWidget {
  final LinkedAccount account;

  const AccountReportPage({super.key, required this.account});

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
          'Account Report',
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

            // Report sections
            _buildReportSection('Account Activity', [
              _buildReportItem('Total Posts', '1,245', Icons.post_add),
              _buildReportItem('Followers', '12.5K', Icons.people),
              _buildReportItem('Following', '892', Icons.person_add),
              _buildReportItem('Likes Received', '45.2K', Icons.favorite),
            ]),

            const SizedBox(height: 16),

            _buildReportSection('Engagement Metrics', [
              _buildReportItem('Average Likes', '36', Icons.thumb_up),
              _buildReportItem('Comments', '8.2K', Icons.comment),
              _buildReportItem('Shares', '2.1K', Icons.share),
              _buildReportItem('Engagement Rate', '4.2%', Icons.trending_up),
            ]),

            const SizedBox(height: 16),

            _buildReportSection('Account Health', [
              _buildReportItem(
                'Account Status',
                'Active',
                Icons.check_circle,
                Colors.green,
              ),
              _buildReportItem('Last Login', '2 hours ago', Icons.login),
              _buildReportItem(
                'Security Score',
                '95%',
                Icons.security,
                Colors.green,
              ),
              _buildReportItem(
                'Verification',
                'Verified',
                Icons.verified,
                ColorManager.primaryColor,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildReportSection(String title, List<Widget> items) {
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

  Widget _buildReportItem(
    String label,
    String value,
    IconData icon, [
    Color? valueColor,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
