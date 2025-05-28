import 'package:flutter/material.dart';

class ExpressiveSmallAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExpressiveSmallAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.surfaceTintColor,
    this.shadowColor,
    this.shape,
    this.centerTitle = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Color? surfaceTintColor;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final bool centerTitle;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AppBar(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: foregroundColor ?? colorScheme.onSurface,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: (foregroundColor ?? colorScheme.onSurface).withOpacity(0.7),
              ),
            ),
        ],
      ),
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      shape: shape,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}