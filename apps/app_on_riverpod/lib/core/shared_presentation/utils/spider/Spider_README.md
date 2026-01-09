# 🕷️ Spider Setup Manual for Flutter Assets

## 📦 Installation

### ✅ Using Dart (recommended)

```bash
dart pub global activate spider
```

### 💻 Using Homebrew (macOS only)

```bash
brew tap birjuvachhani/spider
brew install spider
```

---

## 📁 Configuration

### Create a configuration file in custom directory (recommended):

```bash (for example)
    // from monorepo root
spider create -p apps/state_symmetric_on_cubit/lib/core/shared_presentation_layer/utils/spider/icons_paths/spider.yaml

or

    // from package root
lib/core/shared_presentation_layer/utils/spider/images_paths/spider.yaml
```

This creates: `spider.yaml` file

### Sample `spider.yaml`

```yaml
# spider.yaml
generate_tests: false
no_comments: true
export: false
use_part_of: false

# Here will be generated file
package: core/shared_presentation_layer/utils/spider/icons_paths

groups:
  # for images in this folder will be generated paths
  - path: assets/icons
    # This is a name of generated class
    class_name: AppIconsPaths
    types: [.png, .jpg, .jpeg, .webp, .gif]
    file_name: app_icons_paths.dart
```

---

## 🛠️ Build

### Run build manually:

```bash
# from core root
spider -p lib/utils_shared/spider/spider.yaml build
# or watch
spider -p lib/utils_shared/spider/spider.yaml --watch
```

### Optional: Watch for file changes

```bash
spider -p packages/core/lib/utils_shared/spider/spider.yaml --watch
```

---

## 🔍 Usage in Dart Code

```dart
import 'package:core/utils_shared/spider/images_paths.dart';

Image(image: AssetImage(AppImagesPaths.flutterLogo, package: 'core'));
```

---

## ⚠️ Notes

- `spider.yaml` **must** be passed via `-p` flag if stored outside root.
- Localization is **not** supported by Spider. Use `easy_localization` instead.

---

## 📚 Resources

- [Spider on pub.dev](https://pub.dev/packages/spider)
- [Installation Guide](https://pub.dev/packages/spider/install)
- [Documentation](https://birjuvachhani.github.io/spider)
