import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/blog_model.dart';
import '../repository/blog_repository.dart';

class BlogDialog extends StatefulWidget {
  final BlogModel? blog;
  final Function(BlogModel) onSave;

  const BlogDialog({super.key, this.blog, required this.onSave});

  @override
  State<BlogDialog> createState() => _BlogDialogState();
}

class _BlogDialogState extends State<BlogDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _contentController;
  late TextEditingController _linkController;
  late TextEditingController _tagsController;
  
  Uint8List? _selectedImageBytes;
  bool _isSaving = false;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog?.title ?? '');
    _descriptionController = TextEditingController(text: widget.blog?.description ?? '');
    _contentController = TextEditingController(text: widget.blog?.content ?? '');
    _linkController = TextEditingController(text: widget.blog?.link ?? '');
    _tagsController = TextEditingController(text: widget.blog?.tags.join(', ') ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _linkController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 80,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.blog == null ? "Add Blog" : "Edit Blog",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                              image: _selectedImageBytes != null
                                  ? DecorationImage(image: MemoryImage(_selectedImageBytes!), fit: BoxFit.cover)
                                  : (widget.blog?.imageUrl.isNotEmpty == true
                                      ? DecorationImage(image: NetworkImage(widget.blog!.imageUrl), fit: BoxFit.cover)
                                      : null),
                            ),
                            child: _selectedImageBytes == null && widget.blog?.imageUrl.isEmpty != false
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey[400]),
                                      const SizedBox(height: 8),
                                      Text("Upload Cover Image", style: TextStyle(color: Colors.grey[400])),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(_titleController, "Title", Icons.title),
                        const SizedBox(height: 16),
                        _buildTextField(_descriptionController, "Short Description", Icons.description_outlined, maxLines: 2),
                        const SizedBox(height: 16),
                        _buildTextField(_contentController, "Content / Body", Icons.article_outlined, maxLines: 6),
                        const SizedBox(height: 16),
                        _buildTextField(_linkController, "External Link (Medium, etc.)", Icons.link),
                        const SizedBox(height: 16),
                        _buildTextField(_tagsController, "Tags (e.g. Flutter, Dart)", Icons.tag),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSaving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text("Save Blog", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepOrangeAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.deepOrangeAccent, width: 2)),
      ),
      validator: (v) => v?.isEmpty == true ? "Field required" : null,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      String imageUrl = widget.blog?.imageUrl ?? '';
      if (_selectedImageBytes != null) {
        final repo = BlogRepository();
        imageUrl = await repo.uploadBlogImage(_selectedImageBytes!, 'blog_${DateTime.now().millisecondsSinceEpoch}.jpg') ?? imageUrl;
      }

      final tags = _tagsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      final blog = BlogModel(
        id: widget.blog?.id ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        content: _contentController.text.trim(),
        imageUrl: imageUrl,
        link: _linkController.text.trim(),
        date: widget.blog?.date ?? DateTime.now(),
        tags: tags,
      );

      widget.onSave(blog);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isSaving = false);
    }
  }
}