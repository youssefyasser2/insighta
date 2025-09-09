import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/core/constants/color_manager.dart';
import 'package:test_app/features/linkedaccount/presentation/widgets/account_detail_sheet.dart';
import 'package:test_app/features/linkedaccount/presentation/widgets/account_list_item.dart';
import 'package:test_app/features/linkedaccount/presentation/widgets/add_account_sheet.dart';

import '../../domain/entities/linked_account.dart';

class LinkedAccountsPage extends StatefulWidget {
  const LinkedAccountsPage({super.key});

  @override
  State<LinkedAccountsPage> createState() => _LinkedAccountsPageState();
}

class _LinkedAccountsPageState extends State<LinkedAccountsPage> {
  // Mock data - replace with your actual data source
  List<LinkedAccount> accounts = [
    const LinkedAccount(
      id: '1',
      name: 'John Doe',
      username: '@johndoe',
      avatarImage: 'assets/images/img.png',
    ),
    const LinkedAccount(
      id: '2',
      name: 'Sarah Smith',
      username: '@sarahsmith',
      avatarImage: 'assets/images/img2.png',
    ),
    const LinkedAccount(
      id: '3',
      name: 'Mike Johnson',
      username: '@mikej',
      avatarImage: 'assets/images/img3.png',
    ),
  ];

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
          'Linked Accounts',
          style: TextStyle(
            fontSize: screenWidth * 0.06, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop(); // Navigate back if possible
            } else {
              context.go('/home'); // Fallback to home route
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddAccount(context),
            icon: const Icon(
              Icons.add,
              color: ColorManager.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: accounts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return AccountListItem(
            account: accounts[index],
            onTap: () => _showAccountDetails(context, accounts[index]),
          );
        },
      ),
    );
  }

  void _showAccountDetails(BuildContext context, LinkedAccount account) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AccountDetailSheet(
            account: account,
            onReportTap: () => _navigateToReport(account),
            onUsageTap: () => _navigateToUsage(account),
          ),
    );
  }

  void _showAddAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AddAccountSheet(
            onAccountAdded: (newAccount) {
              setState(() {
                accounts.add(newAccount);
              });
            },
          ),
    );
  }

  void _navigateToReport(LinkedAccount account) {
    Navigator.pop(context);
    context.push('/accounts/report', extra: account);
  }

  void _navigateToUsage(LinkedAccount account) {
    Navigator.pop(context);
    context.push('/accounts/usage', extra: account);
  }
}
