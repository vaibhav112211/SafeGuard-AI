import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/child_ui_provider.dart';
import '../../models/blocked_content_model.dart';
import 'warning_screen.dart';
import 'block_screen.dart';

class SafeBrowserScreen extends StatefulWidget {
  final String childId;

  const SafeBrowserScreen({Key? key, required this.childId}) : super(key: key);

  @override
  State<SafeBrowserScreen> createState() => _SafeBrowserScreenState();
}

class _SafeBrowserScreenState extends State<SafeBrowserScreen> {
  final TextEditingController _urlController = TextEditingController();

  String _currentUrl = '';
  bool _isLoading = false;

  final List<String> _blockedKeywords = [
    'adult',
    'violence',
    'gambling',
    'casino',
    'weapon',
    'drug',
  ];

  final List<String> _warningKeywords = [
    'game',
    'social',
    'chat',
    'forum',
  ];

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _loadUrl(String url) async {
    if (url.isEmpty) return;

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    setState(() {
      _isLoading = true;
      _currentUrl = url;
    });

    await Future.delayed(const Duration(seconds: 1));

    final lowerUrl = url.toLowerCase();
    bool isBlocked = false;
    bool needsWarning = false;
    String category = '';

    for (final k in _blockedKeywords) {
      if (lowerUrl.contains(k)) {
        isBlocked = true;
        category = k;
        break;
      }
    }

    if (!isBlocked) {
      for (final k in _warningKeywords) {
        if (lowerUrl.contains(k)) {
          needsWarning = true;
          category = k;
          break;
        }
      }
    }

    setState(() => _isLoading = false);

    final childProvider =
    Provider.of<ChildUIProvider>(context, listen: false);

    // 🚫 BLOCK
    if (isBlocked) {
      childProvider.addBlockedContent(
        BlockedContentModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          url: url,
          title: 'Blocked Website',
          category: category,
          blockedAt: DateTime.now(),
          childId: widget.childId,
          reason: 'Contains inappropriate content: $category',
          severity: 5,
        ),
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlockScreen(
            url: url,
            category: category,
          ),
        ),
      );
      return;
    }

    // ⚠️ WARNING
    if (needsWarning) {
      if (!mounted) return;
      final proceed = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => WarningScreen(
            url: url,
            category: category,
          ),
        ),
      );

      if (proceed != true) {
        setState(() {
          _currentUrl = '';
          _urlController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final childProvider = Provider.of<ChildUIProvider>(context);
    final child = childProvider.getChildById(widget.childId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Browser'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_currentUrl.isNotEmpty) {
                _loadUrl(_currentUrl);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // URL BAR
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'Enter website URL',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _loadUrl,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        color: Colors.white),
                    onPressed: () =>
                        _loadUrl(_urlController.text.trim()),
                  ),
                ),
              ],
            ),
          ),

          // CONTENT
          Expanded(
            child: _isLoading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Checking website safety...'),
                ],
              ),
            )
                : _currentUrl.isEmpty
                ? _buildStartScreen()
                : _buildWebContent(),
          ),

          // INFO BAR
          if (child != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Protected browsing • Time left: '
                          '${child.screenTimeMinutes - child.todayScreenTime} min',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // START SCREEN
  Widget _buildStartScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Safe Browsing Active',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Enter a website URL above to browse safely',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestedSite('Google', 'google.com', Icons.search),
                _buildSuggestedSite(
                    'Wikipedia', 'wikipedia.org', Icons.book),
                _buildSuggestedSite(
                    'Khan Academy', 'khanacademy.org', Icons.school),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedSite(
      String name, String url, IconData icon) {
    return InkWell(
      onTap: () {
        _urlController.text = url;
        _loadUrl(url);
      },
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.green),
            const SizedBox(width: 8),
            Text(name,
                style:
                const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildWebContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle,
                size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Website Approved',
              style:
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              _currentUrl,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              'This website is safe.\n(Web content would load here)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
