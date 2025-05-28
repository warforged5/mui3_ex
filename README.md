# Material 3 Expressive Flutter Package

A Flutter package implementing Material 3 Expressive design system components.

## Features

- ✅ Expressive App Bars (Search, Small, Medium, Large)
- ✅ Button Groups (Standard & Connected)
- ✅ Motion Physics System Foundation
- 🚧 Extended FAB (Coming Soon)
- 🚧 Enhanced Typography (Coming Soon)
- 🚧 Carousel Component (Coming Soon)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  material3_expressive: ^0.1.0
```

## Usage

### App Bars

```dart
import 'package:material3_expressive/material3_expressive.dart';

// Search App Bar
ExpressiveSearchAppBar(
  title: Text('Body Large'),
  leading: IconButton(
    icon: Icon(Icons.menu),
    onPressed: () {},
  ),
  actions: [
    CircleAvatar(child: Icon(Icons.person)),
  ],
)

// Small App Bar
ExpressiveSmallAppBar(
  title: 'Headline',
  subtitle: 'Subtitle',
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {},
  ),
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)

// Medium Flexible App Bar (use in CustomScrollView)
ExpressiveMediumAppBar(
  title: 'Headline',
  subtitle: 'Subtitle',
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)

// Large Flexible App Bar (use in CustomScrollView)
ExpressiveLargeAppBar(
  title: 'Headline',
  subtitle: 'Subtitle',
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)
```

### Button Groups

```dart
// Standard Button Group (with spacing and interactive animations)
ExpressiveStandardButtonGroup(
  size: ButtonGroupSize.medium,
  shape: ButtonGroupShape.round,
  selectionMode: ButtonGroupSelectionMode.singleSelect,
  selectedIndices: {0},
  onSelectionChanged: (selection) {
    // Handle selection changes
  },
  children: [
    ButtonGroupChild.icon(Icons.edit),
    ButtonGroupChild.text('Label'),
    ButtonGroupChild.icon(Icons.star),
  ],
)

// Connected Button Group (replaces segmented buttons)
ExpressiveConnectedButtonGroup(
  size: ButtonGroupSize.medium,
  shape: ButtonGroupShape.round,
  selectionMode: ButtonGroupSelectionMode.singleSelect,
  selectedIndices: {0},
  onSelectionChanged: (selection) {
    // Handle selection changes
  },
  children: [
    ButtonGroupChild.text('8 oz'),
    ButtonGroupChild.text('12 oz'),
    ButtonGroupChild.text('16 oz'),
    ButtonGroupChild.text('20 oz'),
  ],
)

// Utility methods for button content
ButtonGroupChild.icon(Icons.star)                    // Icon only
ButtonGroupChild.text('Label')                       // Text only  
ButtonGroupChild.icon(Icons.star, label: 'Label')   // Icon + Text
ButtonGroupChild.text('Label', icon: Icons.star)    // Text + Icon
```

### Button Group Configuration

**Sizes:** `extraSmall`, `small`, `medium`, `large`, `extraLarge`
**Shapes:** `round`, `square`  
**Selection Modes:** `singleSelect`, `multiSelect`, `selectionRequired`

### Motion System

```dart
// Use predefined motion schemes
ExpressiveMotion.expressive  // Bouncy, expressive animations
ExpressiveMotion.standard    // Subtle, functional animations

// Motion durations
ExpressiveMotion.fastSpatial     // 200ms for small elements
ExpressiveMotion.defaultSpatial  // 300ms for medium elements  
ExpressiveMotion.slowSpatial     // 500ms for large elements

// Spring curves
ExpressiveMotion.expressiveSpring  // Bouncy spring effect
ExpressiveMotion.spatialSpring     // For movement animations
ExpressiveMotion.effectsSpring     // For color/opacity changes
```

## Component Details

### Standard vs Connected Button Groups

**Standard Button Groups:**
- Have spacing between buttons (8-18dp depending on size)
- Interactive width/shape changes affect adjacent buttons
- Individual button styling with borders
- Better for toolbar-style layouts

**Connected Button Groups:**  
- Minimal 2dp spacing between buttons
- Shape changes don't affect adjacent buttons
- Unified border around entire group
- Replaces segmented buttons with better M3 Expressive styling

### Expressive Features

- **Shape Morphing:** Buttons change between round/square when selected
- **Spring Animations:** Physics-based motion for natural feel
- **Emphasized Typography:** Heavier weights and better hierarchy
- **Interactive Scaling:** Buttons scale slightly when pressed
- **Vibrant Selection States:** Rich color schemes for selected states

## Roadmap

- [ ] FAB Menu and Extended FAB components
- [ ] Carousel with shape morphing
- [ ] Loading indicator variations  
- [ ] Split button component
- [ ] Enhanced typography system
- [ ] Shape library integration
- [ ] Complete motion physics implementation

## Contributing

Contributions are welcome! Please read our contributing guidelines.

## License

This project is licensed under the MIT License.