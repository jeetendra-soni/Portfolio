import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalFooter extends StatelessWidget {
  const ProfessionalFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      color: Colors.blueGrey[900],
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Logo + Links
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBrandLogo(),
                    const SizedBox(height: 20),
                    _buildQuickLinks(),
                    const SizedBox(height: 20),
                    _buildContactInfo(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBrandLogo(),
                    _buildQuickLinks(),
                    _buildContactInfo(),
                  ],
                ),
          const SizedBox(height: 30),
          const Divider(color: Colors.white30),
          const SizedBox(height: 10),
          // Bottom Section: Copyright
          Center(
            child: Text(
              "© ${DateTime.now().year} Your Company. All rights reserved.",
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "YourBrand",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "Delivering excellence since 2026",
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildQuickLinks() {
    final links = ["Home", "About Us", "Services", "Contact"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Links",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        for (var link in links)
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              alignment: Alignment.centerLeft,
            ),
            child: Text(link, style: const TextStyle(color: Colors.white70)),
          ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contact",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text("Email: info@yourbrand.com", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        const Text("Phone: +91 9876543210", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        Row(
          children: [
            _socialIcon("https://facebook.com", Icons.facebook),
            const SizedBox(width: 10),
            _socialIcon("https://twitter.com", Icons.wb_twilight),
            const SizedBox(width: 10),
            _socialIcon("https://linkedin.com", Icons.info),
          ],
        )
      ],
    );
  }

  Widget _socialIcon(String url, IconData icon) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
