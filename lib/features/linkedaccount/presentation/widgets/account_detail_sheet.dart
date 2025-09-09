import 'package:flutter/material.dart';
import '../../domain/entities/linked_account.dart';

class AccountDetailSheet extends StatelessWidget {
  final LinkedAccount account;
  final VoidCallback? onReportTap;
  final VoidCallback? onUsageTap;

  const AccountDetailSheet({
    super.key,
    required this.account,
    this.onReportTap,
    this.onUsageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // User info
          _buildUserInfo(),

          const SizedBox(height: 32),

          // Action items
          Expanded(
            child: Column(
              children: [
                _buildActionItem(
                  icon: Icons.trending_up_outlined,
                  title: 'Report',
                  onTap: onReportTap ?? () => Navigator.pop(context),
                ),
                const SizedBox(height: 8),
                _buildActionItem(
                  icon: Icons.access_time_outlined,
                  title: 'Usage',
                  onTap: onUsageTap ?? () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                  : null,
        ),
        const SizedBox(height: 12),
        Text(
          account.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          account.username,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: Colors.grey[600], size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
      ),
    );
  }
}
