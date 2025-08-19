# Assets Package

**Assets** is a shared Flutter package used across all applications in the monorepo.
It centralizes fonts, translations, images, icons, Lottie animations, and utility accessors into a single, reusable module.

---

## Installation

Add the package to your app's `pubspec.yaml`:

```yaml
dependencies:
  assets:
    path: ../../packages/assets
```

Import only from the public barrel file:

```dart
import 'package:assets/assets.dart';
```

> **Import Rule:** Never import internal subfolders directly. Always go through the package's public API.

---

## Directory Structure

```
assets/
├─ fonts/                 # Fonts (variable + italic variable)
│  ├─ IBM_Plex_Sans/
│  ├─ Inter/
│  ├─ Lato/
│  ├─ Montserrat/
│  ├─ Noto_Sans/
│  ├─ Open_Sans/
│  ├─ Roboto/
│  └─ Source_Sans_3/
├─ images/                 # Raster/vector graphics
├─ icons/                  # (Optional) Custom icon fonts or SVG icons
├─ animations/             # (Optional) Lottie JSON animations
└─ translations/           # JSON translations for easy_localization
|
└- lib/
    └─ assets.dart         # Barrel file with constants and access helpers
```

---

## Usage

### Images

```dart
// Recommended: use constants from barrel
Image.asset(Img.flutterLogo, package: 'assets');

// Direct path (less maintainable)
Image.asset('assets/images/flutter_logo.png', package: 'assets');
```

> Always include `package: 'assets'` when loading resources from a package.

### Lottie Animations

```dart
import 'package:lottie/lottie.dart';

Lottie.asset('assets/lottie/loading.json', package: 'assets');
```

### Icons

- For PNG/SVG: use as with images.
- For icon fonts (TTF): declare in `fonts:` and use via `IconData`.

### Translations (`easy_localization`)

```dart
EasyLocalization(
  supportedLocales: const [Locale('en'), Locale('uk'), Locale('pl')],
  path: 'packages/assets/assets/translations',
  fallbackLocale: const Locale('en'),
  child: const App(),
);
```

---

## Fonts

We use **variable fonts** wherever possible for efficiency. Each font family typically has:

- 1 variable weight file
- 1 italic variable weight file

### Declaring Fonts in `pubspec.yaml`

```yaml
flutter:
  fonts:
    - family: IBM Plex Sans
      fonts:
        - asset: assets/fonts/IBM_Plex_Sans/IBMPlexSans-VariableFont_wdth,wght.ttf
          weight: 100
        - asset: assets/fonts/IBM_Plex_Sans/IBMPlexSans-Italic-VariableFont_wdth,wght.ttf
          style: italic
          weight: 100
    - family: Montserrat
      fonts:
        - asset: assets/fonts/Montserrat/Montserrat-VariableFont_wght.ttf
          weight: 100
        - asset: assets/fonts/Montserrat/Montserrat-Italic-VariableFont_wght.ttf
          style: italic
          weight: 100
```

> Flutter ignores `wdth`/`opsz` but supports `wght`. Setting `weight: 100` ensures the entire 100–900 range is available.

### Using Fonts in Apps

Once declared in the **assets package**, apps can simply reference:

```dart
final theme = ThemeData(
  fontFamily: 'IBM Plex Sans',
);

final headingStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w600,
);
```

---

## Barrel File (`assets.dart`)

Use `lib/assets.dart` to store constants:

```dart
library assets;

class Img {
  static const flutterLogo = 'assets/images/flutter_logo.png';
}

class I18n {
  static const path = 'packages/assets/assets/translations';
}

class FontFamilies {
  static const ibmPlexSans = 'IBM Plex Sans';
  static const montserrat = 'Montserrat';
}
```

---

## Conventions

- **Avoid duplication** of assets.
- **Variable fonts first**; keep static only if necessary.
- **Localization parity**: new keys must exist in all supported locales or have a fallback.
- **Licensing**: keep `OFL.txt` in each font folder and note any attribution for images/icons.
- **Naming**: use `snake_case` for file names.

---

## Development

From the monorepo root:

```bash
# Lint, format, and test all packages
melos run check

# Only for assets package
melos exec --scope="assets" -- dart format .
melos exec --scope="assets" -- flutter analyze
```

---

## License

This package is licensed under the same terms as the [root LICENSE](../../LICENSE) of this monorepo.
Fonts follow their respective `OFL.txt` terms. External assets must comply with their source licensing.
