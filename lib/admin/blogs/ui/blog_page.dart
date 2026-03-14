import 'package:flutter/material.dart';
import '../model/blog_model.dart';
import '../repository/blog_repository.dart';
import 'blog_dialog.dart';
import 'blog_tile.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final BlogRepository _repository = BlogRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Manage Blogs", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBlogDialog(),
        label: const Text("Add Blog"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: StreamBuilder<List<BlogModel>>(
        stream: _repository.getBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final blogs = snapshot.data ?? [];
          if (blogs.isEmpty) {
            return const Center(child: Text("No blogs added yet."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              return BlogTile(
                blog: blogs[index],
                onEdit: () => _showBlogDialog(blog: blogs[index]),
                onDelete: () => _deleteBlog(blogs[index].id),
              );
            },
          );
        },
      ),
    );
  }

  void _showBlogDialog({BlogModel? blog}) {
    showDialog(
      context: context,
      builder: (context) => BlogDialog(
        blog: blog,
        onSave: (newBlog) async {
          if (blog == null) {
            await _repository.addBlog(newBlog);
          } else {
            await _repository.updateBlog(newBlog);
          }
        },
      ),
    );
  }

  void _deleteBlog(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Blog"),
        content: const Text("Are you sure you want to delete this blog?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await _repository.deleteBlog(id);
    }
  }
}