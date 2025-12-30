import 'package:flutter/foundation.dart';
import '../models/report_ui_model.dart';
import '../models/child_ui_model.dart';
import '../models/blocked_content_model.dart';

class ParentUIProvider extends ChangeNotifier {
  List<ReportUIModel> _reports = [];
  Map<String, List<String>> _childActivities = {};

  List<ReportUIModel> get reports => _reports;

  // Initialize mock reports
  void initializeMockReports(List<ChildUIModel> children) {
    _reports.clear();

    for (var child in children) {
      final mockBlockedContent = [
        BlockedContentModel(
          id: '${child.id}_1',
          url: 'https://inappropriate-site.com',
          title: 'Blocked Adult Content',
          category: 'adult',
          blockedAt: DateTime.now().subtract(const Duration(hours: 5)),
          childId: child.id,
          severity: 5,
        ),
        BlockedContentModel(
          id: '${child.id}_2',
          url: 'https://violence-game.com',
          title: 'Violent Game',
          category: 'violence',
          blockedAt: DateTime.now().subtract(const Duration(hours: 3)),
          childId: child.id,
          severity: 4,
        ),
        BlockedContentModel(
          id: '${child.id}_3',
          url: 'https://gambling-site.com',
          title: 'Online Casino',
          category: 'gambling',
          blockedAt: DateTime.now().subtract(const Duration(hours: 1)),
          childId: child.id,
          severity: 3,
        ),
      ];

      _reports.add(ReportUIModel(
        childId: child.id,
        childName: child.name,
        reportDate: DateTime.now(),
        totalBlockedAttempts: mockBlockedContent.length,
        screenTimeMinutes: child.todayScreenTime,
        blockedContent: mockBlockedContent,
        categoryBreakdown: {
          'adult': 1,
          'violence': 1,
          'gambling': 1,
        },
        mostVisitedSites: [
          'youtube.com',
          'google.com',
          'minecraft.net',
        ],
        warningsGiven: 2,
      ));
    }

    notifyListeners();
  }

  // Get report for specific child
  ReportUIModel? getReportForChild(String childId) {
    try {
      return _reports.firstWhere((report) => report.childId == childId);
    } catch (e) {
      return null;
    }
  }

  // Get total blocked attempts for all children
  int get totalBlockedAttempts {
    return _reports.fold(
        0, (sum, report) => sum + report.totalBlockedAttempts);
  }

  // Get total screen time for all children
  int get totalScreenTime {
    return _reports.fold(0, (sum, report) => sum + report.screenTimeMinutes);
  }

  // Get most active child
  String get mostActiveChild {
    if (_reports.isEmpty) return 'None';
    return _reports
        .reduce((a, b) =>
    a.screenTimeMinutes > b.screenTimeMinutes ? a : b)
        .childName;
  }

  // Add activity for child
  void addActivity(String childId, String activity) {
    if (!_childActivities.containsKey(childId)) {
      _childActivities[childId] = [];
    }
    _childActivities[childId]!.insert(0, activity);
    if (_childActivities[childId]!.length > 50) {
      _childActivities[childId]!.removeLast();
    }
    notifyListeners();
  }

  // Get activities for child
  List<String> getActivitiesForChild(String childId) {
    return _childActivities[childId] ?? [];
  }
}