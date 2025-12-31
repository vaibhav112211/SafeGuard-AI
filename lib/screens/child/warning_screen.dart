import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class WarningScreen extends StatelessWidget {
final String url;
final String category;

const WarningScreen({
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
Colors.orange[300]!,
Colors.orange[500]!,
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
// Warning Icon
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
Icons.warning,
size: 80,
color: Colors.orange,
),
),
const SizedBox(height: 32),

// Warning Card
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
'Warning',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: Colors.orange,
),
),
const SizedBox(height: 16),
Text(
'This website may contain content that requires parental guidance.',
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
color: Colors.orange[50],
borderRadius: BorderRadius.circular(12),
),
child: Row(
children: [
const Icon(
Icons.link,
color: Colors.orange,
size: 20,
),
const SizedBox(width: 12),
Expanded(
child: Text(
url,
style: const TextStyle(
fontSize: 14,
fontWeight: FontWeight.w500,
),
maxLines: 2,
overflow: TextOverflow.ellipsis,
),
),
],
),
),
const SizedBox(height: 16),

// Category Badge
Container(
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 8,
),
decoration: BoxDecoration(
color: Colors.orange.withOpacity(0.2),
borderRadius: BorderRadius.circular(20),
),
child: Text(
'Category: ${category.toUpperCase()}',
style: const TextStyle(
fontSize: 12,
fontWeight: FontWeight.w600,
color: Colors.orange,
),
),
),
const SizedBox(height: 24),

// Buttons
CustomButton(
text: 'Go Back',
onPressed: () => Navigator.pop(context, false),
backgroundColor: Colors.orange,
icon: Icons.arrow_back,
),
const SizedBox(height: 12),
CustomButton(
text: 'Continue Anyway',
onPressed: () => Navigator.pop(context, true),
isOutlined: true,
backgroundColor: Colors.orange,
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
child: const Row(
children: [
Icon(
Icons.info_outline,
color: Colors.white,
size: 20,
),
SizedBox(width: 12),
Expanded(
child: Text(
'Your parent will be notified if you continue',
style: TextStyle(
color: Colors.white,
fontSize: 12,
),
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
