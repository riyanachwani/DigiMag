import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(fontFamily: 'RosebayRegular', fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    const Color(0xFF3A3A3A),
                    const Color.fromARGB(255, 105, 104, 104)
                  ]
                : [
                    const Color(0xFFB69DF8),
                    const Color.fromARGB(255, 255, 255, 255)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            color: isDarkMode
                ? const Color.fromARGB(255, 46, 46, 46)
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage(
                          'assets/images/applogo.png'), // 🖼 Your logo or any image
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Center(
                    child: Text(
                      'DigiMag',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: 'RosebayRegular',
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Your Daily Dose of Information',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[800],
                      ),
                    ),
                  ),
                  const Divider(height: 30, thickness: 1.5),
                  _buildSection(
                    icon: Icons.flag,
                    title: 'Our Mission',
                    description:
                        'At DigiMag, our mission is to deliver accurate, engaging, and timely information to our readers. We aim to empower people with knowledge and insights that make a difference in their everyday lives.',
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    icon: Icons.visibility,
                    title: 'Our Vision',
                    description:
                        'To become a trusted and leading source of news and information, connecting readers globally and fostering an informed community.',
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    icon: Icons.star,
                    title: 'Our Core Values',
                    description:
                        '1. Accuracy\n2. Integrity\n3. Transparency\n4. Innovation\n5. Reader Focus',
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xFF7B42F6),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/contact');
                      },
                      child: const Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// **Reusable Section Widget with Icon and Text**
  Widget _buildSection({
    required IconData icon,
    required String title,
    required String description,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF7B42F6)),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF7B42F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: isDarkMode ? Colors.grey[300] : Colors.black87,
          ),
        ),
      ],
    );
  }
}
