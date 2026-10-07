import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';

/// Material-3-style segmented tab bar.
///
/// The active tab gets an elevated white card look; inactive tabs are flat.
/// Used on Profile (My Posts / Drafts) and Author Profile (Articles / About).
///
/// Usage:
/// ```dart
/// SegmentedTabs(
///   tabs: ['My Posts', 'Drafts'],
///   icons: [Icons.article, Icons.edit_note],
///   selectedIndex: _selectedIndex,
///   onTabChanged: (index) => setState(() => _selectedIndex = index),
///   badgeCounts: {1: 3}, // optional badge on Drafts tab
/// )
/// ```
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.icons,
    this.badgeCounts,
  });

  /// Tab labels.
  final List<String> tabs;

  /// Current selected tab index.
  final int selectedIndex;

  /// Called when a tab is tapped.
  final ValueChanged<int> onTabChanged;

  /// Optional leading icons for each tab. Length must match [tabs].
  final List<IconData>? icons;

  /// Optional badge count per tab index (e.g. `{1: 3}` → 3 on index 1).
  final Map<int, int>? badgeCounts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = i == selectedIndex;
          final badge = badgeCounts?[i];

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.surfaceContainerLowest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isActive
                      ? const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icons != null && icons!.length > i) ...[
                      Icon(
                        icons![i],
                        size: 18,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      tabs[i],
                      style: AppFonts.labelMd(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (badge != null && badge > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$badge',
                            style: AppFonts.labelSm(
                              color: AppColors.onSecondaryContainer,
                            ).copyWith(fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
