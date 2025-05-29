import 'package:flutter/material.dart';
import '../motion/expressive_motion.dart';

class ExpressiveLargeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExpressiveLargeAppBar({
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
    this.expandedHeight = 152.0,
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
          bottom: 28.0, // More space for large titles
        ),
        title: _buildFlexibleTitle(theme, colorScheme),
        collapseMode: CollapseMode.pin,
      ),
    );
  }

  Widget _buildFlexibleTitle(ThemeData theme, ColorScheme colorScheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate collapse ratio based on available height
        final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final collapseRatio = settings?.currentExtent != null && settings?.maxExtent != null
          ? 1 - (settings!.currentExtent - settings.minExtent) / (settings.maxExtent - settings.minExtent)
          : 0.0;

        // Interpolate font sizes based on collapse ratio (larger range for hero moments)
        final titleFontSize = Tween(begin: 36.0, end: 22.0).transform(collapseRatio.clamp(0.0, 1.0));
        final subtitleOpacity = Tween(begin: 1.0, end: 0.0).transform(collapseRatio.clamp(0.0, 1.0));

        final titleStyle = theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700, // Heavier weight for emotional impact
          fontSize: titleFontSize,
          letterSpacing: -0.5,
          height: 1.1,
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
              AnimatedOpacity(
                opacity: subtitleOpacity,
                duration: ExpressiveMotion.defaultEffects,
                curve: ExpressiveMotion.effectsSpring,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(subtitle!, style: subtitleStyle),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(expandedHeight);
}