import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeetendra_portfolio/admin/skills/repository/skill_repository.dart';
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
  SkillCategoryType? selectedCategory;
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

              DropdownButtonFormField<SkillCategoryType>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Skill Category",
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: SkillCategoryType.language,
                    child: Text("Language"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategoryType.devTools,
                    child: Text("Dev Tools & CI/CD"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategoryType.architecture,
                    child: Text("Architecture & Design Patterns"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategoryType.backendApis,
                    child: Text("Backend & APIs"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategoryType.stateManagement,
                    child: Text("State Management"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategoryType.frameWork,
                    child: Text("Framework"),
                  ),
                  DropdownMenuItem(
                    value: SkillCategoryType.systemWork,
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

      debugPrint("Picked image bytes length: ${bytes.length}");

      if (bytes.isEmpty) {
        debugPrint("Image bytes are EMPTY ❌");
        return;
      }

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



  Future<void> _onSave() async {
    if (nameCtrl.text.trim().isEmpty) return;
    if (selectedLevel == null || selectedCategory == null) return;

    final repo = SkillRepository();

    String iconUrl = widget.skill?.icon ?? '';

    try {
      /// 🔥 Upload icon if selected
      if (kIsWeb && selectedIconBytes != null) {
        iconUrl = await repo.uploadSkillIconWeb(selectedIconBytes!);
      } else if (!kIsWeb && selectedIcon != null) {
        iconUrl = await repo.uploadSkillIcon(File(selectedIcon!.path));
      }

      final skill = SkillModel(
        id: widget.skill?.id ?? '',
        name: nameCtrl.text.trim(),
        experienceYears: int.tryParse(yearsCtrl.text) ?? 1,
        level: selectedLevel!,
        category: selectedCategory!,
        icon: iconUrl, // ✅ Save download URL
        order: 0,
      );

      if (widget.skill == null) {
        await repo.addSkill(skill);
      } else {
        await repo.updateSkill(skill);
      }

      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error saving skill: $e");
    }
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// 🔴 Warning Icon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 32,
              ),
            ),

            const SizedBox(height: 20),

            /// Title
            const Text(
              "Delete Project",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// Message
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                children: [
                  const TextSpan(text: "Are you sure you want to delete skill "),
                  TextSpan(
                    text: '"$skillName"',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const TextSpan(
                    text:
                    "?\n\nThis action cannot be undone.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            /// Buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 60),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}