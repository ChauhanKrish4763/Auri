import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onProfileTap;
  final bool toggleLeadingButton;

  const CustomAppbar({
    super.key,
    required this.title,
    this.onProfileTap,
    this.toggleLeadingButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading:
          false, // Prevents Flutter’s default back button
      leading:
          toggleLeadingButton
              ? IconButton(
                icon: const Icon(
                  Icons.menu,
                ), // Hamburger icon on left when true
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              )
              : IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ), // Back arrow on left when false
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 60,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
