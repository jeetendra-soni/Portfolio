import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';
import '../model/skill_model.dart';

class SkillDialog extends StatefulWidget {
  final SkillModel? skill;
  final void Function(SkillModel) onSave;

  const SkillDialog({
    super.key,
    this.skill,
    required this.onSave,
  });

  @override
  State<SkillDialog> createState() => _SkillDialogState();
}

class _SkillDialogState extends State<SkillDialog> {
  late TextEditingController nameCtrl;
  late TextEditingController yearsCtrl;
  SkillLevel? selectedLevel;
  SkillCategory? selectedCategory;
  File? selectedIcon;
  Uint8List? selectedIconBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    nameCtrl = TextEditingController(text: widget.skill?.name ?? '');
    yearsCtrl = TextEditingController(
      text: widget.skill?.experienceYears.toString() ?? '1',
    );

    selectedLevel = widget.skill?.level;
    selectedCategory = widget.skill?.category;
    if (widget.skill?.icon.isNotEmpty == true) {
      final bytes = base64Decode(widget.skill!.icon);

      if (kIsWeb) {
        selectedIconBytes = bytes;
      } else {
        // For mobile: create preview from bytes
        selectedIconBytes = bytes; // use Image.memory for preview
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------- TITLE ----------
              Text(
                widget.skill == null ? "Add Skill" : "Edit Skill",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),

              /// ---------- SKILL NAME ----------
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Skill Name",
                  hintText: "e.g. Flutter, Firebase",
                  prefixIcon: Icon(Icons.code),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              /// ---------- EXPERIENCE YEARS ----------
              TextField(
                controller: yearsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Experience (Years)",
                  prefixIcon: Icon(Icons.timeline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              /// ---------- LEVEL DROPDOWN ----------
              DropdownButtonFormField<SkillLevel>(
                value: selectedLevel,
                decoration: const InputDecoration(
                  labelText: "Skill Level",
                  prefixIcon: Icon(Icons.bar_chart),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: SkillLevel.beginner,
                    child: Text("Beginner"),
                  ),
                  DropdownMenuItem(
                    value: SkillLevel.intermediate,
                    child: Text("Intermediate"),
                  ),
                  DropdownMenuItem(
                    value: SkillLevel.expert,
                    child: Text("Expert"),
                  ),
                ],
                onChanged: (v) => setState(() => selectedLevel = v!),
              ),

              const SizedBox(height: 16),
              /// ---------- CATEGORY DROPDOWN ----------

              DropdownButtonFormField<SkillCategory>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Skill Category",
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: SkillCategory.language,
                    child: Text("Language"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.devTools,
                    child: Text("Dev Tools & CI/CD"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.architecture,
                    child: Text("Architecture & Design Patterns"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.backendApis,
                    child: Text("Backend & APIs"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.stateManagement,
                    child: Text("State Management"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.frameWork,
                    child: Text("Framework"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategory.systemWork,
                    child: Text("System Work"),
                  ),
                ],
                onChanged: (v) => setState(() => selectedCategory = v!),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: _pickIcon,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: selectedIcon == null && selectedIconBytes == null
                      ? const Icon(Icons.add_photo_alternate, size: 32)
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildIconPreview()
                  ),
                ),
              ),

              const SizedBox(height: 28),

              /// ---------- ACTIONS ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                    child: Text("Save Skill", style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildIconPreview() {
    if (kIsWeb && selectedIconBytes != null) {
      return Image.memory(
        selectedIconBytes!,
        fit: BoxFit.cover,
      );
    }

    if (!kIsWeb && selectedIcon != null) {
      return Image.file(
        selectedIcon!,
        fit: BoxFit.cover,
      );
    }

    return const Icon(Icons.add_photo_alternate, size: 32);
  }

  Future<void> _pickIcon() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image == null) return;

    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      setState(() {
        selectedIconBytes = bytes;
        selectedIcon = null;
      });
    } else {
      setState(() {
        selectedIcon = File(image.path);
        selectedIconBytes = null;
      });
    }
  }


  void _onSave() {
    if (nameCtrl.text.trim().isEmpty) return;
    if (selectedLevel == null || selectedCategory == null) return;

    String iconBase64 = '';

    if (kIsWeb && selectedIconBytes != null) {
      iconBase64 = base64Encode(selectedIconBytes!);
    } else if (!kIsWeb && selectedIcon != null) {
      final bytes = selectedIcon!.readAsBytesSync();
      iconBase64 = base64Encode(bytes);
    }

    widget.onSave(
      SkillModel(
        id: widget.skill?.id ?? '',
        name: nameCtrl.text.trim(),
        experienceYears: int.tryParse(yearsCtrl.text) ?? 1,
        level: selectedLevel!,
        category: selectedCategory!,
        icon: iconBase64, // ✅ base64 stored
        order: 0,
      ),
    );

    Navigator.pop(context);
  }


}


class SkillDeleteDialog extends StatelessWidget {
  final String skillName;
  final VoidCallback onConfirm;

  const SkillDeleteDialog({
    super.key,
    required this.skillName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Delete Skill"),
      content: Text(
        'Are you sure you want to delete "$skillName"?\n\nThis action cannot be undone.',
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text("Delete", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context); // close dialog
            onConfirm(); // delete action
          },
        ),
      ],
    );
  }
}

