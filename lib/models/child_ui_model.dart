class ChildUIModel {
  final String id;
  final String name;
  final int age;
  final String avatarUrl;
  final bool isOnline;
  final DateTime lastActive;
  final int sensitivityLevel; // 1-5 (1=lowest, 5=highest)
  final List<String> blockedCategories;
  final int screenTimeMinutes;
  final int todayScreenTime;

  ChildUIModel({
    required this.id,
    required this.name,
    required this.age,
    this.avatarUrl = '',
    this.isOnline = false,
    DateTime? lastActive,
    this.sensitivityLevel = 3,
    this.blockedCategories = const [],
    this.screenTimeMinutes = 120,
    this.todayScreenTime = 0,
  }) : lastActive = lastActive ?? DateTime.now();

  ChildUIModel copyWith({
    String? id,
    String? name,
    int? age,
    String? avatarUrl,
    bool? isOnline,
    DateTime? lastActive,
    int? sensitivityLevel,
    List<String>? blockedCategories,
    int? screenTimeMinutes,
    int? todayScreenTime,
  }) {
    return ChildUIModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      sensitivityLevel: sensitivityLevel ?? this.sensitivityLevel,
      blockedCategories: blockedCategories ?? this.blockedCategories,
      screenTimeMinutes: screenTimeMinutes ?? this.screenTimeMinutes,
      todayScreenTime: todayScreenTime ?? this.todayScreenTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'lastActive': lastActive.toIso8601String(),
      'sensitivityLevel': sensitivityLevel,
      'blockedCategories': blockedCategories,
      'screenTimeMinutes': screenTimeMinutes,
      'todayScreenTime': todayScreenTime,
    };
  }

  factory ChildUIModel.fromJson(Map<String, dynamic> json) {
    return ChildUIModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      avatarUrl: json['avatarUrl'] ?? '',
      isOnline: json['isOnline'] ?? false,
      lastActive: DateTime.parse(json['lastActive']),
      sensitivityLevel: json['sensitivityLevel'] ?? 3,
      blockedCategories: List<String>.from(json['blockedCategories'] ?? []),
      screenTimeMinutes: json['screenTimeMinutes'] ?? 120,
      todayScreenTime: json['todayScreenTime'] ?? 0,
    );
  }
}