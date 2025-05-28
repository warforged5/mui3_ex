import 'package:flutter/material.dart';

class ExpressiveMediumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExpressiveMediumAppBar({
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
    this.expandedHeight = 112.0,
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
  final double expandedHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SliverAppBar(
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
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: leading != null ? 72.0 : 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
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
        collapseMode: CollapseMode.pin,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(expandedHeight);
}