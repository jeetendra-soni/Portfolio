import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/blogs/model/blog_model.dart';
import 'package:jeetendra_portfolio/admin/blogs/repository/blog_repository.dart';
import 'package:jeetendra_portfolio/views/sections/blogs/blog_details_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final BlogRepository repository = BlogRepository();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Latest Blog Posts",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.deepOrangeAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 40),
        StreamBuilder<List<BlogModel>>(
          stream: repository.getBlogs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final blogs = snapshot.data?.where((b) => b.isPublished).toList() ?? [];
            if (blogs.isEmpty) {
              return const Text("No blogs published yet.");
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 0.85,
              ),
              itemCount: blogs.length,
              itemBuilder: (context, index) => _BlogCard(blog: blogs[index], index: index),
            );
          },
        ),
      ],
    );
  }
}

class _BlogCard extends StatefulWidget {
  final BlogModel blog;
  final int index;
  const _BlogCard({required this.blog, required this.index});

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600 + (widget.index * 100)),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: _isHovered ? (Matrix4.identity()..translate(0, -10, 0)) : Matrix4.identity(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _isHovered ? Colors.black.withOpacity(0.15) : Colors.black.withOpacity(0.05),
                  blurRadius: _isHovered ? 30 : 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogDetailsPage(blog: widget.blog),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'blog_image_${widget.blog.id}',
                            child: CachedNetworkImage(
                              imageUrl: widget.blog.imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[100]),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[100],
                                child: const Icon(Icons.error_outline),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _isHovered ? 0.3 : 0.0,
                            child: Container(color: Colors.black),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepOrangeAccent.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                DateFormat('MMM dd').format(widget.blog.date),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              children: widget.blog.tags.take(2).map((tag) => Text(
                                "#$tag",
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              )).toList(),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.blog.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.blog.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    color: _isHovered ? Colors.deepOrangeAccent : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  child: const Row(
                                    children: [
                                      Text("Read More"),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_forward, size: 16),
                                    ],
                                  ),
                                ),
                                if (widget.blog.link.isNotEmpty)
                                  IconButton(
                                    onPressed: () => _launchURL(widget.blog.link),
                                    icon: const Icon(Icons.open_in_new, size: 18, color: Colors.grey),
                                    tooltip: "Open External Link",
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}