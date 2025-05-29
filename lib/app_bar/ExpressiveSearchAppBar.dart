import 'package:flutter/material.dart';
class ExpressiveSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExpressiveSearchAppBar({
    Key? key,
    this.searchHint = 'Search',
    this.searchIcon,
    this.onSearchTap,
    this.onSearchChanged,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.surfaceTintColor,
    this.shadowColor,
    this.shape,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.expandedHeight = 64.0,
  }) : super(key: key);

  final String searchHint;
  final Widget? searchIcon; // Optional/customizable icon
  final VoidCallback? onSearchTap;
  final ValueChanged<String>? onSearchChanged;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Color? surfaceTintColor;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double expandedHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AppBar(
      title: _buildSearchField(context, theme, colorScheme),
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      shape: shape,
      centerTitle: true,
      titleSpacing: titleSpacing ?? 16,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: expandedHeight,
    );
  }

  Widget _buildSearchField(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      height: 48, // Thicker than before (was 40)
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(28),
        // Removed border completely
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSearchTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Adjusted for thicker field
            child: Row(
              children: [
                // Optional/customizable search icon
                if (searchIcon != null) ...[
                  searchIcon!,
                  const SizedBox(width: 12),
                ] else if (searchIcon == null) ...[
                  // Default search icon if none provided
                  Icon(
                    Icons.search,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: onSearchChanged != null
                      ? TextField(
                          onChanged: onSearchChanged,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: searchHint,
                            hintStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )
                      : Text(
                          searchHint,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(expandedHeight);
}