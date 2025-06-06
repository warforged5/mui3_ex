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
    this.titleHorizontalAlignment = TextAlign.start,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.collapsedHeight = 64.0,
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
  final TextAlign titleHorizontalAlignment;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double collapsedHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AppBar(
      title: _buildTitle(theme, colorScheme),
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      shape: shape,
      centerTitle: titleHorizontalAlignment == TextAlign.center,
      titleSpacing: titleSpacing ?? (leading != null ? 0 : 16),
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: collapsedHeight,
    );
  }

  Widget _buildTitle(ThemeData theme, ColorScheme colorScheme) {
    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 22.0,
      letterSpacing: 0,
      height: 1.2,
      color: foregroundColor ?? colorScheme.onSurface,
    );

    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      letterSpacing: 0.25,
      height: 1.4,
      color: (foregroundColor ?? colorScheme.onSurface).withOpacity(0.7),
    );

    if (subtitle == null) {
      return Align(
        alignment: titleHorizontalAlignment == TextAlign.center 
          ? Alignment.center 
          : Alignment.centerLeft,
        child: Text(title, style: titleStyle),
      );
    }

    return Align(
      alignment: titleHorizontalAlignment == TextAlign.center 
        ? Alignment.center 
        : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: titleHorizontalAlignment == TextAlign.center 
          ? CrossAxisAlignment.center 
          : CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          Text(subtitle!, style: subtitleStyle),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(collapsedHeight);
}