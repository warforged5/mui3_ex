import 'package:flutter/material.dart';

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
      title: null, // We'll handle title positioning manually
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
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          final deltaExtent = settings?.maxExtent != null && settings?.minExtent != null
              ? settings!.maxExtent - settings.minExtent
              : 0.0;
          final t = settings?.currentExtent != null && deltaExtent > 0
              ? (1.0 - (settings!.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0)
              : 0.0;

          return _buildFlexibleContent(context, theme, colorScheme, t);
        },
      ),
    );
  }

  Widget _buildFlexibleContent(BuildContext context, ThemeData theme, ColorScheme colorScheme, double t) {
    // Ultra-smooth animation curves for hero moments
    final expandedTitleOpacity = Curves.easeInOutCubicEmphasized.transform(1.0 - t);
    final collapsedTitleOpacity = Curves.easeInOutCubicEmphasized.transform(t);
    final titleScale = Tween(begin: 1.0, end: 0.75).transform(Curves.easeOutCubic.transform(t));
    final titleOffset = Tween(begin: 0.0, end: -12.0).transform(Curves.easeOutQuart.transform(t));
    final subtitleOpacity = Curves.easeOutQuart.transform(1.0 - (t * 1.2).clamp(0.0, 1.0));

    // Larger font size range for hero moments with smooth interpolation
    final titleFontSize = Tween(begin: 36.0, end: 22.0).transform(
      Curves.easeInOutCubicEmphasized.transform(t)
    );

    final expandedTitleStyle = theme.textTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.w700, // Heavier weight for emotional impact
      fontSize: titleFontSize,
      letterSpacing: -0.5,
      height: 1.1,
      color: foregroundColor ?? colorScheme.onSurface,
    );

    final collapsedTitleStyle = theme.textTheme.headlineSmall?.copyWith(
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

    return Stack(
      children: [
        // Collapsed title in toolbar area (when t > 0.3)
        if (t > 0.3)
          Positioned(
            left: leading != null ? 72.0 : 16.0,
            right: actions != null && actions!.isNotEmpty ? 72.0 : 16.0,
            top: 0,
            bottom: 0,
            child: Opacity(
              opacity: collapsedTitleOpacity,
              child: Center(
                child: Align(
                  alignment: titleHorizontalAlignment == TextAlign.center 
                      ? Alignment.center 
                      : Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: titleHorizontalAlignment == TextAlign.center 
                        ? CrossAxisAlignment.center 
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: collapsedTitleStyle,
                        textAlign: titleHorizontalAlignment,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null && t < 0.6) // Show subtitle when not fully collapsed
                        Text(
                          subtitle!,
                          style: subtitleStyle,
                          textAlign: titleHorizontalAlignment,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        
        // Expanded title below the toolbar area (when t < 0.6)
        if (t < 0.6)
          Positioned(
            left: 16,
            right: 16,
            bottom: 28, // More space for large hero titles
            child: Transform.translate(
              offset: Offset(0, titleOffset),
              child: Transform.scale(
                scale: titleScale,
                alignment: titleHorizontalAlignment == TextAlign.center 
                    ? Alignment.center 
                    : Alignment.centerLeft,
                child: Opacity(
                  opacity: expandedTitleOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: titleHorizontalAlignment == TextAlign.center 
                        ? CrossAxisAlignment.center 
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: expandedTitleStyle,
                        textAlign: titleHorizontalAlignment,
                      ),
                      if (subtitle != null)
                        Opacity(
                          opacity: subtitleOpacity,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              subtitle!,
                              style: subtitleStyle,
                              textAlign: titleHorizontalAlignment,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(expandedHeight);
}