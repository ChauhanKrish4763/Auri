import 'package:auri_app/features/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // NOW using colors ONLY from your NEW AppColors palette!
    final Color backgroundColor = AppColors.snowWhite;           // Clean background
    final Color accentColor = AppColors.vibrantBlue;            // Duolingo blue
    final Color textColor = AppColors.charcoalGray;             // Dark readable text
    final Color iconHighlight = AppColors.sunnyYellow;          // Bright yellow highlights
    final Color cardColor = AppColors.cloudGray;                // Light card background

    // Menu items using NEW colors from AppColors
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Pictograms', 'icon': Icons.image_rounded, 'color': AppColors.vibrantBlue, 'onTap': () { Navigator.pushNamed(context, '/home'); }},
      {'title': 'Games', 'icon': Icons.games_rounded, 'color': AppColors.friendlyGreen, 'onTap': () { Navigator.pushNamed(context, '/games'); }},
      {'title': 'Learn', 'icon': Icons.book_rounded, 'color': AppColors.warmOrange, 'onTap': () { Navigator.pushNamed(context, '/learn'); }},
      {'title': 'Scanner', 'icon': Icons.qr_code, 'color': AppColors.playfulPurple, 'onTap': () { Navigator.pushNamed(context, '/friends'); }},
      {'title': 'Settings', 'icon': Icons.settings_rounded, 'color': AppColors.coralPink, 'onTap': () { Navigator.pushNamed(context, '/settings'); }},
    ];

    return Drawer(
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header with vibrant gradient using NEW colors
          Container(
            height: 240,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.vibrantBlue,                        // NEW vibrant blue
                  AppColors.playfulPurple,                      // NEW playful purple
                ],
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.pureWhite,                 // NEW pure white
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepGray.withOpacity(0.3),  // NEW deep gray
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 72,
                    color: AppColors.sunnyYellow,               // NEW sunny yellow
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Hello, Adventurer!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,                // NEW pure white
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu items with individual NEW colors
          ...menuItems.asMap().entries.map((entry) {
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,                   // NEW card white
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: item['color'].withOpacity(0.4),      // Colored border
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: item['color'].withOpacity(0.15),   // Colored shadow
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item['color'].withOpacity(0.15),   // Colored icon background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item['icon'], 
                      size: 28, 
                      color: item['color'],                     // NEW colors for each icon
                    ),
                  ),
                  title: Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor,                         // NEW charcoal gray text
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: item['color'].withOpacity(0.6),      // Colored arrows
                    size: 16,
                  ),
                  onTap: item['onTap'],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, 
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            );
          }),
          
          // Rainbow bottom accent using NEW colors
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(
                  colors: [
                    AppColors.coralPink,                        // NEW coral pink
                    AppColors.warmOrange,                       // NEW warm orange
                    AppColors.sunnyYellow,                      // NEW sunny yellow
                    AppColors.friendlyGreen,                    // NEW friendly green
                    AppColors.vibrantBlue,                      // NEW vibrant blue
                    AppColors.playfulPurple,                    // NEW playful purple
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
