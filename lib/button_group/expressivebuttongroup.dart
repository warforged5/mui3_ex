import 'package:flutter/material.dart';


/// Button Group Size enumeration
enum ButtonGroupSize {
  extraSmall,
  small,
  medium,
  large,
  extraLarge,
}

/// Button Group Shape enumeration  
enum ButtonGroupShape {
  round,
  square,
}

/// Selection mode for button groups
enum ButtonGroupSelectionMode {
  singleSelect,
  multiSelect,
  selectionRequired,
}

/// Material 3 Expressive Button Group (equivalent to Android ButtonGroup)
/// Features DSL-style API with interactive width animations and overflow handling
class ExpressiveButtonGroup extends StatefulWidget {
  const ExpressiveButtonGroup({
    Key? key,
    required this.builder,
    this.expandedRatio = 0.15,
    this.horizontalArrangement = MainAxisAlignment.start,
    this.spacing = 8.0,
    this.overflow,
  }) : super(key: key);

  // Fix: Change to void function instead of Widget Function
  final void Function(ButtonGroupScope scope) builder;
  final double expandedRatio;
  final MainAxisAlignment horizontalArrangement;
  final double spacing;
  final Widget Function(ButtonGroupMenuState menuState)? overflow;

  @override
  State<ExpressiveButtonGroup> createState() => _ExpressiveButtonGroupState();
}

class _ExpressiveButtonGroupState extends State<ExpressiveButtonGroup>
    with TickerProviderStateMixin {
  late ButtonGroupScope _scope;
  ButtonGroupMenuState? _menuState;

  @override
  void initState() {
    super.initState();
    _scope = ButtonGroupScope._internal(
      expandedRatio: widget.expandedRatio,
      tickerProvider: this,
    );
    if (widget.overflow != null) {
      _menuState = ButtonGroupMenuState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Clear previous items
        _scope._clearItems();
        
        // Build items using the scope (no return value needed)
        widget.builder(_scope);
        
        final items = List<ButtonGroupItem>.from(_scope._items);

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return _ButtonGroupLayout(
          items: items,
          expandedRatio: widget.expandedRatio,
          horizontalArrangement: widget.horizontalArrangement,
          spacing: widget.spacing,
          constraints: constraints,
          overflow: widget.overflow,
          menuState: _menuState,
        );
      },
    );
  }
}

/// Scope for building button group content with DSL-style API
class ButtonGroupScope {
  ButtonGroupScope._internal({
    required this.expandedRatio,
    required this.tickerProvider,
  });

  final double expandedRatio;
  final TickerProvider tickerProvider;
  final List<ButtonGroupItem> _items = [];

  void _clearItems() => _items.clear();

  /// Adds a clickable item to the button group
  void clickableItem({
    required VoidCallback onPressed,
    required String label,
    Widget? icon,
    double weight = 0.0,
    bool enabled = true,
  }) {
    _items.add(
      ButtonGroupItem._clickable(
        onPressed: onPressed,
        label: label,
        icon: icon,
        weight: weight,
        enabled: enabled,
        expandedRatio: expandedRatio,
        tickerProvider: tickerProvider,
      ),
    );
  }

  /// Adds a toggleable item to the button group
  void toggleableItem({
    required bool checked,
    required ValueChanged<bool> onChanged,
    required String label,
    Widget? icon,
    double weight = 0.0,
    bool enabled = true,
  }) {
    _items.add(
      ButtonGroupItem._toggleable(
        checked: checked,
        onChanged: onChanged,
        label: label,
        icon: icon,
        weight: weight,
        enabled: enabled,
        expandedRatio: expandedRatio,
        tickerProvider: tickerProvider,
      ),
    );
  }

  /// Adds a custom item to the button group
  void customItem({
    required Widget Function() buttonGroupContent,
    required Widget Function(ButtonGroupMenuState) menuContent,
    double weight = 0.0,
  }) {
    _items.add(
      ButtonGroupItem._custom(
        buttonGroupContent: buttonGroupContent,
        menuContent: menuContent,
        weight: weight,
        expandedRatio: expandedRatio,
        tickerProvider: tickerProvider,
      ),
    );
  }
}

/// Individual item in a button group
class ButtonGroupItem {
  ButtonGroupItem._({
    required this.buttonGroupContent,
    required this.menuContent,
    required this.weight,
    required this.controller,
    required this.interactionNotifier,
  });

  factory ButtonGroupItem._clickable({
    required VoidCallback onPressed,
    required String label,
    Widget? icon,
    required double weight,
    required bool enabled,
    required double expandedRatio,
    required TickerProvider tickerProvider,
  }) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: tickerProvider,
    );
    final interactionNotifier = ValueNotifier<bool>(false);

    return ButtonGroupItem._(
      buttonGroupContent: () => _ClickableButton(
        onPressed: onPressed,
        label: label,
        icon: icon,
        enabled: enabled,
        controller: controller,
        interactionNotifier: interactionNotifier,
      ),
      menuContent: (menuState) => _MenuItem(
        onPressed: () {
          onPressed();
          menuState.dismiss();
        },
        label: label,
        icon: icon,
        enabled: enabled,
      ),
      weight: weight,
      controller: controller,
      interactionNotifier: interactionNotifier,
    );
  }

  factory ButtonGroupItem._toggleable({
    required bool checked,
    required ValueChanged<bool> onChanged,
    required String label,
    Widget? icon,
    required double weight,
    required bool enabled,
    required double expandedRatio,
    required TickerProvider tickerProvider,
  }) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: tickerProvider,
    );
    final interactionNotifier = ValueNotifier<bool>(false);

    return ButtonGroupItem._(
      buttonGroupContent: () => _ToggleableButton(
        checked: checked,
        onChanged: onChanged,
        label: label,
        icon: icon,
        enabled: enabled,
        controller: controller,
        interactionNotifier: interactionNotifier,
      ),
      menuContent: (menuState) => _MenuItem(
        onPressed: () {
          onChanged(!checked);
          menuState.dismiss();
        },
        label: label,
        icon: icon,
        enabled: enabled,
        trailing: checked ? const Icon(Icons.check) : null,
      ),
      weight: weight,
      controller: controller,
      interactionNotifier: interactionNotifier,
    );
  }

  factory ButtonGroupItem._custom({
    required Widget Function() buttonGroupContent,
    required Widget Function(ButtonGroupMenuState) menuContent,
    required double weight,
    required double expandedRatio,
    required TickerProvider tickerProvider,
  }) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: tickerProvider,
    );
    final interactionNotifier = ValueNotifier<bool>(false);

    return ButtonGroupItem._(
      buttonGroupContent: buttonGroupContent,
      menuContent: menuContent,
      weight: weight,
      controller: controller,
      interactionNotifier: interactionNotifier,
    );
  }

  final Widget Function() buttonGroupContent;
  final Widget Function(ButtonGroupMenuState) menuContent;
  final double weight;
  final AnimationController controller;
  final ValueNotifier<bool> interactionNotifier;
}

/// Layout widget that handles button group arrangement and animations
class _ButtonGroupLayout extends StatefulWidget {
  const _ButtonGroupLayout({
    required this.items,
    required this.expandedRatio,
    required this.horizontalArrangement,
    required this.spacing,
    required this.constraints,
    this.overflow,
    this.menuState,
  });

  final List<ButtonGroupItem> items;
  final double expandedRatio;
  final MainAxisAlignment horizontalArrangement;
  final double spacing;
  final BoxConstraints constraints;
  final Widget Function(ButtonGroupMenuState)? overflow;
  final ButtonGroupMenuState? menuState;

  @override
  State<_ButtonGroupLayout> createState() => _ButtonGroupLayoutState();
}

class _ButtonGroupLayoutState extends State<_ButtonGroupLayout> {
  late List<double> _baseWidths;
  late List<ValueNotifier<double>> _currentWidths;

  @override
  void initState() {
    super.initState();
    _initializeWidths();
    _setupInteractionListeners();
  }

  void _initializeWidths() {
    _baseWidths = List.filled(widget.items.length, 0.0);
    _currentWidths = List.generate(
      widget.items.length,
      (index) => ValueNotifier<double>(0.0),
    );
  }

  void _setupInteractionListeners() {
    for (int i = 0; i < widget.items.length; i++) {
      widget.items[i].interactionNotifier.addListener(() {
        _handleInteraction(i);
      });
    }
  }

  void _handleInteraction(int index) {
    final isPressed = widget.items[index].interactionNotifier.value;
    
    if (isPressed) {
      widget.items[index].controller.forward();
    } else {
      widget.items[index].controller.reverse();
    }

    // Animate width changes with neighbor compression
    _animateWidthChanges(index, isPressed);
  }

  void _animateWidthChanges(int pressedIndex, bool isPressed) {
    if (widget.items.length <= 1) return;

    final growth = widget.items[pressedIndex].controller.value *
        widget.expandedRatio *
        _baseWidths[pressedIndex];

    for (int i = 0; i < widget.items.length; i++) {
      if (i == pressedIndex) {
        // Expand the pressed button
        _currentWidths[i].value = _baseWidths[i] + growth;
      } else if ((i == pressedIndex - 1 || i == pressedIndex + 1)) {
        // Compress adjacent buttons
        final compression = growth / 2;
        _currentWidths[i].value = (_baseWidths[i] - compression).clamp(0.0, double.infinity);
      } else {
        // Keep other buttons at base width
        _currentWidths[i].value = _baseWidths[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate base widths
        _calculateBaseWidths(constraints);

        return Row(
          mainAxisAlignment: widget.horizontalArrangement,
          children: [
            for (int i = 0; i < widget.items.length; i++) ...[
              ValueListenableBuilder<double>(
                valueListenable: _currentWidths[i],
                builder: (context, width, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    width: width > 0 ? width : null,
                    child: widget.items[i].buttonGroupContent(),
                  );
                },
              ),
              if (i < widget.items.length - 1)
                SizedBox(width: widget.spacing),
            ],
            if (widget.overflow != null && widget.menuState != null)
              widget.overflow!(widget.menuState!),
          ],
        );
      },
    );
  }

  void _calculateBaseWidths(BoxConstraints constraints) {
    final totalSpacing = widget.spacing * (widget.items.length - 1);
    final availableWidth = constraints.maxWidth - totalSpacing;
    
    double totalWeight = 0;
    int weightedItems = 0;
    
    for (final item in widget.items) {
      if (item.weight > 0) {
        totalWeight += item.weight;
        weightedItems++;
      }
    }

    if (weightedItems == 0) {
      // Equal distribution
      final itemWidth = availableWidth / widget.items.length;
      for (int i = 0; i < widget.items.length; i++) {
        _baseWidths[i] = itemWidth;
        _currentWidths[i].value = itemWidth;
      }
    } else {
      // Weighted distribution
      final weightUnit = availableWidth / totalWeight;
      for (int i = 0; i < widget.items.length; i++) {
        final width = widget.items[i].weight > 0
            ? widget.items[i].weight * weightUnit
            : availableWidth / widget.items.length; // fallback
        _baseWidths[i] = width;
        _currentWidths[i].value = width;
      }
    }
  }

  @override
  void dispose() {
    for (final notifier in _currentWidths) {
      notifier.dispose();
    }
    super.dispose();
  }
}

/// State for button group overflow menu
class ButtonGroupMenuState {
  ButtonGroupMenuState({bool initialIsExpanded = false})
      : _isExpanded = ValueNotifier(initialIsExpanded);

  final ValueNotifier<bool> _isExpanded;

  bool get isExpanded => _isExpanded.value;

  void show() => _isExpanded.value = true;
  void dismiss() => _isExpanded.value = false;

  void dispose() => _isExpanded.dispose();
}

/// Clickable button for button groups
class _ClickableButton extends StatefulWidget {
  const _ClickableButton({
    required this.onPressed,
    required this.label,
    this.icon,
    required this.enabled,
    required this.controller,
    required this.interactionNotifier,
  });

  final VoidCallback onPressed;
  final String label;
  final Widget? icon;
  final bool enabled;
  final AnimationController controller;
  final ValueNotifier<bool> interactionNotifier;

  @override
  State<_ClickableButton> createState() => _ClickableButtonState();
}

class _ClickableButtonState extends State<_ClickableButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => widget.interactionNotifier.value = true,
      onTapUp: (_) => widget.interactionNotifier.value = false,
      onTapCancel: () => widget.interactionNotifier.value = false,
      child: ElevatedButton(
        onPressed: widget.enabled ? widget.onPressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              const SizedBox(width: 8),
            ],
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}

/// Toggleable button for button groups
class _ToggleableButton extends StatefulWidget {
  const _ToggleableButton({
    required this.checked,
    required this.onChanged,
    required this.label,
    this.icon,
    required this.enabled,
    required this.controller,
    required this.interactionNotifier,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final String label;
  final Widget? icon;
  final bool enabled;
  final AnimationController controller;
  final ValueNotifier<bool> interactionNotifier;

  @override
  State<_ToggleableButton> createState() => _ToggleableButtonState();
}

class _ToggleableButtonState extends State<_ToggleableButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTapDown: (_) => widget.interactionNotifier.value = true,
      onTapUp: (_) => widget.interactionNotifier.value = false,
      onTapCancel: () => widget.interactionNotifier.value = false,
      child: ElevatedButton(
        onPressed: widget.enabled ? () => widget.onChanged(!widget.checked) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.checked 
              ? colorScheme.secondaryContainer
              : colorScheme.surface,
          foregroundColor: widget.checked
              ? colorScheme.onSecondaryContainer
              : colorScheme.onSurface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              const SizedBox(width: 8),
            ],
            Text(widget.label),
            if (widget.checked) ...[
              const SizedBox(width: 8),
              Icon(Icons.check, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}

/// Menu item for overflow menu
class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.onPressed,
    required this.label,
    this.icon,
    this.trailing,
    required this.enabled,
  });

  final VoidCallback onPressed;
  final String label;
  final Widget? icon;
  final Widget? trailing;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem<void>(
      onTap: enabled ? onPressed : null,
      child: Row(
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 12),
          ],
          Expanded(child: Text(label)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Connected Button Group (equivalent to Android ConnectedButtonGroup)
/// Minimal spacing with unified styling, replaces segmented buttons
class ExpressiveConnectedButtonGroup extends StatefulWidget {
  const ExpressiveConnectedButtonGroup({
    Key? key,
    required this.children,
    this.size = ButtonGroupSize.medium,
    this.shape = ButtonGroupShape.round,
    this.selectionMode = ButtonGroupSelectionMode.singleSelect,
    this.selectedIndices = const <int>{},
    this.onSelectionChanged,
    this.enabled = true,
  }) : super(key: key);

  final List<Widget> children;
  final ButtonGroupSize size;
  final ButtonGroupShape shape;
  final ButtonGroupSelectionMode selectionMode;
  final Set<int> selectedIndices;
  final ValueChanged<Set<int>>? onSelectionChanged;
  final bool enabled;

  @override
  State<ExpressiveConnectedButtonGroup> createState() => _ExpressiveConnectedButtonGroupState();
}

class _ExpressiveConnectedButtonGroupState extends State<ExpressiveConnectedButtonGroup>
    with TickerProviderStateMixin {
  late Set<int> _selectedIndices;
  late List<AnimationController> _animationControllers;

  @override
  void initState() {
    super.initState();
    _selectedIndices = Set.from(widget.selectedIndices);
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationControllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    // Set initial states
    for (int i = 0; i < _selectedIndices.length; i++) {
      if (_selectedIndices.contains(i)) {
        _animationControllers[i].value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double get _buttonHeight {
    switch (widget.size) {
      case ButtonGroupSize.extraSmall:
        return 32.0;
      case ButtonGroupSize.small:
        return 40.0;
      case ButtonGroupSize.medium:
        return 48.0;
      case ButtonGroupSize.large:
        return 56.0;
      case ButtonGroupSize.extraLarge:
        return 64.0;
    }
  }

  double get _innerCornerRadius {
    switch (widget.size) {
      case ButtonGroupSize.extraSmall:
        return 4.0;
      case ButtonGroupSize.small:
        return 8.0;
      case ButtonGroupSize.medium:
        return 8.0;
      case ButtonGroupSize.large:
        return 16.0;
      case ButtonGroupSize.extraLarge:
        return 20.0;
    }
  }

  void _handleSelection(int index) {
    if (!widget.enabled) return;

    setState(() {
      switch (widget.selectionMode) {
        case ButtonGroupSelectionMode.singleSelect:
          // Deselect previous
          for (int i = 0; i < _animationControllers.length; i++) {
            if (_selectedIndices.contains(i) && i != index) {
              _animationControllers[i].reverse();
            }
          }
          _selectedIndices = {index};
          _animationControllers[index].forward();
          break;
        case ButtonGroupSelectionMode.multiSelect:
          if (_selectedIndices.contains(index)) {
            _selectedIndices.remove(index);
            _animationControllers[index].reverse();
          } else {
            _selectedIndices.add(index);
            _animationControllers[index].forward();
          }
          break;
        case ButtonGroupSelectionMode.selectionRequired:
          if (_selectedIndices.contains(index) && _selectedIndices.length > 1) {
            _selectedIndices.remove(index);
            _animationControllers[index].reverse();
          } else if (!_selectedIndices.contains(index)) {
            _selectedIndices.add(index);
            _animationControllers[index].forward();
          }
          break;
      }
    });

    widget.onSelectionChanged?.call(_selectedIndices);
  }

  BorderRadius _getBorderRadius(int index, int total) {
    final radius = widget.shape == ButtonGroupShape.round 
        ? Radius.circular(_buttonHeight / 2) 
        : Radius.circular(_innerCornerRadius);
    
    if (total == 1) {
      return BorderRadius.all(radius);
    } else if (index == 0) {
      return BorderRadius.only(
        topLeft: radius,
        bottomLeft: radius,
      );
    } else if (index == total - 1) {
      return BorderRadius.only(
        topRight: radius,
        bottomRight: radius,
      );
    } else {
      return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: _buttonHeight,
      decoration: BoxDecoration(
        borderRadius: widget.shape == ButtonGroupShape.round 
            ? BorderRadius.circular(_buttonHeight / 2)
            : BorderRadius.circular(_innerCornerRadius),
        border: Border.all(color: colorScheme.outline, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < widget.children.length; i++) ...[
            Flexible(
              child: AnimatedBuilder(
                animation: _animationControllers[i],
                builder: (context, child) {
                  final isSelected = _selectedIndices.contains(i);
                  return Container(
                    constraints: BoxConstraints(
                      minHeight: _buttonHeight - 4, // Account for border
                    ),
                    margin: const EdgeInsets.all(2.0), // 2dp padding per spec
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? colorScheme.secondaryContainer
                          : Colors.transparent,
                      borderRadius: _getBorderRadius(i, widget.children.length),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _handleSelection(i),
                        borderRadius: _getBorderRadius(i, widget.children.length),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          alignment: Alignment.center,
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: isSelected
                                  ? colorScheme.onSecondaryContainer
                                  : colorScheme.onSurface,
                            ),
                            child: widget.children[i],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (i < widget.children.length - 1)
              Container(
                width: 1,
                height: _buttonHeight - 8,
                color: colorScheme.outline.withOpacity(0.5),
              ),
          ],
        ],
      ),
    );
  }
}

/// Default values for M3 Expressive Button Groups
class ExpressiveButtonGroupDefaults {
  ExpressiveButtonGroupDefaults._();

  /// Default expanded ratio (15% as per Android implementation)
  static const double expandedRatio = 0.15;

  /// Default spacing between buttons in standard button groups
  static const double spacing = 8.0;

  /// Connected button group spacing (2dp as per spec)
  static const double connectedSpacing = 2.0;

  /// Default shapes for connected button groups based on position
  static BorderRadius connectedLeadingShape(ButtonGroupSize size) {
    final radius = _getCornerRadius(size);
    return BorderRadius.only(
      topLeft: Radius.circular(radius),
      bottomLeft: Radius.circular(radius),
      topRight: Radius.circular(4.0),
      bottomRight: Radius.circular(4.0),
    );
  }

  static BorderRadius connectedTrailingShape(ButtonGroupSize size) {
    final radius = _getCornerRadius(size);
    return BorderRadius.only(
      topRight: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
      topLeft: Radius.circular(4.0),
      bottomLeft: Radius.circular(4.0),
    );
  }

  static BorderRadius connectedMiddleShape(ButtonGroupSize size) {
    return BorderRadius.circular(4.0);
  }

  static BorderRadius connectedCheckedShape(ButtonGroupSize size) {
    final radius = _getCornerRadius(size);
    return BorderRadius.circular(radius);
  }

  static double _getCornerRadius(ButtonGroupSize size) {
    switch (size) {
      case ButtonGroupSize.extraSmall:
        return 16.0;
      case ButtonGroupSize.small:
        return 20.0;
      case ButtonGroupSize.medium:
        return 24.0;
      case ButtonGroupSize.large:
        return 28.0;
      case ButtonGroupSize.extraLarge:
        return 32.0;
    }
  }
}

/// Legacy support - Simple button group child utility
class ButtonGroupChild {
  /// Creates an icon button for button groups
  static Widget icon(
    IconData icon, {
    String? label,
    Color? color,
  }) {
    if (label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color)),
        ],
      );
    }
    return Icon(icon, size: 18, color: color);
  }

  /// Creates a text button for button groups
  static Widget text(
    String text, {
    IconData? icon,
    Color? color,
  }) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color)),
        ],
      );
    }
    return Text(text, style: TextStyle(color: color));
  }
}