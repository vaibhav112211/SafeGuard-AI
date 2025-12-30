import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/child_ui_provider.dart';
import '../../models/child_ui_model.dart';
import '../../widgets/custom_input.dart';
import '../../widgets/custom_button.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({Key? key}) : super(key: key);

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  String _selectedAvatar = '👶';
  int _sensitivityLevel = 3;
  int _screenTimeMinutes = 120;

  final List<String> _availableAvatars = [
    '👶', '👧', '👦', '🧒', '👩', '👨', '🧑'
  ];

  final List<String> _availableCategories = [
    'adult',
    'violence',
    'gambling',
    'drugs',
    'weapons',
    'hate',
  ];

  final List<String> _selectedCategories = [];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final childProvider =
    Provider.of<ChildUIProvider>(context, listen: false);

    final newChild = ChildUIModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text),
      avatarUrl: _selectedAvatar,
      sensitivityLevel: _sensitivityLevel,
      blockedCategories: _selectedCategories,
      screenTimeMinutes: _screenTimeMinutes,
      todayScreenTime: 0,
    );

    childProvider.addChild(newChild);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newChild.name} added successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Child'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              const Text(
                'Select Avatar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableAvatars.length,
                  itemBuilder: (context, index) {
                    final avatar = _availableAvatars[index];
                    final isSelected = avatar == _selectedAvatar;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedAvatar = avatar);
                      },
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue[100]
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                            isSelected ? Colors.blue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            avatar,
                            style: const TextStyle(fontSize: 36),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Name
              CustomInput(
                label: 'Child Name',
                hint: 'Enter child name',
                controller: _nameController,
                prefixIcon: Icons.person,
                validator: (v) =>
                v == null || v.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),

              // Age
              CustomInput(
                label: 'Age',
                hint: 'Enter age',
                controller: _ageController,
                prefixIcon: Icons.cake,
                keyboardType: TextInputType.number,
                validator: (v) {
                  final age = int.tryParse(v ?? '');
                  if (age == null || age < 1 || age > 18) {
                    return 'Age must be 1–18';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Sensitivity
              const Text(
                'Content Sensitivity',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Level $_sensitivityLevel – ${_getSensitivityDescription(_sensitivityLevel)}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Slider(
                value: _sensitivityLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: 'Level $_sensitivityLevel',
                onChanged: (v) {
                  setState(() => _sensitivityLevel = v.toInt());
                },
              ),
              const SizedBox(height: 24),

              // Screen Time
              const Text(
                'Daily Screen Time Limit',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                '$_screenTimeMinutes minutes',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Slider(
                value: _screenTimeMinutes.toDouble(),
                min: 30,
                max: 360,
                divisions: 11,
                label: '$_screenTimeMinutes min',
                onChanged: (v) {
                  setState(() => _screenTimeMinutes = v.toInt());
                },
              ),
              const SizedBox(height: 24),

              // Categories
              const Text(
                'Blocked Categories',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableCategories.map((cat) {
                  final selected = _selectedCategories.contains(cat);
                  return FilterChip(
                    label: Text(cat.toUpperCase()),
                    selected: selected,
                    onSelected: (v) {
                      setState(() {
                        v
                            ? _selectedCategories.add(cat)
                            : _selectedCategories.remove(cat);
                      });
                    },
                    selectedColor: Colors.red.withOpacity(0.2),
                    checkmarkColor: Colors.red,
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Submit
              CustomButton(
                text: 'Add Child',
                icon: Icons.person_add,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSensitivityDescription(int level) {
    switch (level) {
      case 1:
        return 'Minimal filtering';
      case 2:
        return 'Light filtering';
      case 3:
        return 'Moderate (Recommended)';
      case 4:
        return 'Strict filtering';
      case 5:
        return 'Maximum protection';
      default:
        return '';
    }
  }
}
