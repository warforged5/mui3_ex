import 'package:flutter/material.dart';
import '../motion/expressive_motion.dart';

/// Material 3 Expressive Search App Bar (TopAppBar equivalent)
/// Features centered title with enhanced typography and smooth animations
class ExpressiveSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExpressiveSearchAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.surfaceTintColor,
    this.shadowColor,
    this.shape,
    this.centerTitle = true,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.expandedHeight = 64.0,
  }) : super(key: key);

  final Widget? title;
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
  final double expandedHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AppBar(
      title: title,
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
      toolbarHeight: expandedHeight,
      titleTextStyle: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        letterSpacing: 0.1,
        color: foregroundColor ?? colorScheme.onSurface,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(expandedHeight);
}