import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jeetendra_portfolio/admin/blogs/model/blog_model.dart';
import 'package:jeetendra_portfolio/configs/app_fonts.dart';
import 'package:jeetendra_portfolio/configs/theme_config.dart';
import 'package:jeetendra_portfolio/views/widgets/navigation_bar/navigation_bar.dart';

class BlogDetailsPage extends StatelessWidget {
  final BlogModel blog;

  const BlogDetailsPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppBreakpoints.tablet;
    final horizontalPadding = isMobile ? 24.0 : size.width * 0.2;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.darkBackground,
        title: MyNavigationBar(
          onHomeTap: () => Navigator.pop(context),
          onAboutTap: () => Navigator.pop(context),
          onSkillsTap: () => Navigator.pop(context),
          onProjectsTap: () => Navigator.pop(context),
          onExperienceTap: () => Navigator.pop(context),
          onBlogTap: () => Navigator.pop(context),
          onContactTap: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// --- HERO IMAGE ---
            Hero(
              tag: 'blog_image_${blog.id}',
              child: CachedNetworkImage(
                imageUrl: blog.imageUrl,
                width: double.infinity,
                height: isMobile ? 350 : 550,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(color: AppTheme.darkSurface),
              ),
            ),

            /// --- BLOG CONTENT AREA ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 60,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// --- Metadata Row ---
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                        ),
                        child: Text(
                          blog.tags.isNotEmpty ? blog.tags.first.toUpperCase() : "ARTICLE",
                          style: AppFonts.inter(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(blog.date),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  /// --- Title ---
                  Text(
                    blog.title,
                    style: AppFonts.rowdies(
                      fontSize: isMobile ? 30: 40,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 40),
                  const Divider(color: Colors.white24, height: 2),
                  const SizedBox(height: 40),

                  /// --- Post Description (Lead) ---
                  Text(
                    blog.description,
                    style: AppFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// --- Main Body Content ---
                  Text(
                    blog.content,
                    style: AppFonts.inter(
                      fontSize: 19,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.9,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 80),

                  /// --- Clean Bottom CTA ---
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, size: 20),
                      label: const Text("Back to Portfolio"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                        side: const BorderSide(color: Colors.white24),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}