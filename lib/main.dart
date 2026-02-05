import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/dashboard/admin_dashboard.dart';
import 'package:jeetendra_portfolio/views/widgets/navigation_bar/navigation_bar.dart';
import 'configs/theme_config.dart';
import 'firebase_options.dart';
import 'views/sections/about.dart';
import 'views/sections/contact.dart';
import 'views/sections/experience.dart';
import 'views/sections/footer.dart';
import 'views/sections/hero_section.dart';
import 'views/sections/project.dart';
import 'views/sections/skill.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: PortfolioApp()));
}

/// ---------------- APP ----------------
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Developer Portfolio',
      theme: getResponsiveTheme(context),
      home: const AdminDashboard(),
    );
  }
}

/// ---------------- PAGE ----------------
class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();

  /// Section Keys
  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final experienceKey = GlobalKey();
  final portfolioKey = GlobalKey();
  final contactKey = GlobalKey();

  void scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final viewport = RenderAbstractViewport.of(box);
    final offset = viewport.getOffsetToReveal(box, 0).offset;

    _scrollController.animateTo(
      offset - 90,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          /// ---------- CLEAN STICKY NAVBAR ----------
          SliverAppBar(pinned: true, elevation: 3, titleSpacing: 0, backgroundColor: Colors.blueGrey[900], toolbarHeight: 70, automaticallyImplyLeading: false, title: const MyNavigationBar()),

          /// ---------- CONTENT ----------
          SliverToBoxAdapter(
            child: Column(
              children: [
                SectionContainer(
                  key: homeKey,
                  background: Colors.black,
                  showBottomDivider: true,
                  child: const HeroSection(),
                ),
                SectionContainer(
                  key: aboutKey,
                  background: Colors.white,
                  child: const AboutSection(),
                ),
                SectionContainer(
                  key: skillsKey,
                  background: const Color(0xFFF5F7FA),
                  child: const SkillsSection(),
                ),
                SectionContainer(
                  key: experienceKey,
                  background: Colors.white,
                  child: const ExperienceSection(),
                ),
                SectionContainer(
                  key: portfolioKey,
                  background: const Color(0xFFF5F7FA),
                  child: const ProjectsSection(),
                ),
                SectionContainer(
                  key: contactKey,
                  background: Colors.blueGrey.shade900,
                  child: const ContactSection(),
                ),
                const SectionContainer(
                  background: Colors.black,
                  child: ProfessionalFooter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- SECTION CONTAINER ----------------
class SectionContainer extends StatelessWidget {
  final Widget child;
  final Color background;
  final bool showTopDivider;
  final bool showBottomDivider;

  const SectionContainer({
    super.key,
    required this.child,
    required this.background,
    this.showTopDivider = false,
    this.showBottomDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 600 ? 20.0 : 80.0;

    return Container(
      width: double.infinity,
      color: background,
      child: Column(
        children: [
          if (showTopDivider) const SectionWaveDivider(flip: true),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 60,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: child,
            ),
          ),
          if (showBottomDivider)
            const SectionWaveDivider(
              flip: true,
            ),
        ],
      ),
    );
  }
}

/// ---------------- WAVE DIVIDER ----------------
class SectionWaveDivider extends StatelessWidget {
  final bool flip;
  const SectionWaveDivider({super.key, this.flip = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Transform(
        alignment: Alignment.center,
        transform: flip ? Matrix4.rotationX(3.1416) : Matrix4.identity(),
        child: CustomPaint(painter: _WavePainter()),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..lineTo(0, size.height * .6)
      ..quadraticBezierTo(
        size.width / 2,
        size.height * 10,
        size.width,
        size.height * 0.5,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
