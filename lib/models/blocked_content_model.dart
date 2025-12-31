class BlockedContentModel {
  final String id;
  final String url;
  final String title;
  final String category;
  final DateTime blockedAt;
  final String childId;
  final String reason;
  final int severity; // 1-5

  BlockedContentModel({
    required this.id,
    required this.url,
    required this.title,
    required this.category,
    required this.blockedAt,
    required this.childId,
    this.reason = 'Inappropriate content detected',
    this.severity = 3,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'category': category,
      'blockedAt': blockedAt.toIso8601String(),
      'childId': childId,
      'reason': reason,
      'severity': severity,
    };
  }

  factory BlockedContentModel.fromJson(Map<String, dynamic> json) {
    return BlockedContentModel(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      category: json['category'],
      blockedAt: DateTime.parse(json['blockedAt']),
      childId: json['childId'],
      reason: json['reason'] ?? 'Inappropriate content detected',
      severity: json['severity'] ?? 3,
    );
  }
}