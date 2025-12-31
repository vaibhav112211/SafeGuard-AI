
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/child_ui_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/section_title.dart';

class SensitivityScreen extends StatefulWidget {
final String childId;

const SensitivityScreen({Key? key, required this.childId}) : super(key: key);

@override
State<SensitivityScreen> createState() => _SensitivityScreenState();
}

class _SensitivityScreenState extends State<SensitivityScreen> {
late int _sensitivityLevel;
late int _screenTimeMinutes;
late List<String> _blockedCategories;

final List<String> _availableCategories = [
'adult',
'violence',
'gambling',
'drugs',
'weapons',
'hate',
'social',
'games',
];

@override
void initState() {
super.initState();
final childProvider = Provider.of<ChildUIProvider>(context, listen: false);
final child = childProvider.getChildById(widget.childId);

if (child != null) {
_sensitivityLevel = child.sensitivityLevel;
_screenTimeMinutes = child.screenTimeMinutes;
_blockedCategories = List.from(child.blockedCategories);
}
}

void _saveSettings() {
final childProvider = Provider.of<ChildUIProvider>(context, listen: false);
final child = childProvider.getChildById(widget.childId);

if (child != null) {
final updatedChild = child.copyWith(
sensitivityLevel: _sensitivityLevel,
screenTimeMinutes: _screenTimeMinutes,
blockedCategories: _blockedCategories,
);

childProvider.updateChild(widget.childId, updatedChild);

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Settings saved successfully!'),
backgroundColor: Colors.green,
),
);

Navigator.pop(context);
}
}

@override
Widget build(BuildContext context) {
final childProvider = Provider.of<ChildUIProvider>(context);
final child = childProvider.getChildById(widget.childId);

if (child == null) {
return Scaffold(
appBar: AppBar(title: const Text('Settings')),
body: const Center(child: Text('Child not found')),
);
}

return Scaffold(
appBar: AppBar(
title: Text('${child.name}\'s Settings'),
backgroundColor: Colors.blue,
foregroundColor: Colors.white,
),
body: SingleChildScrollView(
padding: const EdgeInsets.all(24.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Child Info
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.blue[50],
borderRadius: BorderRadius.circular(16),
),
child: Row(
children: [
Container(
width: 60,
height: 60,
decoration: BoxDecoration(
color: Colors.blue[100],
borderRadius: BorderRadius.circular(12),
),
child: Center(
child: Text(
child.avatarUrl,
style: const TextStyle(fontSize: 32),
),
),
),
const SizedBox(width: 16),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
child.name,
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
Text(
'Age: ${child.age}',
style: TextStyle(
fontSize: 14,
color: Colors.grey[700],
),
),
],
),
),
],
),
),
const SizedBox(height: 32),

// Sensitivity Level
SectionTitle(
title: 'Content Sensitivity',
subtitle: 'Adjust content filtering level',
padding: EdgeInsets.zero,
),
const SizedBox(height: 16),
Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: Colors.grey[300]!),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'Level',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
Container(
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 8,
),
decoration: BoxDecoration(
color: Colors.blue[100],
borderRadius: BorderRadius.circular(20),
),
child: Text(
'$_sensitivityLevel',
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Colors.blue,
),
),
),
],
),
const SizedBox(height: 12),
Text(
_getSensitivityDescription(_sensitivityLevel),
style: TextStyle(
fontSize: 14,
color: Colors.grey[600],
),
),
Slider(
value: _sensitivityLevel.toDouble(),
min: 1,
max: 5,
divisions: 4,
label: 'Level $_sensitivityLevel',
onChanged: (value) {
setState(() {
_sensitivityLevel = value.toInt();
});
},
),
],
),
),
const SizedBox(height: 32),

// Screen Time Limit
SectionTitle(
title: 'Screen Time Limit',
subtitle: 'Daily browsing time limit',
padding: EdgeInsets.zero,
),
const SizedBox(height: 16),
Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: Colors.grey[300]!),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'Time Limit',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
Container(
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 8,
),
decoration: BoxDecoration(
color: Colors.orange[100],
borderRadius: BorderRadius.circular(20),
),
child: Text(
'$_screenTimeMinutes min',
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: Colors.orange,
),
),
),
],
),
const SizedBox(height: 8),
Text(
'${(_screenTimeMinutes / 60).toStringAsFixed(1)} hours per day',
style: TextStyle(
fontSize: 14,
color: Colors.grey[600],
),
),
Slider(
value: _screenTimeMinutes.toDouble(),
min: 30,
max: 360,
divisions: 11,
label: '$_screenTimeMinutes min',
onChanged: (value) {
setState(() {
_screenTimeMinutes = value.toInt();
});
},
),
],
),
),
const SizedBox(height: 32),

// Blocked Categories
SectionTitle(
title: 'Blocked Categories',
subtitle: 'Select content categories to block',
padding: EdgeInsets.zero,
),
const SizedBox(height: 16),
Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
border: Border.all(color: Colors.grey[300]!),
),
child: Wrap(
spacing: 8,
runSpacing: 8,
children: _availableCategories.map((category) {
final isSelected = _blockedCategories.contains(category);
return FilterChip(
label: Text(category.toUpperCase()),
selected: isSelected,
onSelected: (selected) {
setState(() {
if (selected) {
_blockedCategories.add(category);
} else {
_blockedCategories.remove(category);
}
});
},
selectedColor: Colors.red.withOpacity(0.2),
checkmarkColor: Colors.red,
side: BorderSide(
color: isSelected ? Colors.red : Colors.grey[300]!,
),
);
}).toList(),
),
),
const SizedBox(height: 32),

// Save Button
CustomButton(
text: 'Save Settings',
onPressed: _saveSettings,
icon: Icons.save,
),
],
),
),
);
}

String _getSensitivityDescription(int level) {
switch (level) {
case 1:
return 'Minimal filtering - Suitable for older teens';
case 2:
return 'Light filtering - Basic protection';
case 3:
return 'Moderate filtering - Recommended for most children';
case 4:
return 'Strict filtering - Strong protection';
case 5:
return 'Maximum protection - For young children';
default:
return '';
}
}
}
