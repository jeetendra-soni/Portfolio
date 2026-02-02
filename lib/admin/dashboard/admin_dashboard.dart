import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/skills/skill_manager.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  /// Pages for each tab
  final List<Widget> _pages = [
    SkillManager(),
    const Center(
      child: Text(
        "Experience Manager (Coming Soon)",
        style: TextStyle(fontSize: 18),
      ),
    ),
  ];

  void _onDestinationSelected(int index) async {
    if (index == 2) {
      // 🔴 Logout
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pop(); // close dashboard
      }
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /// ---------- SIDEBAR ----------
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            elevation: 2,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircleAvatar(
                radius: 22,
                child: Icon(Icons.admin_panel_settings),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.star_border),
                selectedIcon: Icon(Icons.star),
                label: Text("Skills"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.work_outline),
                selectedIcon: Icon(Icons.work),
                label: Text("Experience"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout),
                label: Text("Logout"),
              ),
            ],
          ),

          const VerticalDivider(width: 1),

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
}
