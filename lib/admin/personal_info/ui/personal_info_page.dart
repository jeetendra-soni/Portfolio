import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/personal_info/model/personal_info_model.dart';
import 'package:jeetendra_portfolio/admin/personal_info/provider/personal_info_provider.dart';
import 'package:jeetendra_portfolio/admin/personal_info/ui/personal_info_dialog.dart';

class PersonalInfoPage extends ConsumerWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(personalInfoProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          onEdit: infoAsync.value == null
              ? null
              : () => _openEdit(context, ref, infoAsync.value),
        ),
        const SizedBox(height: 16),
        infoAsync.when(
          data: (info) {
            if (info == null) {
              return _EmptyState(
                onAdd: () => _openEdit(context, ref, null),
              );
            }
            return _InfoCard(info: info);
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Text(e.toString()),
        ),
      ],
    );
  }

  void _openEdit(
      BuildContext context,
      WidgetRef ref,
      PersonalInfoModel? info,
      ) {
    showDialog(
      context: context,
      builder: (_) => PersonalInfoDialog(
        info: info,
        onSave: ref.read(personalInfoRepositoryProvider).saveInfo,
      ),
    );
  }
}


class _Header extends StatelessWidget {
  final VoidCallback? onEdit;

  const _Header({this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Personal Information",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              "Basic profile and social links",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton.icon(
          icon: const Icon(Icons.edit, size: 18),
          label: const Text("Edit"),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
class _InfoCard extends StatelessWidget {
  final PersonalInfoModel info;

  const _InfoCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle("Profile"),
            _item(Icons.person, info.name),
            _item(Icons.badge, info.title),
            _item(Icons.location_on, info.location),
            const SizedBox(height: 12),
            Text(info.bio),

            const Divider(height: 40),

            _SectionTitle("Contact"),
            _item(Icons.email, info.email),
            _item(Icons.phone, info.phone),

            const Divider(height: 40),

            _SectionTitle("Social"),
            _item(Icons.code, info.github),
            _item(Icons.business, info.linkedin),
            _item(Icons.public, info.website),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.person_outline, size: 48),
            const SizedBox(height: 12),
            const Text("No personal information added yet"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAdd,
              child: const Text("Add Personal Info"),
            ),
          ],
        ),
      ),
    );
  }
}
