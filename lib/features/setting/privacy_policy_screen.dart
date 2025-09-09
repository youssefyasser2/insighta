import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF076372),
        title: Text("Privacy Policy", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Privacy Summary"),
            _sectionContent(
              "Welcome to our application, where we analyze social media behavior and its effects on individuals. "
              "Your privacy is extremely important to us, and we are committed to protecting your personal information. "
              "This policy outlines what data we collect, how we use it, and the steps we take to safeguard it.",
            ),
            SizedBox(height: 20),
            _sectionTitle("Information We Collect"),
            _sectionContent(
              "We collect behavioral data from social media interactions, including the time spent on platforms, types of content engaged with, "
              "and emotional responses to various digital stimuli. This helps us analyze the psychological and social effects of digital consumption.",
            ),
            SizedBox(height: 20),
            _sectionTitle("How We Use Your Data"),
            _sectionContent(
              "The collected data is used to generate personalized reports, suggest behavioral improvements, and provide psychological insights "
              "to enhance your digital well-being. We do not use your data for targeted advertisements or third-party marketing.",
            ),
            SizedBox(height: 20),
            _sectionTitle("Data Security and Protection"),
            _sectionContent(
              "We implement robust security measures to protect your personal data, including encryption and secure cloud storage. "
              "Your information is never shared with third parties without your explicit consent.",
            ),
            SizedBox(height: 20),
            _sectionTitle("Your Rights and Choices"),
            _sectionContent(
              "You have full control over your data. You can delete your account, request access to stored data, or modify your privacy settings at any time. "
              "Our app provides transparency and flexibility to ensure you are comfortable with how your data is handled.",
            ),
            SizedBox(height: 20),
            _sectionTitle("Third-Party Services"),
            _sectionContent(
              "Our application may integrate with third-party platforms for analytical and functional purposes. These services are carefully selected to ensure "
              "they comply with the highest standards of data protection. We do not sell or share your data with advertisers.",
            ),
            SizedBox(height: 20),
            _sectionTitle("Policy Updates"),
            _sectionContent(
              "We may update our privacy policy periodically to reflect changes in technology, regulations, or user preferences. "
              "Any significant changes will be communicated through app notifications and emails.",
            ),
            SizedBox(height: 20),
            _sectionTitle("Contact Us"),
            _sectionContent(
              "If you have any questions regarding our privacy policy, feel free to contact us at privacy@insighta.com. "
              "We are dedicated to ensuring your data is handled responsibly and transparently.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF076372),
      ),
    );
  }

  Widget _sectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(
        content,
        style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
      ),
    );
  }
}
