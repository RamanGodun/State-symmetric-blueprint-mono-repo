# Code Generation Guide

Quick reference for all code generation commands in the monorepo.

## 🚀 Quick Start

### Generate Everything

```bash
# Build runner code generation
melos run gen

# Localization
melos run localization:gen:all

# Asset paths (Spider)
melos run spider:gen

# App icons
melos run icons:gen
```

## 📦 Build Runner Code Generation

Generate Riverpod providers, Freezed models, etc.

```bash
# All packages and apps
melos run gen

# Specific targets
melos run gen:adapters      # Only adapters
melos run gen:packages      # Only packages
melos run gen:apps          # Only apps

# Clean generated files
melos run gen:clean
```

**Watch mode:**

```bash
melos run watch:adapters
melos run watch:packages
melos run watch:apps
```

## 🌍 Localization

Generate translation keys for easy_localization.

```bash
# Everything (core + apps)
melos run localization:gen:all

# Core shared translations
melos run localization:gen:core

# All apps
melos run localization:gen:apps

# Specific app
melos run localization:gen:cubit
melos run localization:gen:riverpod

# Alias
melos run locale:regen
```

**Direct script usage:**

```bash
./scripts/gen_localization.sh all        # All
./scripts/gen_localization.sh core       # Core only
./scripts/gen_localization.sh cubit      # Cubit app
./scripts/gen_localization.sh riverpod   # Riverpod app
```

## 🕷️ Spider Asset Paths

Generate type-safe asset paths.

```bash
# All apps, all assets (images + icons)
melos run spider:gen

# Specific app
melos run spider:gen:cubit      # Cubit app, all assets
melos run spider:gen:riverpod   # Riverpod app, all assets

# Specific asset type
melos run spider:gen:images     # Both apps, images only
melos run spider:gen:icons      # Both apps, icons only
```

**Direct script usage:**

```bash
./scripts/gen_spider.sh all all           # All apps, all assets
./scripts/gen_spider.sh cubit images      # Cubit, images only
./scripts/gen_spider.sh riverpod icons    # Riverpod, icons only
```

## 🎨 App Launcher Icons

Generate app icons for different flavors.

```bash
# All apps, all flavors
melos run icons:gen

# Specific app
melos run icons:gen:cubit       # Cubit app, all flavors
melos run icons:gen:riverpod    # Riverpod app, all flavors

# Specific flavor
melos run icons:gen:dev         # Both apps, development
melos run icons:gen:stg         # Both apps, staging

# Combination
melos run icons:cubit:dev       # Cubit, development
melos run icons:cubit:stg       # Cubit, staging
melos run icons:riverpod:dev    # Riverpod, development
melos run icons:riverpod:stg    # Riverpod, staging
```

**Verify icons:**

```bash
melos run icons:verify
```

**Direct script usage:**

```bash
./scripts/gen_icons.sh all all        # All apps, all flavors
./scripts/gen_icons.sh cubit dev      # Cubit, development
./scripts/gen_icons.sh riverpod stg   # Riverpod, staging
```

## 🔄 Typical Workflow

### After cloning the repo

```bash
melos bootstrap                    # Install dependencies
melos run gen                      # Generate code
melos run localization:gen:all     # Generate translations
melos run spider:gen               # Generate asset paths
```

### After adding new translations

```bash
melos run localization:gen:riverpod   # For riverpod app
# or
./scripts/gen_localization.sh riverpod
```

### After adding new images/icons to assets

```bash
melos run spider:gen
# or
./scripts/gen_spider.sh all all
```

### After changing app icon source files

```bash
melos run icons:gen:dev            # For development flavor
# or
./scripts/gen_icons.sh all dev
```

### During development (watch mode)

```bash
# In one terminal
melos run watch:apps

# In another terminal
melos run run:rp:dev              # Run riverpod app
```

## 📝 Notes

- All scripts are in `scripts/` directory
- Scripts can be run directly or through Melos
- Scripts have colored output for better visibility
- See `scripts/README.md` for detailed script documentation
- Legacy command aliases are preserved for backward compatibility

## 🆘 Troubleshooting

### Localization not updating

Make sure `easy_localization` is in dependencies:

```bash
melos run pub:get
```

### Spider not found

Install spider globally:

```bash
melos run spider:activate
```

### Icons not generating

Check if `flutter_launcher_icons` is in dev_dependencies and run:

```bash
melos run pub:get
```

### Build runner fails

Clean and regenerate:

```bash
melos run gen:clean
melos run gen
```

## 📚 Additional Resources

- Scripts documentation: `scripts/README.md`
- Migration summary: `scripts/MIGRATION_SUMMARY.md`
- Melos configuration: `melos.yaml`
