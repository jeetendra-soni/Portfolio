import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/award_achievement/model/award_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jeetendra_portfolio/configs/app_fonts.dart';

class AwardDialog extends StatefulWidget {
  final AwardModel? award;
  final Future<void> Function(AwardModel) onSave;

  const AwardDialog({
    super.key,
    this.award,
    required this.onSave,
  });

  @override
  State<AwardDialog> createState() => _AwardDialogState();
}

class _AwardDialogState extends State<AwardDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleCtrl;
  late TextEditingController orgCtrl;
  late TextEditingController descCtrl;
  late TextEditingController orderCtrl;
  late TextEditingController certificateCtrl;
  late TextEditingController iconCtrl;

  DateTime? selectedDate;
  bool isActive = true;
  bool isFeatured = false;

  @override
  void initState() {
    final award = widget.award;

    titleCtrl = TextEditingController(text: award?.title ?? '');
    orgCtrl = TextEditingController(text: award?.organization ?? '');
    descCtrl = TextEditingController(text: award?.description ?? '');
    orderCtrl = TextEditingController(text: award?.order.toString() ?? '0');
    certificateCtrl = TextEditingController(text: award?.certificateUrl ?? '');
    iconCtrl = TextEditingController(text: award?.iconUrl ?? '');

    selectedDate = award?.date;
    isActive = award?.isActive ?? true;
    isFeatured = award?.isFeatured ?? false;

    super.initState();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orangeAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date")),
      );
      return;
    }

    final award = AwardModel(
      id: widget.award?.id ?? '',
      title: titleCtrl.text.trim(),
      organization: orgCtrl.text.trim(),
      description: descCtrl.text.trim(),
      date: selectedDate!,
      certificateUrl: certificateCtrl.text.trim().isEmpty ? null : certificateCtrl.text.trim(),
      iconUrl: iconCtrl.text.trim().isEmpty ? null : iconCtrl.text.trim(),
      isActive: isActive,
      isFeatured: isFeatured,
      order: int.tryParse(orderCtrl.text) ?? 0,
    );

    await widget.onSave(award);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 550,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.award == null ? "Add Achievement" : "Edit Achievement",
                      style: AppFonts.rowdies(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(color: Colors.orangeAccent, thickness: 1.5, height: 32),
                
                _buildFieldTitle("What did you achieve?"),
                _buildTextField(titleCtrl, "Title (e.g. Flutter Developer of the Year)", Icons.emoji_events_outlined),
                
                const SizedBox(height: 20),
                _buildFieldTitle("Issuing Organization"),
                _buildTextField(orgCtrl, "Organization name", Icons.business_outlined),

                const SizedBox(height: 20),
                _buildFieldTitle("Short Description"),
                _buildTextField(descCtrl, "Tell us more about it...", Icons.description_outlined, maxLines: 3),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldTitle("Issue Date"),
                          InkWell(
                            onTap: _pickDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                                color: Colors.orangeAccent.withOpacity(0.05),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.orangeAccent),
                                  const SizedBox(width: 12),
                                  Text(
                                    selectedDate == null
                                        ? "Pick Date"
                                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldTitle("Display Order"),
                          _buildTextField(orderCtrl, "0", Icons.sort, isNumeric: true),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                _buildFieldTitle("Links & Assets"),
                _buildTextField(certificateCtrl, "Certificate URL", Icons.link_rounded),
                const SizedBox(height: 12),
                _buildTextField(iconCtrl, "Icon/Logo URL", Icons.image_outlined),

                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    children: [
                      _buildToggle("Active Status", "Visible on portfolio", isActive, (v) => setState(() => isActive = v)),
                      const Divider(height: 1),
                      _buildToggle("Featured", "Show in highlight section", isFeatured, (v) => setState(() => isFeatured = v)),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Text("Save Achievement", style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, IconData icon, {int maxLines = 1, bool isNumeric = false}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: Colors.orangeAccent),
        filled: true,
        fillColor: Colors.orangeAccent.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orangeAccent.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orangeAccent.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) && icon != Icons.description_outlined && icon != Icons.link_rounded && icon != Icons.image_outlined ? "Required" : null,
    );
  }

  Widget _buildToggle(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      activeColor: Colors.orangeAccent,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}

class AwardDeleteDialog extends StatelessWidget {
  final String awardTitle;
  final VoidCallback onConfirm;

  const AwardDeleteDialog({
    super.key,
    required this.awardTitle,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
          SizedBox(width: 12),
          Text("Delete Achievement"),
        ],
      ),
      content: Text("Are you sure you want to delete \"$awardTitle\"? This action cannot be undone."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Keep it", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text("Delete Permanently"),
        ),
      ],
    );
  }
}