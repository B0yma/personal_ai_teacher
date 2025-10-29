import 'package:flutter/material.dart';
import 'package:personal_ai_teacher/src/localization/app_localizations.dart';
import 'package:personal_ai_teacher/src/utils/app_icons.dart';
import 'package:personal_ai_teacher/src/utils/app_theme.dart';

class NotificationToast extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClick;
  final VoidCallback onClose;

  const NotificationToast({
    super.key,
    required this.isVisible,
    required this.onClick,
    required this.onClose,
  });

  @override
  State<NotificationToast> createState() => _NotificationToastState();
}

class _NotificationToastState extends State<NotificationToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -2.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(covariant NotificationToast oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _offsetAnimation,
      child: SafeArea(
        child: GestureDetector(
          onTap: widget.onClick,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.slate800 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
              border: Border.all(color: isDarkMode ? AppTheme.slate700 : AppTheme.slate200),
            ),
            child: Row(
              children: [
                const Icon(AppIcons.star, color: AppTheme.purple500, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.translate('notificationText'),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  icon: const Icon(AppIcons.close, color: AppTheme.slate400),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}