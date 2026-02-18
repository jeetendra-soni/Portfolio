import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/experience/model/experience_model.dart';
import 'package:uuid/uuid.dart';

class ExperienceDialog extends StatefulWidget {
  final ExperienceModel? experience;
  final Future<void> Function(ExperienceModel) onSave;

  const ExperienceDialog({
    super.key,
    this.experience,
    required this.onSave,
  });

  @override
  State<ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends State<ExperienceDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController roleCtrl;
  late final TextEditingController companyCtrl;
  late final TextEditingController locationCtrl;
  late final TextEditingController descriptionCtrl;

  String employmentType = "Full-time";
  DateTime? startDate;
  DateTime? endDate;
  bool currentlyWorking = false;

  @override
  void initState() {
    final e = widget.experience;

    roleCtrl = TextEditingController(text: e?.role ?? '');
    companyCtrl = TextEditingController(text: e?.company ?? '');
    locationCtrl = TextEditingController(text: e?.location ?? '');
    descriptionCtrl = TextEditingController(text: e?.description ?? '');

    employmentType = e?.employmentType ?? "Full-time";
    startDate = e?.startDate;
    endDate = e?.endDate;
    currentlyWorking = e?.currentlyWorking ?? false;

    super.initState();
  }

  InputDecoration _decoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : SizedBox(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        isStart ? startDate = picked : endDate = picked;
      });
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate() || startDate == null) return;

    final model = ExperienceModel(
      id: widget.experience?.id ?? const Uuid().v4(),
      role: roleCtrl.text.trim(),
      company: companyCtrl.text.trim(),
      employmentType: employmentType,
      location: locationCtrl.text.trim(),
      startDate: startDate!,
      endDate: currentlyWorking ? null : endDate,
      currentlyWorking: currentlyWorking,
      description: descriptionCtrl.text.trim(),
      order: widget.experience?.order ?? 0,
    );

    await widget.onSave(model);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: const Color(0xFFF2F3F6),
      child: SizedBox(
        width: 520,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  widget.experience == null
                      ? "Add Experience"
                      : "Edit Experience",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 24),

                /// Role
                TextFormField(
                  controller: roleCtrl,
                  decoration:
                  _decoration("Role / Title", icon: Icons.work_outline),
                  validator: (v) =>
                  v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 16),

                /// Company
                TextFormField(
                  controller: companyCtrl,
                  decoration:
                  _decoration("Company", icon: Icons.business_outlined),
                  validator: (v) =>
                  v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 16),

                /// Employment Type
                DropdownButtonFormField<String>(
                  value: employmentType,
                  decoration: _decoration(
                      "Employment Type", icon: Icons.badge_outlined),
                  items: const [
                    DropdownMenuItem(
                        value: "Full-time", child: Text("Full-time")),
                    DropdownMenuItem(
                        value: "Internship", child: Text("Internship")),
                    DropdownMenuItem(
                        value: "Freelance", child: Text("Freelance")),
                    DropdownMenuItem(
                        value: "Contract", child: Text("Contract")),
                  ],
                  onChanged: (v) => employmentType = v!,
                ),

                const SizedBox(height: 16),

                /// Location
                TextFormField(
                  controller: locationCtrl,
                  decoration:
                  _decoration("Location", icon:  Icons.location_on_outlined),
                ),

                const SizedBox(height: 16),

                /// Dates
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        onTap: () => _pickDate(true),
                        decoration: _decoration(
                          "Start Date",
                          icon:Icons.calendar_today_outlined,
                        ).copyWith(
                          hintText: startDate == null
                              ? null
                              : startDate!
                              .toLocal()
                              .toString()
                              .split(' ')[0],
                        ),
                        validator: (_) =>
                        startDate == null ? "Required" : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        enabled: !currentlyWorking,
                        onTap: () => _pickDate(false),
                        decoration: _decoration(
                          "End Date",
                          icon:Icons.event_outlined,
                        ).copyWith(
                          hintText: endDate == null
                              ? null
                              : endDate!
                              .toLocal()
                              .toString()
                              .split(' ')[0],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// Currently Working
                CheckboxListTile(
                  value: currentlyWorking,
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Currently working here"),
                  onChanged: (v) {
                    setState(() {
                      currentlyWorking = v!;
                      if (v) endDate = null;
                    });
                  },
                ),

                const SizedBox(height: 12),

                /// Description
                TextFormField(
                  controller: descriptionCtrl,
                  maxLines: 3,
                  decoration: _decoration("Description"),
                ),

                const SizedBox(height: 24),

                /// Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      child: const Text("Save Experience", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




class ExpDeleteDialog extends StatelessWidget {
  final String expName;
  final VoidCallback onConfirm;

  const ExpDeleteDialog({
    super.key,
    required this.expName,
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
                  const TextSpan(text: "Are you sure you want to delete experience "),
                  TextSpan(
                    text: '"$expName"',
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
