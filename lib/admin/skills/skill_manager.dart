import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SkillManager extends StatelessWidget {
  const SkillManager({super.key});

  @override
  Widget build(BuildContext context) {
    final skillsRef = FirebaseFirestore.instance.collection('skills').orderBy('order');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ---------- HEADER ----------
        Row(
          children: [
            const Text(
              "Skills",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Skill"),
              onPressed: () => _openSkillDialog(context),
            )
          ],
        ),

        const SizedBox(height: 20),

        /// ---------- LIST ----------
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: skillsRef.snapshots(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No skills added yet"));
              }

              return ListView.separated(
                itemCount: snapshot.data!.docs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;

                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        data['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text("Level: ${data['level']}%"),
                      leading: CircleAvatar(
                        child: Text("${data['level']}%"),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _openSkillDialog(context, doc: doc),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, doc.reference),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// ---------- ADD / EDIT DIALOG ----------
  void _openSkillDialog(BuildContext context, {QueryDocumentSnapshot? doc}) {
    final nameCtrl = TextEditingController(text: doc != null ? doc['name'] : '');
    double level = doc != null ? (doc['level'] as num).toDouble() : 50;
    final orderCtrl = TextEditingController(text: doc != null ? doc['order'].toString() : '0');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(doc == null ? "Add Skill" : "Edit Skill"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Skill Name"),
                ),
                const SizedBox(height: 12),
                Text("Level: ${level.toInt()}%"),
                Slider(
                  value: level,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: level.toInt().toString(),
                  onChanged: (v) => setState(() => level = v),
                ),
                TextField(
                  controller: orderCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Order (priority)"),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;

              final data = {
                "name": nameCtrl.text.trim(),
                "level": level.toInt(),
                "order": int.tryParse(orderCtrl.text) ?? 0,
                "updatedAt": FieldValue.serverTimestamp(),
              };

              final skills = FirebaseFirestore.instance.collection('skills');

              if (doc == null) {
                await skills.add({
                  ...data,
                  "createdAt": FieldValue.serverTimestamp(),
                });
              } else {
                await doc.reference.update(data);
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// ---------- DELETE CONFIRM ----------
  void _confirmDelete(BuildContext context, DocumentReference ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Skill"),
        content: const Text("Are you sure you want to delete this skill?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
            onPressed: () async {
              await ref.delete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
