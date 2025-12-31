import 'blocked_content_model.dart';

class ReportUIModel {
  final String childId;
  final String childName;
  final DateTime reportDate;
  final int totalBlockedAttempts;
  final int screenTimeMinutes;
  final List<BlockedContentModel> blockedContent;
  final Map<String, int> categoryBreakdown; // category -> count
  final List<String> mostVisitedSites;
  final int warningsGiven;

  ReportUIModel({
    required this.childId,
    required this.childName,
    required this.reportDate,
    this.totalBlockedAttempts = 0,
    this.screenTimeMinutes = 0,
    this.blockedContent = const [],
    this.categoryBreakdown = const {},
    this.mostVisitedSites = const [],
    this.warningsGiven = 0,
  });

  // Calculate average severity
  double get averageSeverity {
    if (blockedContent.isEmpty) return 0;
    return blockedContent.map((e) => e.severity).reduce((a, b) => a + b) /
        blockedContent.length;
  }

  // Get most blocked category
  String get mostBlockedCategory {
    if (categoryBreakdown.isEmpty) return 'None';
    return categoryBreakdown.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'childName': childName,
      'reportDate': reportDate.toIso8601String(),
      'totalBlockedAttempts': totalBlockedAttempts,
      'screenTimeMinutes': screenTimeMinutes,
      'blockedContent': blockedContent.map((e) => e.toJson()).toList(),
      'categoryBreakdown': categoryBreakdown,
      'mostVisitedSites': mostVisitedSites,
      'warningsGiven': warningsGiven,
    };
  }

  factory ReportUIModel.fromJson(Map<String, dynamic> json) {
    return ReportUIModel(
      childId: json['childId'],
      childName: json['childName'],
      reportDate: DateTime.parse(json['reportDate']),
      totalBlockedAttempts: json['totalBlockedAttempts'] ?? 0,
      screenTimeMinutes: json['screenTimeMinutes'] ?? 0,
      blockedContent: (json['blockedContent'] as List)
          .map((e) => BlockedContentModel.fromJson(e))
          .toList(),
      categoryBreakdown: Map<String, int>.from(json['categoryBreakdown'] ?? {}),
      mostVisitedSites: List<String>.from(json['mostVisitedSites'] ?? []),
      warningsGiven: json['warningsGiven'] ?? 0,
    );
  }
}