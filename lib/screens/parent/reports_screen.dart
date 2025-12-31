
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/child_ui_provider.dart';
import '../../providers/parent_ui_provider.dart';
import '../../widgets/section_title.dart';

class ReportsScreen extends StatelessWidget {
const ReportsScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
final childProvider = Provider.of<ChildUIProvider>(context);
final parentProvider = Provider.of<ParentUIProvider>(context);

return Scaffold(
appBar: AppBar(
title: const Text('Activity Reports'),
backgroundColor: Colors.orange,
foregroundColor: Colors.white,
),
body: childProvider.children.isEmpty
? const Center(
child: Text('No children added yet'),
)
    : ListView.builder(
padding: const EdgeInsets.all(24),
itemCount: childProvider.children.length,
itemBuilder: (context, index) {
final child = childProvider.children[index];
final report = parentProvider.getReportForChild(child.id);

return Card(
margin: const EdgeInsets.only(bottom: 16),
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
child: ExpansionTile(
leading: Container(
width: 50,
height: 50,
decoration: BoxDecoration(
color: Colors.orange[100],
borderRadius: BorderRadius.circular(12),
),
child: Center(
child: Text(
child.avatarUrl,
style: const TextStyle(fontSize: 28),
),
),
),
title: Text(
child.name,
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
subtitle: Text(
'Report for ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
style: TextStyle(
fontSize: 14,
color: Colors.grey[600],
),
),
children: [
if (report != null) _buildReportDetails(context, child, report),
],
),
);
},
),
);
}

Widget _buildReportDetails(context, child, report) {
return Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Summary Stats
Row(
children: [
Expanded(
child: _buildStatBox(
'Screen Time',
'${report.screenTimeMinutes}m',
Icons.access_time,
Colors.orange,
),
),
const SizedBox(width: 12),
Expanded(
child: _buildStatBox(
'Blocked',
'${report.totalBlockedAttempts}',
Icons.block,
Colors.red,
),
),
],
),
const SizedBox(height: 12),
Row(
children: [
Expanded(
child: _buildStatBox(
'Warnings',
'${report.warningsGiven}',
Icons.warning,
Colors.yellow[700]!,
),
),
const SizedBox(width: 12),
Expanded(
child: _buildStatBox(
'Avg Severity',
report.averageSeverity.toStringAsFixed(1),
Icons.trending_up,
Colors.purple,
),
),
],
),
const SizedBox(height: 20),

// Category Breakdown
const Text(
'Category Breakdown',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 12),
...report.categoryBreakdown.entries.map((entry) {
return Padding(
padding: const EdgeInsets.only(bottom: 8),
child: Row(
children: [
Expanded(
child: Text(
entry.key.toUpperCase(),
style: const TextStyle(
fontSize: 14,
fontWeight: FontWeight.w500,
),
),
),
Container(
width: 100,
height: 8,
decoration: BoxDecoration(
color: Colors.grey[200],
borderRadius: BorderRadius.circular(4),
),
child: FractionallySizedBox(
alignment: Alignment.centerLeft,
widthFactor: entry.value / report.totalBlockedAttempts,
child: Container(
decoration: BoxDecoration(
color: Colors.red,
borderRadius: BorderRadius.circular(4),
),
),
),
),
const SizedBox(width: 12),
Text(
'${entry.value}',
style: const TextStyle(
fontSize: 14,
fontWeight: FontWeight.bold,
),
),
],
),
);
}).toList(),
const SizedBox(height: 20),

// Most Visited Sites
const Text(
'Most Visited Safe Sites',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 12),
...report.mostVisitedSites.map((site) {
return Padding(
padding: const EdgeInsets.only(bottom: 8),
child: Row(
children: [
const Icon(Icons.check_circle, color: Colors.green, size: 16),
const SizedBox(width: 8),
Text(
site,
style: const TextStyle(fontSize: 14),
),
],
),
);
}).toList(),
],
),
);
}

Widget _buildStatBox(String label, String value, IconData icon, Color color) {
return Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(12),
),
child: Column(
children: [
Icon(icon, color: color, size: 24),
const SizedBox(height: 8),
Text(
value,
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: color,
),
),
const SizedBox(height: 4),
Text(
label,
style: TextStyle(
fontSize: 12,
color: Colors.grey[700],
),
textAlign: TextAlign.center,
),
],
),
);
}
}
