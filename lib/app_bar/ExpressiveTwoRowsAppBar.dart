import 'package:flutter/material.dart';

class ExpressiveTwoRowsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExpressiveTwoRowsAppBar({
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
    this.collapsedHeight = 64.0,
    this.expandedHeight = 112.0,
    this.expandedTitleBuilder,
    this.collapsedTitleBuilder,
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
  final double collapsedHeight;
  final double expandedHeight;
  final Widget Function(String title, String? subtitle, bool expanded)? expandedTitleBuilder;
  final Widget Function(String title, String? subtitle, bool expanded)? collapsedTitleBuilder;

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
      titleSpacing: titleSpacing,
      collapsedHeight: collapsedHeight,
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: leading != null ? 72.0 : 16.0,
          right: actions != null ? 16.0 : 16.0,
          bottom: 16.0,
        ),
        title: _buildCustomTitle(theme, colorScheme),
        collapseMode: CollapseMode.pin,
      ),
    );
  }

  Widget _buildCustomTitle(ThemeData theme, ColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final collapseRatio = settings?.currentExtent != null && settings?.maxExtent != null
          ? 1 - (settings!.currentExtent - settings.minExtent) / (settings.maxExtent - settings.minExtent)
          : 0.0;

        final isExpanded = collapseRatio < 0.5;

        if (isExpanded && expandedTitleBuilder != null) {
          return expandedTitleBuilder!(title, subtitle, true);
        } else if (!isExpanded && collapsedTitleBuilder != null) {
          return collapsedTitleBuilder!(title, subtitle, false);
        }

        // Default implementation
        return _buildDefaultTitle(theme, colorScheme, isExpanded);
      },
    );
  }

  Widget _buildDefaultTitle(ThemeData theme, ColorScheme colorScheme, bool isExpanded) {
    final titleStyle = theme.textTheme.headlineMedium?.copyWith(
      fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w500,
      fontSize: isExpanded ? 28.0 : 22.0,
      letterSpacing: isExpanded ? -0.25 : 0,
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
          if (isExpanded) Text(subtitle!, style: subtitleStyle),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(expandedHeight);
}