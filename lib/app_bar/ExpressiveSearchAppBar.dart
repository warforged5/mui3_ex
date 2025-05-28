import 'package:flutter/material.dart';

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
      titleTextStyle: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: foregroundColor ?? colorScheme.onSurface,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}