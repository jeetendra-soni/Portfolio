import 'package:flutter/material.dart';
import 'package:jeetendra_portfolio/constants/assets_const.dart';

class NavBarLogo extends StatelessWidget {
  const NavBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 100,
      child: Image.asset(AssetsConst.indFlag),
    );
  }
}
