import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/personal_info/model/personal_info_model.dart';

class PersonalInfoDialog extends StatefulWidget {
  final PersonalInfoModel? info;
  final Future<void> Function(PersonalInfoModel) onSave;

  const PersonalInfoDialog({
    super.key,
    this.info,
    required this.onSave,
  });

  @override
  State<PersonalInfoDialog> createState() => _PersonalInfoDialogState();
}

class _PersonalInfoDialogState extends State<PersonalInfoDialog> {
  final _formKey = GlobalKey<FormState>();

  late final controllers = {
    "name": TextEditingController(text: widget.info?.name ?? ''),
    "title": TextEditingController(text: widget.info?.title ?? ''),
    "bio": TextEditingController(text: widget.info?.bio ?? ''),
    "email": TextEditingController(text: widget.info?.contact?.email ?? ''),
    "phone": TextEditingController(text: widget.info?.contact?.mobile ?? ''),
    "location": TextEditingController(text: widget.info?.contact?.address ?? ''),
    "github": TextEditingController(text: widget.info?.socials?.git ?? ''),
    "linkedin": TextEditingController(text: widget.info?.socials?.linkedIn ?? ''),
    "twitter": TextEditingController(text: widget.info?.socials?.twitter ?? ''),
    "instagram": TextEditingController(text: widget.info?.socials?.instagram ?? ''),
    "website": TextEditingController(text: widget.info?.socials?.website ?? ''),
  };

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    await widget.onSave(
      PersonalInfoModel(
        id: "main",
        name: controllers["name"]!.text,
        title: controllers["title"]!.text,
        bio: controllers["bio"]!.text,
        socials: Socials(
            fiverr: "", 
            git: controllers["github"]!.text, 
            twitter: controllers["twitter"]!.text,
            others: [], 
            linkedIn: controllers["linkedin"]!.text, 
            youtube: "", 
            upwork: "", 
            instagram: controllers["instagram"]!.text,
            website: controllers["website"]!.text,
            facebook: ""
        ),
        contact: Contact(address: controllers["location"]!.text, mobile: controllers["phone"]!.text, email: controllers["email"]!.text,),
        about: About(expYears: "", title: "", projects: "", description: "", clients: ""),
        profileImg2: '',
        profileImg1: '',
      ),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 600,
        child: Column(
          children: [
            _DialogHeader(
              title: widget.info == null
                  ? "Add Personal Information"
                  : "Edit Personal Information",
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _group("Profile", [
                        _field("name", "Full Name"),
                        _field("title", "Title"),
                        _field("bio", "About", lines: 3),
                      ]),
                      _group("Contact", [
                        _field("email", "Email"),
                        _field("phone", "Phone"),
                        _field("location", "Location"),
                      ]),
                      _group("Social Links", [
                        _field("github", "GitHub"),
                        _field("linkedin", "LinkedIn"),
                        _field("twitter", "Twitter"),
                        _field("instagram", "Instagram"),
                        _field("website", "Website"),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            _DialogActions(onSave: _save),
          ],
        ),
      ),
    );
  }

  Widget _group(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _field(String key, String label, {int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controllers[key],
        maxLines: lines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
class _DialogHeader extends StatelessWidget {
  final String title;

  const _DialogHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Row(
        children: [
          Text(title,
              style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  final VoidCallback onSave;

  const _DialogActions({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onSave,
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }
}