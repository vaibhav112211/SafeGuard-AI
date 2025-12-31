import 'package:flutter/foundation.dart';
import '../models/child_ui_model.dart';
import '../models/blocked_content_model.dart';

class ChildUIProvider extends ChangeNotifier {
  List<ChildUIModel> _children = [];
  List<BlockedContentModel> _blockedContent = [];
  String? _selectedChildId;

  List<ChildUIModel> get children => _children;
  List<BlockedContentModel> get blockedContent => _blockedContent;
  String? get selectedChildId => _selectedChildId;

  ChildUIModel? get selectedChild {
    if (_selectedChildId == null) return null;
    try {
      return _children.firstWhere((child) => child.id == _selectedChildId);
    } catch (e) {
      return null;
    }
  }

  // Initialize with mock data
  void initializeMockData() {
    _children = [
      ChildUIModel(
        id: '1',
        name: 'Emma',
        age: 10,
        avatarUrl: '👧',
        isOnline: true,
        sensitivityLevel: 4,
        blockedCategories: ['adult', 'violence', 'gambling'],
        screenTimeMinutes: 120,
        todayScreenTime: 45,
      ),
      ChildUIModel(
        id: '2',
        name: 'Oliver',
        age: 13,
        avatarUrl: '👦',
        isOnline: false,
        sensitivityLevel: 3,
        blockedCategories: ['adult', 'violence'],
        screenTimeMinutes: 180,
        todayScreenTime: 120,
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];

    _blockedContent = [
      BlockedContentModel(
        id: '1',
        url: 'https://example-blocked.com',
        title: 'Inappropriate Site',
        category: 'adult',
        blockedAt: DateTime.now().subtract(const Duration(hours: 3)),
        childId: '1',
        severity: 5,
      ),
      BlockedContentModel(
        id: '2',
        url: 'https://violent-game.com',
        title: 'Violent Game Site',
        category: 'violence',
        blockedAt: DateTime.now().subtract(const Duration(hours: 1)),
        childId: '1',
        severity: 4,
      ),
    ];

    notifyListeners();
  }

  // Add child
  void addChild(ChildUIModel child) {
    _children.add(child);
    notifyListeners();
  }

  // Update child
  void updateChild(String id, ChildUIModel updatedChild) {
    final index = _children.indexWhere((child) => child.id == id);
    if (index != -1) {
      _children[index] = updatedChild;
      notifyListeners();
    }
  }

  // Remove child
  void removeChild(String id) {
    _children.removeWhere((child) => child.id == id);
    if (_selectedChildId == id) {
      _selectedChildId = null;
    }
    notifyListeners();
  }

  // Select child
  void selectChild(String? id) {
    _selectedChildId = id;
    notifyListeners();
  }

  // Get child by ID
  ChildUIModel? getChildById(String id) {
    try {
      return _children.firstWhere((child) => child.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update sensitivity level
  void updateSensitivityLevel(String childId, int level) {
    final child = getChildById(childId);
    if (child != null) {
      updateChild(childId, child.copyWith(sensitivityLevel: level));
    }
  }

  // Update screen time limit
  void updateScreenTimeLimit(String childId, int minutes) {
    final child = getChildById(childId);
    if (child != null) {
      updateChild(childId, child.copyWith(screenTimeMinutes: minutes));
    }
  }

  // Add blocked content
  void addBlockedContent(BlockedContentModel content) {
    _blockedContent.insert(0, content);
    notifyListeners();
  }

  // Get blocked content for child
  List<BlockedContentModel> getBlockedContentForChild(String childId) {
    return _blockedContent
        .where((content) => content.childId == childId)
        .toList();
  }

  // Get today's screen time
  int getTodayScreenTime(String childId) {
    final child = getChildById(childId);
    return child?.todayScreenTime ?? 0;
  }

  // Check if screen time exceeded
  bool isScreenTimeExceeded(String childId) {
    final child = getChildById(childId);
    if (child == null) return false;
    return child.todayScreenTime >= child.screenTimeMinutes;
  }

  // Simulate adding screen time
  void addScreenTime(String childId, int minutes) {
    final child = getChildById(childId);
    if (child != null) {
      updateChild(
        childId,
        child.copyWith(todayScreenTime: child.todayScreenTime + minutes),
      );
    }
  }
}