import 'package:flutter/material.dart';
import 'package:hikup/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  const CustomAppBar({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: kTextTabBarHeight,
      title: Text(
        label,
        style: titleTextStyleWhite,
      ),
      iconTheme: const IconThemeData(
        color: GreenPrimary, // Couleur de la flèche retour
      ),
      backgroundColor: BlackPrimary,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kTextTabBarHeight);
  }
}
