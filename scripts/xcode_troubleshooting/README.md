# XCode Troubleshooting Scripts

Collection of scripts to fix common XCode and iOS build issues.

## Available Scripts

### 1. Kill XCode Processes

**Script**: `kill_xcode.sh`

**Melos command**:

```bash
melos run kill:xcode
```

**Description**: Kills all running `xcodebuild` processes. Useful when you get "concurrent build" errors or when XCode builds are stuck.

**Usage**:

```bash
# Via melos (recommended)
melos run kill:xcode

# Direct script call
./scripts/xcode_troubleshooting/kill_xcode.sh
```

---

### 2. Clean iOS Build

**Script**: `clean_ios.sh`

**Melos commands**:

```bash
# Clean Riverpod app
melos run clean:ios:state_symmetric_on_riverpod

# Clean Cubit app
melos run clean:ios:state_symmetric_on_cubit
```

**Description**: Cleans iOS build artifacts for a specific app. This includes:

- Killing all xcodebuild processes
- Running `flutter clean` for the specified app

**Usage**:

```bash
# Via melos (recommended)
melos run clean:ios:state_symmetric_on_riverpod
melos run clean:ios:state_symmetric_on_cubit

# Direct script call
./scripts/xcode_troubleshooting/clean_ios.sh riverpod
./scripts/xcode_troubleshooting/clean_ios.sh cubit
```

---

### 3. Reset iOS Build Completely

**Script**: `reset_ios.sh`

**Melos commands**:

```bash
# Reset Riverpod app
melos run reset:ios:state_symmetric_on_riverpod

# Reset Cubit app
melos run reset:ios:state_symmetric_on_cubit
```

**Description**: Completely resets iOS build environment. This includes:

- Killing all xcodebuild processes
- Running `flutter clean` for the specified app
- Removing Xcode DerivedData (`~/Library/Developer/Xcode/DerivedData/Runner-*`)

**When to use**: Use this when `clean:ios` doesn't help and you're still experiencing build issues.

**Usage**:

```bash
# Via melos (recommended)
melos run reset:ios:state_symmetric_on_riverpod
melos run reset:ios:state_symmetric_on_cubit

# Direct script call
./scripts/xcode_troubleshooting/reset_ios.sh riverpod
./scripts/xcode_troubleshooting/reset_ios.sh cubit
```

---

### 4. Quick iOS Build Fix

**Script**: `fix_ios.sh`

**Melos command**:

```bash
melos run fix:ios
```

**Description**: Quick fix for iOS concurrent build errors. Runs in the **current directory**:

- Kills all xcodebuild processes
- Runs `flutter clean` in current directory

**When to use**: Use this when you're already in an app directory and need a quick fix without specifying the app name.

**Usage**:

```bash
# Via melos (recommended)
cd apps/state_symmetric_on_riverpod
melos run fix:ios

# Direct script call
cd apps/state_symmetric_on_riverpod
../../scripts/xcode_troubleshooting/fix_ios.sh
```

---

## Common Issues and Solutions

### Issue: "Concurrent builds" error

**Error message**:

```
error: Simultaneous accesses to [...], but modification requires exclusive access
```

**Solution**:

```bash
melos run kill:xcode
# Then try building again
```

---

### Issue: XCode build stuck or hanging

**Solution**:

```bash
melos run kill:xcode
melos run clean:ios:state_symmetric_on_riverpod  # or cubit
# Then try building again
```

---

### Issue: Persistent build failures after code changes

**Solution**:

```bash
melos run reset:ios:state_symmetric_on_riverpod  # or cubit
# This will do a deep clean including DerivedData
# Then try building again
```

---

### Issue: Quick fix needed while in app directory

**Solution**:

```bash
cd apps/state_symmetric_on_riverpod
melos run fix:ios
# Then try building again
```

---

## Troubleshooting Workflow

Recommended order for troubleshooting iOS build issues:

1. **First try**: Kill xcodebuild processes

   ```bash
   melos run kill:xcode
   ```

2. **If that doesn't help**: Clean the specific app

   ```bash
   melos run clean:ios:state_symmetric_on_riverpod
   ```

3. **If still failing**: Reset completely (removes DerivedData)

   ```bash
   melos run reset:ios:state_symmetric_on_riverpod
   ```

4. **Last resort**: Delete the app and reinstall dependencies
   ```bash
   melos run reset:ios:state_symmetric_on_riverpod
   cd apps/state_symmetric_on_riverpod
   flutter pub get
   cd ios
   pod install
   ```

---

## Script Details

### Color Coding

All scripts use colored output for better readability:

- 🔵 **Blue**: Section headers and main actions
- 🟡 **Yellow**: In-progress operations
- 🟢 **Green**: Success messages
- 🔴 **Red**: Error messages

### Error Handling

- All scripts use `set -e` to exit on errors (except `kill_xcode.sh`)
- `killall xcodebuild` uses `|| true` to avoid failing if no processes are running
- Invalid arguments are caught with clear error messages

### Directory Structure

```
scripts/xcode_troubleshooting/
├── README.md              # This file
├── kill_xcode.sh          # Kill xcodebuild processes
├── clean_ios.sh           # Clean iOS build for specific app
├── reset_ios.sh           # Reset iOS build completely
└── fix_ios.sh             # Quick fix in current directory
```

---

## Notes

- All scripts are safe to run multiple times
- Scripts won't delete your source code, only build artifacts
- DerivedData removal only affects Runner projects (not all Xcode projects)
- These scripts are macOS-specific (use Darwin paths like `~/Library/Developer/Xcode/`)

---

**Last Updated**: 2026-01-09
