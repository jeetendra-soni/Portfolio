import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/experience/ui/exp_manager.dart';
import 'package:jeetendra_portfolio/admin/personal_info/ui/personal_info_page.dart';
import 'package:jeetendra_portfolio/admin/projects/ui/project_manager.dart';
import 'package:jeetendra_portfolio/admin/skills/ui/skill_manager.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  int _selectedIndex = 0;

  /// Pages for each tab
  final List<Widget> _pages = [
    PersonalInfoPage(),
    SkillManager(),
    ExperienceManager(),
    ProjectManager(),

  ];



  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Row(
        children: [
          /// ---------- WEB DRAWER ----------
          Container(
            width: 260,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                /// --- HEADER ---
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? const Icon(Icons.admin_panel_settings, size: 40)
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user?.displayName ?? "Er. Jeetendra Soni",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? "jeetendra1503@gmail.com",
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),



                /// --- MENU ITEMS ---

                _drawerItem(
                  icon: Icons.person,
                  label: "Personal Info",
                  index: 0,
                ),

                _drawerItem(
                  icon: Icons.star,
                  label: "Skills",
                  index: 1,
                ),
                _drawerItem(
                  icon: Icons.work,
                  label: "Experience",
                  index: 2,
                ),
                _drawerItem(
                  icon: Icons.apps,
                  label: "Projects",
                  index: 3,
                ),


                const Spacer(),

                /// --- LOGOUT ---
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout"),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),

          VerticalDivider(
            width: 1,
          ),

          /// ---------- CONTENT ----------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _pages[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() => _selectedIndex = index);
      },
    );
  }

}


