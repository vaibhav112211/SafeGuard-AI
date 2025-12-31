import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_ui_provider.dart';
import '../../providers/child_ui_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/custom_button.dart';
import 'safe_browser_screen.dart';
import '../auth/login_screen.dart';

class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize mock data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final childProvider =
      Provider.of<ChildUIProvider>(context, listen: false);
      if (childProvider.children.isEmpty) {
        childProvider.initializeMockData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUIProvider>(context);
    final childProvider = Provider.of<ChildUIProvider>(context);

    // For demo, use first child
    final currentChild = childProvider.children.isNotEmpty
        ? childProvider.children.first
        : null;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green[300]!,
              Colors.blue[400]!,
            ],
          ),
        ),
        child: SafeArea(
          child: currentChild == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, ${currentChild.name}! ${currentChild.avatarUrl}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Stay safe online',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text(
                                'Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && mounted) {
                          await authProvider.logout();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Screen Time Card
                GlassCard(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              color: Colors.orange,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Screen Time Today',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${currentChild.todayScreenTime} / ${currentChild.screenTimeMinutes} minutes',
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
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: currentChild.todayScreenTime /
                            currentChild.screenTimeMinutes,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                            Colors.orange),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Safe Browser Button
                CustomButton(
                  text: 'Open Safe Browser',
                  icon: Icons.public,
                  onPressed: () {
                    if (childProvider.isScreenTimeExceeded(
                        currentChild.id)) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Screen Time Limit'),
                          content: const Text(
                              'You have reached your daily screen time limit. Please ask your parent for more time.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SafeBrowserScreen(
                            childId: currentChild.id,
                          ),
                        ),
                      );
                    }
                  },
                  backgroundColor: Colors.white,
                  textColor: Colors.blue,
                ),
                const SizedBox(height: 24),

                // Safety Information Cards
                const Text(
                  'Safety Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                _buildSafetyTipCard(
                  icon: Icons.shield,
                  title: 'Protected Browsing',
                  description:
                  'All websites are checked for safety before you can visit them.',
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),

                _buildSafetyTipCard(
                  icon: Icons.block,
                  title: 'Content Filtering',
                  description:
                  'Inappropriate content is automatically blocked.',
                  color: Colors.red,
                ),
                const SizedBox(height: 12),

                _buildSafetyTipCard(
                  icon: Icons.family_restroom,
                  title: 'Parent Monitoring',
                  description:
                  'Your parent can see your browsing activity to keep you safe.',
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return GlassCard(
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
    );
  }
}