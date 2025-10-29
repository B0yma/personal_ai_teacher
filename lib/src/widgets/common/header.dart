import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/models/user_progress.dart';
import 'package:personal_ai_teacher/src/utils/app_icons.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final UserProgress userProgress;
  final String? courseTitle;
  final bool showBackButton;

  const Header({
    super.key,
    required this.userProgress,
    this.courseTitle,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return AppBar(
      backgroundColor: isDarkMode
          ? const Color.fromRGBO(15, 23, 42, 0.8) // slate-900/80
          : const Color.fromRGBO(248, 250, 252, 0.8), // slate-50/80
      elevation: 1,
      shadowColor: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: isMobile
          ? _buildMobileLayout(context, l10n, isDarkMode)
          : _buildDesktopLayout(context, l10n, isDarkMode),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppLocalizations l10n, bool isDarkMode) {
    return Row(
      children: [
        // Back button
        if (showBackButton && context.canPop())
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          )
        else
          const SizedBox(width: 16), // Left padding if no back button

        // Title
        Expanded(
          child: Text(
            courseTitle ?? l10n.translate('appTitle'),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppTheme.slate100 : AppTheme.slate800,
            ),
          ),
        ),

        // Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStat(
                icon: AppIcons.streak,
                value: userProgress.streak,
                color: AppTheme.orange500,
                isMobile: true,
              ),
              const SizedBox(width: 8),
              _buildStat(
                icon: AppIcons.gem,
                value: userProgress.gems,
                color: AppTheme.sky400,
                isMobile: true,
              ),
              const SizedBox(width: 8),
              _buildStat(
                icon: AppIcons.heart,
                value: userProgress.hearts,
                color: AppTheme.red500,
                isMobile: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AppLocalizations l10n, bool isDarkMode) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Centered Title
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              courseTitle ?? l10n.translate('appTitle'),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppTheme.slate100 : AppTheme.slate800,
              ),
            ),
          ),
        ),
        // Left and Right aligned items
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Back button
            Container(
              width: 60,
              alignment: Alignment.centerLeft,
              child: showBackButton && context.canPop()
                  ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
                  : null,
            ),
            // Right side: Stats
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStat(
                    icon: AppIcons.streak,
                    value: userProgress.streak,
                    color: AppTheme.orange500,
                    isMobile: false,
                  ),
                  const SizedBox(width: 12),
                  _buildStat(
                    icon: AppIcons.gem,
                    value: userProgress.gems,
                    color: AppTheme.sky400,
                    isMobile: false,
                  ),
                  const SizedBox(width: 12),
                  _buildStat(
                    icon: AppIcons.heart,
                    value: userProgress.hearts,
                    color: AppTheme.red500,
                    isMobile: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStat({required IconData icon, required int value, required Color color, required bool isMobile}) {
    return Row(
      children: [
        Icon(icon, color: color, size: isMobile ? 20 : 24),
        const SizedBox(width: 4),
        Text(
          value.toString(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 14 : 16,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}