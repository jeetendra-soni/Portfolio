import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
      color: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Get In Touch', light: true),
          const SizedBox(height: 40),

          /// ✅ DESKTOP LAYOUT
          if (!isMobile)
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: ContactInfoPanel()),
                SizedBox(width: 40),
                Expanded(child: ContactForm()),
              ],
            ),

          /// ✅ MOBILE LAYOUT
          if (isMobile)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContactInfoPanel(),
                SizedBox(height: 32),
                ContactForm(),
              ],
            ),
        ],
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 20),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const _InputField(label: 'Your Name'),
            const SizedBox(height: 20),
            const _InputField(label: 'Email Address'),
            const SizedBox(height: 20),
            const _InputField(
              label: 'Message',
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Connect EmailJS / API / Firebase
                  }
                },
                child: const Text(
                  'Send Message',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final int maxLines;

  const _InputField({
    required this.label,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class ContactInfoPanel extends StatelessWidget {
  const ContactInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ContactInfoCard(
          icon: Icons.email,
          title: 'Email',
          value: 'dev.jeetendra1503@email.com',
        ),
        const SizedBox(height: 20),
        const ContactInfoCard(
          icon: Icons.phone,
          title: 'Phone',
          value: '+91 7509005537',
        ),
        const SizedBox(height: 20),
        const ContactInfoCard(
          icon: Icons.location_on,
          title: 'Location',
          value: 'Noida, Uttar Pradesh, India',
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            socialIcon("https://facebook.com", Icons.facebook),
            const SizedBox(width: 10),
            socialIcon("https://twitter.com", Icons.wb_twilight),
            const SizedBox(width: 10),
            socialIcon("https://linkedin.com", Icons.info),
          ],
        )
      ],
    );
  }

  Widget socialIcon(String url, IconData icon) {
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

class ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ContactInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
