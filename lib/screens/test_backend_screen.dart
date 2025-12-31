import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_monitor_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';

class TestBackendScreen extends StatefulWidget {
  const TestBackendScreen({Key? key}) : super(key: key);

  @override
  State<TestBackendScreen> createState() => _TestBackendScreenState();
}

class _TestBackendScreenState extends State<TestBackendScreen> {
  final _contentController = TextEditingController();
  final _urlController = TextEditingController();
  final _childIdController = TextEditingController(text: "child123");

  @override
  void dispose() {
    _contentController.dispose();
    _urlController.dispose();
    _childIdController.dispose();
    super.dispose();
  }

  Future<void> _analyzeContent() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter content to analyze')),
      );
      return;
    }

    final provider = Provider.of<ContentMonitorProvider>(context, listen: false);
    
    final result = await provider.analyzeContent(
      childId: _childIdController.text,
      content: _contentController.text,
      url: _urlController.text.isEmpty ? null : _urlController.text,
    );

    if (result != null && mounted) {
      _showResultDialog(result);
    }
  }

  void _showResultDialog(Map<String, dynamic> result) {
    final decision = result['decision'] ?? 'unknown';
    final severity = result['severity'] ?? 'unknown';
    final score = result['score'] ?? 0.0;

    Color color = Colors.green;
    IconData icon = Icons.check_circle;
    
    if (decision == 'block') {
      color = Colors.red;
      icon = Icons.block;
    } else if (decision == 'warn') {
      color = Colors.orange;
      icon = Icons.warning;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 10),
            Text('Analysis Result', style: TextStyle(color: color)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow('Decision', decision.toUpperCase(), color),
            _buildResultRow('Severity', severity.toUpperCase(), color),
            _buildResultRow('Score', score.toStringAsFixed(2), color),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Backend API'),
        elevation: 0,
      ),
      body: Consumer<ContentMonitorProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Test Content Analysis',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                
                CustomInput(
                  controller: _childIdController,
                  label: 'Child ID',
                  hint: 'e.g., child123',
                ),
                const SizedBox(height: 15),
                
                CustomInput(
                  controller: _urlController,
                  label: 'URL (optional)',
                  hint: 'e.g., example.com',
                ),
                const SizedBox(height: 15),
                
                TextField(
                  controller: _contentController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Content to Analyze',
                    hintText: 'Enter text content here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                
                if (provider.isMonitoring)
                  const Center(child: CircularProgressIndicator())
                else
                  CustomButton(
                    text: 'Analyze Content',
                    onPressed: _analyzeContent,
                  ),
                
                if (provider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Error: ${provider.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),
                
                const Text(
                  'Test Examples:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                
                _buildExampleButton(
                  'Safe Content',
                  'Hello, how are you? I love learning new things!',
                ),
                _buildExampleButton(
                  'Warning Content',
                  'I hate this stupid assignment',
                ),
                _buildExampleButton(
                  'Blocked Content',
                  'Check out this xxx adult content',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExampleButton(String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: () {
          _contentController.text = content;
        },
        child: Text(label),
      ),
    );
  }
}
