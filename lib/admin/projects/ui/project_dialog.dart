import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeetendra_portfolio/admin/projects/model/project_model.dart';
import 'package:jeetendra_portfolio/admin/projects/repository/project_repository.dart';
import 'package:jeetendra_portfolio/constants/enums.dart';

class ProjectDialog extends StatefulWidget {
  final ProjectModel? project;
  final Function(ProjectModel) onSave;

  const ProjectDialog({super.key, this.project, required this.onSave});

  @override
  State<ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  final _picker = ImagePicker();

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
    techCtrl = TextEditingController(text: p?.technologies.join(", ") ?? '');
    featureCtrl = TextEditingController(text: p?.features.join(", ") ?? '');

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

  /// Refined Banner Picker with Compression and Size Management
  Future<void> _pickBanner() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,      // Max width for high-quality web banners
        maxHeight: 1080,     // Max height to maintain HD aspect ratio
        imageQuality: 70,    // Compress to 70% quality for significant size reduction
      );

      if (image == null) return;

      final Uint8List bytes = await image.readAsBytes();

      // Validation: Ensure the compressed image is web-friendly (under 1MB)
      final double sizeInMb = bytes.lengthInBytes / (1024 * 1024);
      if (sizeInMb > 1.5) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Image is too large (${sizeInMb.toStringAsFixed(2)}MB). Please choose a smaller file."),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        return;
      }

      setState(() => selectedBannerBytes = bytes);

      debugPrint("Banner picked: ${image.name}, Final Size: ${sizeInMb.toStringAsFixed(2)}MB");
    } catch (e) {
      debugPrint("Error picking banner: $e");
    }
  }

  /// Refined Icon Picker with strict size constraints
  Future<void> _pickIcon() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,       // Standard size for high-res app icons
        maxHeight: 512,
        imageQuality: 80,    // Icons need slightly higher quality
      );

      if (image == null) return;

      final Uint8List bytes = await image.readAsBytes();
      setState(() => selectedIconBytes = bytes);
    } catch (e) {
      debugPrint("Error picking icon: $e");
    }
  }

  Future<void> _onSave() async {
    final repo = ProjectRepository();
    if (titleCtrl.text.trim().isEmpty) return;

    setState(() => isSaving = true);

    try {
      String bannerUrl = widget.project?.bannerImage ?? '';
      String iconUrl = widget.project?.icon ?? '';

      if (selectedBannerBytes != null) {
        bannerUrl = await repo.uploadToFirebase(selectedBannerBytes!, "banners") ?? '';
      }

      if (selectedIconBytes != null) {
        iconUrl = await repo.uploadToFirebase(selectedIconBytes!, "icons") ?? '';
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
        createdAt: widget.project?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        tagline: '',
        contribution: '',
        playStoreQr: '',
        appStoreQr: '',
      );

      widget.onSave(project);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Save Error: $e");
    }

    setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.project == null ? "Add Project" : "Edit Project",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(height: 32),

                _buildTextField(titleCtrl, "Project Title", Icons.work),
                const SizedBox(height: 16),
                _buildTextField(descCtrl, "Description", Icons.description, maxLines: 3),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _buildTextField(githubCtrl, "GitHub URL", Icons.code)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(liveCtrl, "Live URL", Icons.link)),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _buildTextField(playStoreCtrl, "Play Store", Icons.android)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(appStoreCtrl, "App Store", Icons.apple)),
                  ],
                ),
                const SizedBox(height: 16),

                _buildTextField(techCtrl, "Technologies (comma separated)", Icons.memory),
                const SizedBox(height: 16),
                _buildTextField(featureCtrl, "Features (comma separated)", Icons.star),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<ProjectStatus>(
                        value: selectedStatus,
                        decoration: InputDecoration(
                          labelText: "Project Status",
                          filled: true,
                          fillColor: Colors.orangeAccent.withOpacity(0.05),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ProjectStatus.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
                        onChanged: (v) => setState(() => selectedStatus = v!),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      children: [
                        const Text("Featured", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Switch(
                          value: isFeatured,
                          activeColor: Colors.orangeAccent,
                          onChanged: (v) => setState(() => isFeatured = v),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                const Text("Visual Assets", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Picker
                    GestureDetector(
                      onTap: _pickIcon,
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                            ),
                            child: selectedIconBytes == null
                                ? const Icon(Icons.add_a_photo_outlined, color: Colors.orangeAccent)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.memory(selectedIconBytes!, fit: BoxFit.cover),
                                  ),
                          ),
                          const SizedBox(height: 8),
                          const Text("App Icon", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Banner Picker
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickBanner,
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                              ),
                              child: selectedBannerBytes == null
                                  ? const Icon(Icons.add_photo_alternate_outlined, color: Colors.orangeAccent)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.memory(selectedBannerBytes!, fit: BoxFit.cover),
                                    ),
                            ),
                            const SizedBox(height: 8),
                            const Text("Banner Image (HD)", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSaving ? null : _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isSaving
                            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text("Save Project", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
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

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orangeAccent),
        filled: true,
        fillColor: Colors.orangeAccent.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.orangeAccent, width: 2)),
      ),
    );
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