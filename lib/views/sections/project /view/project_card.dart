import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/projects/model/project_model.dart';
import 'package:jeetendra_portfolio/constants/assets_const.dart';
import 'package:jeetendra_portfolio/utils/url_launcher.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        // padding: EdgeInsets.symmetric(vertical: 32),
        transform: hovered ? (Matrix4.identity()..translate(0, -12)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xfff5f6f8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: hovered ? 40 : 25, offset: const Offset(0, 25))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HERO SECTION =================
              Container(
                height: 220,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xfff5f6f8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white),
                ),
                child: project.bannerImage.isNotEmpty ? Image.memory(base64Decode(project.bannerImage), fit: BoxFit.fill) : Container(color: Colors.grey.shade200, child: const Icon(Icons.image, size: 32)),
              ),
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Image.memory(base64Decode(project.icon)),
                ),
                title: Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Row(
                  children: [
                    Text("Live on : ", style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 14),
                    Image.asset(AssetsConst.webSite, height: 15, width: 15,),
                    const SizedBox(width: 14),
                    Image.asset(AssetsConst.androidIcon, height: 15, width: 15,),
                    const SizedBox(width: 14),
                    Image.asset(AssetsConst.appleIcon, height: 15, width: 15,),
                  ],
                ),
              ),
              Divider(),
              // ================= CONTENT SECTION =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.description,
                      maxLines: 4,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, color: Color(0xff333333)),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 15,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: project.technologies
                            .map(
                              (tech) => tech.isNotEmpty
                                  ? Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.orange, boxShadow: [BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 3, offset: const Offset(2, 3))],),
                                      child: Text(
                                        tech.toUpperCase(),
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                                      ),
                                    )
                                  : SizedBox(),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    _storeWidget(project),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _platformIcon(IconData icon, {Color? color}) {
    return Icon(icon, color: color, size: 20);
  }

  Widget _primaryButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff145c3a),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _outlineButton(String text) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: Color(0xff145c3a)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      child: const Text(
        "GitHub",
        style: TextStyle(color: Color(0xff145c3a), fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _storeWidget(ProjectModel project) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (project.playStoreUrl.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  urlLauncher(url:project.playStoreUrl);
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.5), blurRadius: 5, offset: const Offset(2, 3))],
                  ),
                  child: Image.asset(AssetsConst.playStoreLogo, height: 50, width: 150),
                ),
              ),
              SizedBox(width: 20),
              Image.asset(AssetsConst.storeQR, height: 50, width: 50),
            ],
          ),
        SizedBox(height: 12),
        if (project.appStoreUrl.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  urlLauncher(url:project.appStoreUrl);
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.5), blurRadius: 5, offset: const Offset(2, 3))],
                  ),
                  child: Image.asset(AssetsConst.appStoreLogo, height: 50, width: 150),
                ),
              ),
              SizedBox(width: 20),
              Image.asset(AssetsConst.storeQR, height: 50, width: 50),
            ],
          ),
      ],
    );
  }
}