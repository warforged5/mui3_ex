# Material 3 Expressive Flutter Package

A Flutter package implementing Material 3 Expressive design system components, closely following the official Android Compose Material 3 implementation.

## Features

- ✅ **Expressive App Bars** - Search, Small, Medium, Large, TwoRows with subtitle support
- ✅ **Button Groups** - DSL-style API with interactive width animations, weight system, and overflow handling
- ✅ **Connected Button Groups** - Enhanced segmented buttons with shape morphing  
- ✅ **Motion Physics System** - Spring-based animations with proper curves
- 🚧 **Extended FAB** (Coming Soon)
- 🚧 **Enhanced Typography** (Coming Soon)
- 🚧 **Carousel Component** (Coming Soon)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  material3_expressive: ^0.1.0
```

## Usage

### Button Groups with DSL-Style API

The new Button Group API closely matches the Android Compose implementation with a scope-based DSL:

#### Standard Button Group with Interactive Animations
```dart
ExpressiveButtonGroup(
  expandedRatio: 0.15, // 15% expansion when pressed (Android default)
  builder: (scope) {
    scope.clickableItem(
      onPressed: () => print('Edit pressed'),
      label: 'Edit',
      icon: const Icon(Icons.edit),
      weight: 1.0, // Proportional width
    );
    scope.toggleableItem(
      checked: isSelected,
      onChanged: (checked) => setState(() => isSelected = checked),
      label: 'Toggle',
      icon: const Icon(Icons.toggle_on),
      weight: 2.0, // Takes twice the space
    );
    scope.customItem(
      buttonGroupContent: () => YourCustomWidget(),
      menuContent: (menuState) => YourMenuWidget(menuState),
    );
  },
)
```

#### Connected Button Group (Enhanced Segmented Buttons)
```dart
ExpressiveConnectedButtonGroup(
  size: ButtonGroupSize.medium,
  shape: ButtonGroupShape.round,
  selectionMode: ButtonGroupSelectionMode.singleSelect,
  selectedIndices: {0},
  onSelectionChanged: (selection) {
    setState(() => selectedIndices = selection);
  },
  children: const [
    Text('8 oz'),
    Text('12 oz'),
    Text('16 oz'),
    Text('20 oz'),
  ],
)
```

### Button Group Features

#### DSL Methods
- **`clickableItem()`** - Regular buttons with press actions
- **`toggleableItem()`** - Toggle buttons with checked state
- **`customItem()`** - Full custom content with overflow menu support

#### Weight System
```dart
scope.clickableItem(
  label: 'Small',
  weight: 0.5, // Half width
  onPressed: () {},
);
scope.clickableItem(
  label: 'Large',
  weight: 2.0, // Double width
  onPressed: () {},
);
```

#### Interactive Width Animations
- Buttons expand by 15% when pressed (configurable)
- Adjacent buttons compress to accommodate expansion
- Physics-based spring animations
- Matches Android ButtonGroup behavior exactly

#### Configuration Options

**Sizes:** `extraSmall`, `small`, `medium`, `large`, `extraLarge`  
**Shapes:** `round`, `square`  
**Selection Modes:** `singleSelect`, `multiSelect`, `selectionRequired`

### App Bars with M3 Expressive Features

#### Search App Bar (TopAppBar equivalent)
```dart
ExpressiveSearchAppBar(
  title: Text('Search'),
  centerTitle: true,
  leading: IconButton(
    icon: Icon(Icons.menu),
    onPressed: () {},
  ),
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
    CircleAvatar(child: Icon(Icons.person)),
  ],
  expandedHeight: 72.0, // Custom height
)
```

#### Small App Bar with Subtitle Support
```dart
ExpressiveSmallAppBar(
  title: 'Headline',
  subtitle: 'Enhanced with subtitle support',
  titleHorizontalAlignment: TextAlign.start, // or TextAlign.center
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {},
  ),
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)
```

#### Medium Flexible App Bar (MediumFlexibleTopAppBar equivalent)
```dart
// Use in CustomScrollView
ExpressiveMediumAppBar(
  title: 'Medium Headline',
  subtitle: 'Responsive layout with enhanced typography',
  titleHorizontalAlignment: TextAlign.start,
  collapsedHeight: ExpressiveAppBarDefaults.mediumAppBarCollapsedHeight,
  expandedHeight: ExpressiveAppBarDefaults.mediumFlexibleAppBarWithSubtitleExpandedHeight,
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)
```

#### Large Flexible App Bar (LargeFlexibleTopAppBar equivalent)
```dart
// Use in CustomScrollView  
ExpressiveLargeAppBar(
  title: 'Large Hero Headline',
  subtitle: 'For hero moments with emotional impact',
  titleHorizontalAlignment: TextAlign.start,
  collapsedHeight: ExpressiveAppBarDefaults.largeAppBarCollapsedHeight,
  expandedHeight: ExpressiveAppBarDefaults.largeFlexibleAppBarWithSubtitleExpandedHeight,
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)
```

#### Custom Two Rows App Bar (TwoRowsTopAppBar equivalent)
```dart
ExpressiveTwoRowsAppBar(
  title: 'Custom Layout',
  subtitle: 'Fully customizable',
  titleHorizontalAlignment: TextAlign.center,
  expandedTitleBuilder: (title, subtitle, expanded) {
    return Column(
      children: [
        Icon(Icons.favorite, size: 32, color: Colors.red),
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        if (subtitle != null) Text(subtitle),
      ],
    );
  },
  collapsedTitleBuilder: (title, subtitle, expanded) {
    return Row(
      children: [
        Icon(Icons.favorite, size: 16, color: Colors.red),
        SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  },
)
```

### Motion System

```dart
// Motion durations (matching MotionSchemeKeyTokens)
ExpressiveAppBarMotion.defaultEffects    // 200ms for color transitions
ExpressiveAppBarMotion.fastSpatial       // 150ms for small elements
ExpressiveAppBarMotion.defaultSpatial    // 300ms for medium elements  
ExpressiveAppBarMotion.slowSpatial       // 500ms for large elements

// Spring curves for M3 Expressive animations
ExpressiveAppBarMotion.expressiveSpring  // Bouncy spring effect
ExpressiveAppBarMotion.spatialSpring     // For movement animations
ExpressiveAppBarMotion.effectsSpring     // For color/opacity changes
ExpressiveAppBarMotion.containerColorEasing // For app bar color transitions
```

### Theme Integration

```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    appBarTheme: ExpressiveAppBarDefaults.expressiveAppBarTheme(
      ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
  ),
  home: MyApp(),
)
```

## M3 Expressive Principles

This package implements the core Material 3 Expressive principles:

### **Interactive Animations**
- 15% button expansion on press (configurable)
- Neighbor compression for natural interaction flow
- Physics-based spring animations
- Real-time width animations during interaction

### **Weight System**
- Proportional button sizing based on weight values
- Flexible layout that adapts to content and screen size
- Similar to Flutter's `Flexible` but optimized for button groups

### **DSL-Style API**
- Scope-based item building matching Android Compose
- Type-safe button configuration
- Overflow handling with dropdown menus
- Custom content support

### **Enhanced Typography**
- Heavier font weights for better hierarchy
- Emphasized text styles for emotional impact
- Proper text scaling for different app bar sizes

### **Flexible Layouts** 
- Responsive design that adapts to content
- Subtitle support for better information hierarchy
- Custom layout builders for unique experiences

### **Motion Physics**
- Spring-based animations that feel natural
- Proper motion tokens matching Android implementation
- Interactive elements with expressive feedback

## Component Comparison

### Button Groups

**Standard vs Connected:**

| Feature | Standard | Connected |
|---------|----------|-----------|
| Spacing | 8-18dp between buttons | 2dp unified border |
| Animation | Interactive width changes | Shape morphing only |
| Neighbors | Compress when adjacent pressed | Independent |
| Use Case | Toolbars, action groups | Segmented selection |

**API Comparison:**

| Android Compose | Flutter Equivalent |
|-----------------|-------------------|
| `ButtonGroup { ... }` | `ExpressiveButtonGroup(builder: (scope) { ... })` |
| `scope.clickableItem()` | `scope.clickableItem()` |
| `scope.toggleableItem()` | `scope.toggleableItem()` |
| `scope.customItem()` | `scope.customItem()` |
| `Modifier.weight()` | `weight: 2.0` parameter |
| `expandedRatio: 0.15f` | `expandedRatio: 0.15` |

### App Bar Types

| Android Compose | Flutter Equivalent |
|-----------------|-------------------|
| `TopAppBar` | `ExpressiveSearchAppBar` |
| `TopAppBar` with subtitle | `ExpressiveSmallAppBar` |
| `MediumFlexibleTopAppBar` | `ExpressiveMediumAppBar` |
| `LargeFlexibleTopAppBar` | `ExpressiveLargeAppBar` |
| `TwoRowsTopAppBar` | `ExpressiveTwoRowsAppBar` |

## Roadmap

- [ ] FAB Menu and Extended FAB components
- [ ] Carousel with shape morphing  
- [ ] Loading indicator variations
- [ ] Split button component
- [ ] Enhanced typography system
- [ ] Shape library integration
- [ ] Overflow handling improvements
- [ ] Accessibility enhancements

## Contributing

Contributions are welcome! Please read our contributing guidelines.

## License

This project is licensed under the MIT License.