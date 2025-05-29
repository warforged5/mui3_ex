library material3_expressive;

// App Bars
export 'app_bar/expressivesearchappbar.dart';
export 'app_bar/expressivesmallappbar.dart';
export 'app_bar/expressivemediumappbar.dart';
export 'app_bar/expressivelargeappbar.dart';
export 'app_bar/ExpressiveTwoRowsAppBar.dart';
export 'app_bar/expressiveappbarmotion.dart';
export 'app_bar/expressiveappbardefaults.dart';

// Button Groups
export 'button_groups/expressive_standard_button_group.dart';
export 'button_groups/expressive_connected_button_group.dart';
export 'button_groups/button_group_enums.dart';
export 'button_groups/button_group_child.dart';

// Motion System
export 'motion/expressive_motion.dart';

// Themes and Colors
export 'theme/expressive_theme.dart';

// lib/src/app_bars/expressive_search_app_bar.dart
import 'package:flutter/material.dart';

/// Material 3 Expressive Search App Bar
/// Features a centered title with optional leading and trailing actions
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
