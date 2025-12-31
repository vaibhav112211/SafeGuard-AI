
import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class BlockScreen extends StatelessWidget {
final String url;
final String category;

const BlockScreen({
Key? key,
required this.url,
required this.category,
}) : super(key: key);

@override
Widget build(BuildContext context) {
return Scaffold(
body: Container(
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
colors: [
Colors.red[300]!,
Colors.red[500]!,
],
),
),
child: SafeArea(
child: Center(
child: Padding(
padding: const EdgeInsets.all(24.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
// Block Icon
Container(
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
color: Colors.white,
shape: BoxShape.circle,
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.2),
blurRadius: 20,
offset: const Offset(0, 10),
),
],
),
child: const Icon(
Icons.block,
size: 80,
color: Colors.red,
),
),
const SizedBox(height: 32),

// Block Card
Container(
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.1),
blurRadius: 20,
offset: const Offset(0, 10),
),
],
),
child: Column(
children: [
const Text(
'Content Blocked',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: Colors.red,
),
),
const SizedBox(height: 16),
Text(
'This website has been blocked for your safety.',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 16,
color: Colors.grey[700],
),
),
const SizedBox(height: 24),

// URL Display
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.red[50],
borderRadius: BorderRadius.circular(12),
),
child: Row(
children: [
const Icon(
Icons.link_off,
color: Colors.red,
size: 20,
),
const SizedBox(width: 12),
Expanded(
child: Text(
url,
style: const TextStyle(
fontSize: 14,
fontWeight: FontWeight.w500,
decoration: TextDecoration.lineThrough,
),
maxLines: 2,
overflow: TextOverflow.ellipsis,
),
),
],
),
),
const SizedBox(height: 16),

// Reason
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.grey[100],
borderRadius: BorderRadius.circular(12),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Row(
children: [
Icon(
Icons.info_outline,
size: 20,
color: Colors.grey,
),
SizedBox(width: 8),
Text(
'Reason',
style: TextStyle(
fontWeight: FontWeight.w600,
fontSize: 14,
),
),
],
),
const SizedBox(height: 8),
Text(
'Contains inappropriate content: ${category.toUpperCase()}',
style: TextStyle(
fontSize: 14,
color: Colors.grey[700],
),
),
],
),
),
const SizedBox(height: 24),

// Back Button
CustomButton(
text: 'Go Back to Safe Browsing',
onPressed: () => Navigator.pop(context),
backgroundColor: Colors.red,
icon: Icons.arrow_back,
),
],
),
),

const SizedBox(height: 24),

// Parent Notification
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.2),
borderRadius: BorderRadius.circular(12),
),
child: const Column(
children: [
Row(
children: [
Icon(
Icons.notifications_active,
color: Colors.white,
size: 20,
),
SizedBox(width: 12),
Expanded(
child: Text(
'Your parent has been notified',
style: TextStyle(
color: Colors.white,
fontSize: 14,
fontWeight: FontWeight.w600,
),
),
),
],
),
SizedBox(height: 8),
Text(
'This attempt has been logged in your browsing activity',
style: TextStyle(
color: Colors.white70,
fontSize: 12,
),
),
],
),
),
],
),
),
),
),
),
);
}
}
