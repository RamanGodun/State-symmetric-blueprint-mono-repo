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

```bash
spider create -p packages/core/lib/src/shared_presentation_layer/spider/spider.yaml  // from monorepo root
or
lib/src/shared_presentation_layer/spider/spider.yaml                                 // from package root
```

This creates: `packages/core/lib/shared_presentation_layer/spider/spider.yaml`

### Sample `spider.yaml`

```yaml
# spider.yaml (in lib/src/shared_presentation_layer/spider/ )
generate_tests: false
no_comments: true
export: false
use_part_of: false

package: src/shared_presentation_layer/spider/

groups:
  - path: assets/images
    class_name: AppImagesPaths
    types: [.png, .jpg, .jpeg, .webp, .gif]
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
