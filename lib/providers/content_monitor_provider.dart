import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class ContentMonitorProvider with ChangeNotifier {
  bool _isMonitoring = false;
  Map<String, dynamic>? _lastAnalysis;
  String? _error;

  bool get isMonitoring => _isMonitoring;
  Map<String, dynamic>? get lastAnalysis => _lastAnalysis;
  String? get error => _error;

  /// Analyze content using the backend API
  Future<Map<String, dynamic>?> analyzeContent({
    required String childId,
    required String content,
    String? url,
  }) async {
    try {
      _isMonitoring = true;
      _error = null;
      notifyListeners();

      final result = await ApiService.analyzeContent(
        childId: childId,
        content: content,
        url: url,
      );

      _lastAnalysis = result;
      _isMonitoring = false;
      notifyListeners();

      return result;
    } catch (e) {
      _error = e.toString();
      _isMonitoring = false;
      notifyListeners();
      return null;
    }
  }

  /// Test backend connection
  Future<bool> testBackendConnection() async {
    try {
      return await ApiService.testConnection();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear last analysis
  void clearAnalysis() {
    _lastAnalysis = null;
    _error = null;
    notifyListeners();
  }
}
