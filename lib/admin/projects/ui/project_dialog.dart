import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeetendra_portfolio/admin/projects/model/project_model.dart';
import 'package:jeetendra_portfolio/admin/projects/repository/project_repository.dart';
import 'package:jeetendra_portfolio/admin/skills/repository/skill_repository.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeetendra_portfolio/admin/projects/model/project_model.dart';
import 'package:jeetendra_portfolio/admin/projects/repository/project_repository.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';

class ProjectDialog extends StatefulWidget {
  final ProjectModel? project;
  final void Function(ProjectModel) onSave;

  const ProjectDialog({
    super.key,
    this.project,
    required this.onSave,
  });

  @override
  State<ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  late TextEditingController titleCtrl;
  late TextEditingController descCtrl;
  late TextEditingController githubCtrl;
  late TextEditingController liveCtrl;
  late TextEditingController playStoreCtrl;
  late TextEditingController appStoreCtrl;
  late TextEditingController techCtrl;
  late TextEditingController featureCtrl;

  ProjectStatus? selectedStatus;
  bool isFeatured = false;
  bool isSaving = false;

  Uint8List? selectedBannerBytes;
  Uint8List? selectedIconBytes;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final p = widget.project;

    titleCtrl = TextEditingController(text: p?.title ?? '');
    descCtrl = TextEditingController(text: p?.description ?? '');
    githubCtrl = TextEditingController(text: p?.githubUrl ?? '');
    liveCtrl = TextEditingController(text: p?.liveUrl ?? '');
    playStoreCtrl = TextEditingController(text: p?.playStoreUrl ?? '');
    appStoreCtrl = TextEditingController(text: p?.appStoreUrl ?? '');
    techCtrl =
        TextEditingController(text: p?.technologies.join(", ") ?? '');
    featureCtrl =
        TextEditingController(text: p?.features.join(", ") ?? '');

    selectedStatus = p?.status ?? ProjectStatus.inProgress;
    isFeatured = p?.featured ?? false;
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    githubCtrl.dispose();
    liveCtrl.dispose();
    playStoreCtrl.dispose();
    appStoreCtrl.dispose();
    techCtrl.dispose();
    featureCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  widget.project == null
                      ? "Add Project"
                      : "Edit Project",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),

                _buildTextField(titleCtrl, "Project Title", Icons.work),
                const SizedBox(height: 16),

                _buildTextField(descCtrl, "Description",
                    Icons.description,
                    maxLines: 3),
                const SizedBox(height: 16),

                _buildTextField(githubCtrl, "GitHub URL", Icons.code),
                const SizedBox(height: 16),

                _buildTextField(liveCtrl, "Live URL", Icons.link),
                const SizedBox(height: 16),

                _buildTextField(playStoreCtrl, "Play Store URL", Icons.android),
                const SizedBox(height: 16),

                _buildTextField(appStoreCtrl, "App Store URL", Icons.apple),
                const SizedBox(height: 16),

                _buildTextField(techCtrl, "Technologies (comma separated)", Icons.memory),
                const SizedBox(height: 16),

                _buildTextField(featureCtrl, "Features (comma separated)", Icons.star),
                const SizedBox(height: 20),

                DropdownButtonFormField<ProjectStatus>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: "Project Status",
                    border: OutlineInputBorder(),
                  ),
                  items: ProjectStatus.values
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name),
                  ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => selectedStatus = v!),
                ),

                const SizedBox(height: 12),

                SwitchListTile(
                  value: isFeatured,
                  title: const Text("Mark as Featured"),
                  onChanged: (v) =>
                      setState(() => isFeatured = v),
                ),

                const SizedBox(height: 20),

                /// Banner
                const Text("Banner Image"),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickBanner,
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: selectedBannerBytes == null
                        ? const Icon(Icons.add_photo_alternate)
                        : Image.memory(
                      selectedBannerBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// App Icon
                const Text("App Icon"),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickIcon,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: selectedIconBytes == null
                        ? const Icon(Icons.add_photo_alternate)
                        : Image.memory(
                      selectedIconBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed:
                      isSaving ? null : _onSave,
                      child: isSaving
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child:
                        CircularProgressIndicator(
                            strokeWidth: 2),
                      )
                          : const Text("Save Project"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController ctrl,
      String label,
      IconData icon,
      {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future<void> _pickBanner() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    setState(() => selectedBannerBytes = bytes);
  }

  Future<void> _pickIcon() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    setState(() => selectedIconBytes = bytes);
  }

  Future<void> _onSave() async {
    final repo = ProjectRepository();
    if (titleCtrl.text.trim().isEmpty) return;

    setState(() => isSaving = true);

    try {
      String bannerUrl =
          widget.project?.bannerImage ?? '';
      String iconUrl =
          widget.project?.icon ?? '';

      if (selectedBannerBytes != null) {
        bannerUrl = await repo.uploadToFirebase(
            selectedBannerBytes!, "banners") ??
            '';
      }

      if (selectedIconBytes != null) {
        iconUrl = await repo.uploadToFirebase(
            selectedIconBytes!, "icons") ??
            '';
      }

      final project = ProjectModel(
        id: widget.project?.id ?? '',
        title: titleCtrl.text.trim(),
        description: descCtrl.text.trim(),
        githubUrl: githubCtrl.text.trim(),
        liveUrl: liveCtrl.text.trim(),
        playStoreUrl: playStoreCtrl.text.trim(),
        appStoreUrl: appStoreCtrl.text.trim(),
        technologies: techCtrl.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        features: featureCtrl.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        icon: iconUrl,
        bannerImage: bannerUrl,
        galleryImages: [],
        status: selectedStatus!,
        featured: isFeatured,
        createdAt:
        widget.project?.createdAt ??
            DateTime.now(),
        updatedAt: DateTime.now(),
        tagline: '',
        contribution: '',
        playStoreQr: '',
        appStoreQr: '',
      );

      widget.onSave(project);
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Save Error: $e");
    }

    setState(() => isSaving = false);
  }
}




class ProjectDeleteDialog extends StatelessWidget {
  final String projectName;
  final VoidCallback onConfirm;

  const ProjectDeleteDialog({
    super.key,
    required this.projectName,
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
                  const TextSpan(text: "Are you sure you want to delete project "),
                  TextSpan(
                    text: '"$projectName"',
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