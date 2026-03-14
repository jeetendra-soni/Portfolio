import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeetendra_portfolio/admin/dashboard/admin_dashboard.dart';
import 'package:jeetendra_portfolio/admin/personal_info/model/personal_info_model.dart';
import 'package:jeetendra_portfolio/admin/personal_info/provider/personal_info_provider.dart';
import 'package:jeetendra_portfolio/views/sections/award_achievement/award_achivement.dart';
import 'package:jeetendra_portfolio/views/sections/blogs/blog_section.dart';
import 'package:jeetendra_portfolio/views/sections/project%20/view/project_screen.dart';
import 'package:jeetendra_portfolio/views/widgets/navigation_bar/navigation_bar.dart';
import 'configs/app_fonts.dart';
import 'configs/theme_config.dart';
import 'firebase_options.dart';
import 'views/sections/aboutus/about.dart';
import 'views/sections/contact/contact.dart';
import 'views/sections/experience/experience_screen.dart';
import 'views/sections/hero/hero_section.dart';
import 'views/sections/skills/skill_screen.dart';
import 'views/sections/testimonials/testimonial_section.dart';

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
      title: 'JEETENDRA SONI | Flutter & Dart Expert',
      theme: getResponsiveTheme(context),
      home: const PortfolioPage(),
    );
  }
}

/// ---------------- PAGE ----------------
class PortfolioPage extends ConsumerStatefulWidget {
  const PortfolioPage({super.key});

  @override
  ConsumerState<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends ConsumerState<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Section Keys
  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final experienceKey = GlobalKey();
  final portfolioKey = GlobalKey();
  final blogKey = GlobalKey();
  final contactKey = GlobalKey();

  void scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final viewport = RenderAbstractViewport.of(box);
    final offset = viewport.getOffsetToReveal(box, 0).offset;

    _scrollController.animateTo(
      offset - 80,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 70,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: MyNavigationBar(
            onHomeTap: () => scrollTo(homeKey),
            onAboutTap: () => scrollTo(aboutKey),
            onSkillsTap: () => scrollTo(skillsKey),
            onExperienceTap: () => scrollTo(experienceKey),
            onProjectsTap: () => scrollTo(portfolioKey),
            onBlogTap: () => scrollTo(blogKey),
            onContactTap: () => scrollTo(contactKey),
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
      ),
      drawer: _MobileDrawer(
        onHomeTap: () {
          scrollTo(homeKey);
          Navigator.pop(context);
        },
        onAboutTap: () {
          scrollTo(aboutKey);
          Navigator.pop(context);
        },
        onExperienceTap: () {
          scrollTo(experienceKey);
          Navigator.pop(context);
        },
        onSkillsTap: () {
          scrollTo(skillsKey);
          Navigator.pop(context);
        },
        onProjectsTap: () {
          scrollTo(portfolioKey);
          Navigator.pop(context);
        },
        onBlogTap: () {
          scrollTo(blogKey);
          Navigator.pop(context);
        },
        onContactTap: () {
          scrollTo(contactKey);
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          const SizedBox(height: kTextTabBarHeight),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionContainer(
                      key: homeKey,
                      background: Colors.black,
                      showBottomDivider: false,
                      child: const HeroSection(),
                    ),
                    SectionContainer(
                      key: aboutKey,
                      background: Colors.white,
                      child: const AboutSection(),
                    ),
                    SectionContainer(
                      key: experienceKey,
                      background: Colors.blueGrey.shade50,
                      child: const ExperienceSection(),
                    ),
                    SectionContainer(
                      key: skillsKey,
                      background: Colors.white70,
                      child: const SkillsSection(),
                    ),
                    SectionContainer(
                      key: portfolioKey,
                      background: const Color(0xFFF5F5FF),
                      child: const ProjectsSection(),
                    ),
                    SectionContainer(
                      key: blogKey,
                      background: Colors.white,
                      child: const BlogSection(),
                    ),
                    SectionContainer(
                      key: contactKey,
                      background: Colors.blueGrey.shade900,
                      child: const ContactSection(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onAboutTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onBlogTap;
  final VoidCallback onContactTap;

  const _MobileDrawer({
    required this.onHomeTap,
    required this.onAboutTap,
    required this.onSkillsTap,
    required this.onProjectsTap,
    required this.onBlogTap,
    required this.onContactTap,
    required this.onExperienceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.darkBackground,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkBackground,
              AppTheme.darkSurface.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppTheme.primary, AppTheme.primary],
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 45,
                        backgroundColor: AppTheme.darkBackground,
                        child: Text(
                          "JS",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "JEETENDRA SONI",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        letterSpacing: 1.1,
                        fontFamily: AppFonts.rowdiesFamily,
                      ),
                    ),
                    const Text(
                      "Mobile App Developer",
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10, indent: 30, endIndent: 30),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _DrawerItem(icon: Icons.home_rounded, title: "Home", onTap: onHomeTap),
                    _DrawerItem(icon: Icons.person_rounded, title: "About", onTap: onAboutTap),
                    _DrawerItem(icon: Icons.history_edu_rounded, title: "Experience", onTap: onExperienceTap),
                    _DrawerItem(icon: Icons.settings_suggest_rounded, title: "Skills", onTap: onSkillsTap),
                    _DrawerItem(icon: Icons.rocket_launch_rounded, title: "Projects", onTap: onProjectsTap),
                    _DrawerItem(icon: Icons.article_rounded, title: "Blogs", onTap: onBlogTap),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: ElevatedButton(
                  onPressed: onContactTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Hire Me", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}

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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 60),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: child,
          ),
        ),
      ),
    );
  }
}