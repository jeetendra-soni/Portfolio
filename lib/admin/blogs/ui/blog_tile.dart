import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/blog_model.dart';

class BlogTile extends StatelessWidget {
  final BlogModel blog;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BlogTile({
    super.key,
    required this.blog,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Image Section ---
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey.shade200),
              ),
              clipBehavior: Clip.antiAlias,
              child: blog.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: blog.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey),
                    )
                  : const Icon(Icons.image, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            
            /// --- Content Section ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    blog.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('MMM dd, yyyy').format(blog.date),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// --- Actions ---
            Column(
              children: [
                IconButton(
                  onPressed: onEdit, 
                  icon: const Icon(Icons.edit_note_rounded, color: Colors.blueAccent),
                  tooltip: "Edit",
                ),
                IconButton(
                  onPressed: onDelete, 
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  tooltip: "Delete",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}