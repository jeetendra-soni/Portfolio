import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/admin/projects/model/project_model.dart';
import 'package:jeetendra_portfolio/configs/app_fonts.dart';
import 'package:jeetendra_portfolio/constants/assets_const.dart';
import 'package:jeetendra_portfolio/constants/color_const.dart';
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
    final width = MediaQuery.of(context).size.width;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        width: 340,
        duration: const Duration(milliseconds: 250),
        // padding: EdgeInsets.symmetric(vertical: 32),
        transform: hovered ? (Matrix4.identity()..translate(0, -12)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xfff5f6f8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
          boxShadow: [BoxShadow(color: hovered ? AppColor.randomShadowColor(): Colors.black.withOpacity(.25), blurRadius: hovered ? 20 : 10, offset: const Offset(0, 15))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HERO SECTION =================
              Container(
                // height: width < 700 ? 180 : width < 1100 ? 200: 220,
                height: 220,
                width: 340,
                decoration: BoxDecoration(
                  color: const Color(0xfff5f6f8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white),
                ),
                child: project.bannerImage.isNotEmpty ? Image.network(project.bannerImage, fit: BoxFit.fill) : Container(color: Colors.grey.shade200, child: const Icon(Icons.image, size: 32)),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias, // This ensures content stays inside the radius
                  child: project.icon.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: project.icon,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade50,
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.grey, size: 24),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade50,
                      child: const Icon(Icons.image, color: Colors.grey, size: 24),
                    ),
                  )
                      : Container(
                    color: Colors.grey.shade50,
                    child: const Icon(Icons.image, color: Colors.grey, size: 24),
                  ),
                ),
                title: Text(project.title, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: AppFonts.rowdiesFamily,)),
                subtitle: Row(
                  children: [
                    Text("Live on : ", style: const TextStyle(fontSize: 12)),
                    if(project.liveUrl.isNotEmpty)const SizedBox(width: 14),
                    if(project.liveUrl.isNotEmpty)InkWell(onTap: (){urlLauncher(url: project.liveUrl);}, child: Image.asset(AssetsConst.webSite, height: 15, width: 15,)),
                    if(project.playStoreUrl.isNotEmpty)const SizedBox(width: 14),
                    if(project.playStoreUrl.isNotEmpty)InkWell(onTap: (){urlLauncher(url: project.playStoreUrl);}, child: Image.asset(AssetsConst.androidIcon, height: 15, width: 15,)),
                    if(project.appStoreUrl.isNotEmpty)const SizedBox(width: 14),
                    if(project.appStoreUrl.isNotEmpty)InkWell(onTap: (){urlLauncher(url: project.appStoreUrl);}, child: Image.asset(AssetsConst.appleIcon, height: 15, width: 15,)),
                  ],
                ),
              ),
              Divider(
                height: 2,
              ),
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

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
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
                    // SizedBox(
                    //   height: 15,
                    //   child: ListView(
                    //     scrollDirection: Axis.horizontal,
                    //     children: project.technologies
                    //         .map(
                    //           (tech) => tech.isNotEmpty
                    //               ? Container(
                    //                   padding: EdgeInsets.symmetric(horizontal: 5),
                    //                   margin: EdgeInsets.only(right: 8),
                    //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.orange, boxShadow: [BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 3, offset: const Offset(2, 3))],),
                    //                   child: Text(
                    //                     tech.toUpperCase(),
                    //                     style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                    //                   ),
                    //                 )
                    //               : SizedBox(),
                    //         )
                    //         .toList(),
                    //   ),
                    // ),

                    const SizedBox(height: 32),
                    if(project.liveUrl.isNotEmpty)RichText(text: TextSpan(
                      text: "Website link:- ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black,fontFamily: AppFonts.rowdiesFamily,),
                      children: [
                        TextSpan(
                          text: project.liveUrl,
                          style: TextStyle(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold,fontFamily: AppFonts.interFamily,),

                        )
                      ]
                    )),
                    if(project.liveUrl.isNotEmpty)const SizedBox(height: 16),
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

  // Widget _platformIcon(IconData icon, {Color? color}) {
  //   return Icon(icon, color: color, size: 20);
  // }

  // Widget _primaryButton(String text) {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: const Color(0xff145c3a),
  //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //     onPressed: () {},
  //     child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  //   );
  // }
  //
  // Widget _outlineButton(String text) {
  //   return OutlinedButton(
  //     style: OutlinedButton.styleFrom(
  //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //       side: const BorderSide(color: Color(0xff145c3a)),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //     onPressed: () {},
  //     child: const Text(
  //       "GitHub",
  //       style: TextStyle(color: Color(0xff145c3a), fontWeight: FontWeight.w600),
  //     ),
  //   );
  // }

  Widget _storeWidget(ProjectModel project) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (project.playStoreUrl.isNotEmpty)
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
        if (project.appStoreUrl.isNotEmpty)
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
      ],
    );
  }

  // Widget _storeWidget(ProjectModel project) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       if (project.playStoreUrl.isNotEmpty)
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             GestureDetector(
  //               onTap: (){
  //                 urlLauncher(url:project.playStoreUrl);
  //               },
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(.5), blurRadius: 5, offset: const Offset(2, 3))],
  //                 ),
  //                 child: Image.asset(AssetsConst.playStoreLogo, height: 50, width: 150),
  //               ),
  //             ),
  //             SizedBox(width: 20),
  //             Image.asset(AssetsConst.storeQR, height: 50, width: 50),
  //           ],
  //         ),
  //       SizedBox(height: 12),
  //       if (project.appStoreUrl.isNotEmpty)
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             GestureDetector(
  //               onTap: (){
  //                 urlLauncher(url:project.appStoreUrl);
  //               },
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(.5), blurRadius: 5, offset: const Offset(2, 3))],
  //                 ),
  //                 child: Image.asset(AssetsConst.appStoreLogo, height: 50, width: 150),
  //               ),
  //             ),
  //             SizedBox(width: 20),
  //             Image.asset(AssetsConst.storeQR, height: 50, width: 50),
  //           ],
  //         ),
  //     ],
  //   );
  // }
}