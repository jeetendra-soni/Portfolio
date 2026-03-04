import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/award_achievement/model/award_model.dart';

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
    orderCtrl =
        TextEditingController(text: award?.order.toString() ?? '0');
    certificateCtrl =
        TextEditingController(text: award?.certificateUrl ?? '');
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
      certificateUrl: certificateCtrl.text.trim().isEmpty
          ? null
          : certificateCtrl.text.trim(),
      iconUrl:
      iconCtrl.text.trim().isEmpty ? null : iconCtrl.text.trim(),
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
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.award == null
                      ? "Add Award"
                      : "Edit Award",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                TextFormField(
                  controller: titleCtrl,
                  decoration:
                  const InputDecoration(labelText: "Title"),
                  validator: (v) =>
                  v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 16),

                // Organization
                TextFormField(
                  controller: orgCtrl,
                  decoration:
                  const InputDecoration(labelText: "Organization"),
                  validator: (v) =>
                  v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration:
                  const InputDecoration(labelText: "Description"),
                ),

                const SizedBox(height: 16),

                // Date Picker
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? "No date selected"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text("Select Date"),
                    )
                  ],
                ),

                const SizedBox(height: 16),

                // Order
                TextFormField(
                  controller: orderCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                  const InputDecoration(labelText: "Order"),
                ),

                const SizedBox(height: 16),

                // Certificate URL
                TextFormField(
                  controller: certificateCtrl,
                  decoration: const InputDecoration(
                      labelText: "Certificate URL"),
                ),

                const SizedBox(height: 16),

                // Icon URL
                TextFormField(
                  controller: iconCtrl,
                  decoration:
                  const InputDecoration(labelText: "Icon URL"),
                ),

                const SizedBox(height: 16),

                // Switches
                SwitchListTile(
                  value: isActive,
                  title: const Text("Active"),
                  onChanged: (v) =>
                      setState(() => isActive = v),
                ),

                SwitchListTile(
                  value: isFeatured,
                  title: const Text("Featured"),
                  onChanged: (v) =>
                      setState(() => isFeatured = v),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Save"),
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
      title: const Text("Delete Award"),
      content: Text("Are you sure you want to delete \"$awardTitle\"?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}