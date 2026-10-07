import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

/// The five destinations shown in the bottom bar.
enum NavTab { home, favorites, create, search, profile }

/// App-wide bottom navigation bar.
///
/// The centre "create" tab is rendered as a raised green FAB that floats above
/// the bar, matching the mockups. All styling is drawn from the design system.
///
/// Usage:
/// ```dart
/// BottomNavBar(
///   currentTab: _tab,
///   onTabSelected: (tab) => setState(() => _tab = tab),
/// )
/// ```
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  final NavTab currentTab;
  final ValueChanged<NavTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isSelected: currentTab == NavTab.home,
                onTap: () => onTabSelected(NavTab.home),
              ),
              _NavItem(
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                label: 'Favorites',
                isSelected: currentTab == NavTab.favorites,
                onTap: () => onTabSelected(NavTab.favorites),
              ),
              _CreateButton(
                onTap: () => onTabSelected(NavTab.create),
              ),
              _NavItem(
                icon: Icons.search,
                activeIcon: Icons.search,
                label: 'Search',
                isSelected: currentTab == NavTab.search,
                onTap: () => onTabSelected(NavTab.search),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isSelected: currentTab == NavTab.profile,
                onTap: () => onTabSelected(NavTab.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.slateMuted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.sageTint,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppFonts.labelSm(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

/// The raised green "+" button in the centre of the nav bar.
class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.brandEmerald,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandEmerald.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
