import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/common/bottom_nav_bar.dart';

class SuggestScreen extends StatelessWidget {
  const SuggestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> ideas = {
      'Movies': [
        {
          'title': 'The Social Dilemma',
          'description':
              'A documentary about social media’s impact on mental health.',
        },
        {
          'title': 'Inside Out',
          'description': 'An animated film exploring human emotions.',
        },
        {
          'title': 'Her',
          'description': 'A futuristic take on human-AI relationships.',
        },
      ],
      'Books': [
        {
          'title': 'Digital Minimalism',
          'description': 'A book about living better with less technology.',
        },
        {
          'title': 'The Shallows',
          'description': 'Exploring how the internet affects our thinking.',
        },
        {
          'title': 'Indistractable',
          'description': 'A guide to controlling your attention and focus.',
        },
      ],
      'Articles': [
        {
          'title': 'How Social Media Affects Mental Health',
          'description':
              'A research article on social media’s psychological effects.',
        },
        {
          'title': 'The Power of Deep Work',
          'description': 'An article on focusing in a distracted world.',
        },
        {
          'title': 'The Science of Sleep and Screens',
          'description':
              'Exploring the relationship between screen time and sleep quality.',
        },
      ],
    };

    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Suggest',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.06, // Responsive text size
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              ideas.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: entry.value.length,
                        itemBuilder: (context, index) {
                          final idea = entry.value[index];
                          return SizedBox(
                            width: 220,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                  color: Colors.black26, // Darker border color
                                  width: 1.5, // Slightly thicker border
                                ),
                              ),
                              elevation:
                                  6, // Increased elevation for better shadow
                              shadowColor: Colors.black38, // Darker shadow
                              margin: const EdgeInsets.only(right: 12),
                              color:
                                  Colors
                                      .white, // Ensure card background is white
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.lightbulb,
                                    color: Colors.amber,
                                  ),
                                  title: Text(
                                    idea['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Colors
                                              .black87, // Darker text for contrast
                                    ),
                                  ),
                                  subtitle: Text(
                                    idea['description']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
