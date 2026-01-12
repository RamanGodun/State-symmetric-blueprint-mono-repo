# XCode Troubleshooting - Quick Examples

Quick reference guide for XCode troubleshooting commands.

## 🚀 Quick Commands

### Kill XCode Processes

```bash
melos run kill:xcode
```

### Clean iOS Build (Riverpod)

```bash
melos run clean:ios:state_symmetric_on_riverpod
```

### Clean iOS Build (Cubit)

```bash
melos run clean:ios:state_symmetric_on_cubit
```

### Reset iOS Build (Riverpod)

```bash
melos run reset:ios:state_symmetric_on_riverpod
```

### Reset iOS Build (Cubit)

```bash
melos run reset:ios:state_symmetric_on_cubit
```

### Quick Fix (Current Directory)

```bash
cd apps/state_symmetric_on_riverpod
melos run fix:ios
```

---

## 🔥 Common Scenarios

### Scenario 1: "Concurrent builds" Error

**Problem:**

```
error: Simultaneous accesses to [...], but modification requires exclusive access
```

**Solution:**

```bash
melos run kill:xcode
# Then rebuild
```

---

### Scenario 2: Build Stuck/Hanging

**Problem:** XCode build process is hanging or not responding

**Solution:**

```bash
melos run kill:xcode
melos run clean:ios:state_symmetric_on_riverpod
# Then rebuild
```

---

### Scenario 3: Persistent Build Failures

**Problem:** Build keeps failing even after cleaning

**Solution:**

```bash
# Nuclear option: reset everything
melos run reset:ios:state_symmetric_on_riverpod
cd apps/state_symmetric_on_riverpod
flutter pub get
cd ios
pod install
# Then rebuild
```

---

### Scenario 4: Quick Fix While Developing

**Problem:** Need quick fix while already in app directory

**Solution:**

```bash
# You're already here: apps/state_symmetric_on_riverpod/
melos run fix:ios
# Then rebuild
```

---

## 📊 Troubleshooting Decision Tree

```
iOS Build Issue?
│
├─ Concurrent builds error?
│  └─ melos run kill:xcode
│
├─ Build stuck/hanging?
│  ├─ melos run kill:xcode
│  └─ If still stuck: melos run clean:ios:state_symmetric_on_riverpod
│
├─ Build failing after code changes?
│  ├─ melos run clean:ios:state_symmetric_on_riverpod
│  └─ If still failing: melos run reset:ios:state_symmetric_on_riverpod
│
└─ Nothing works?
   ├─ melos run reset:ios:state_symmetric_on_riverpod
   ├─ cd apps/state_symmetric_on_riverpod
   ├─ flutter pub get
   ├─ cd ios
   ├─ pod install
   └─ Rebuild from scratch
```

---

## 💡 Pro Tips

1. **Start Light**: Always try `kill:xcode` first before doing heavy cleaning
2. **App Specific**: Use app-specific commands (`riverpod` vs `cubit`) for targeted fixes
3. **Quick Fix**: Use `fix:ios` when already in app directory
4. **Nuclear Option**: Use `reset:ios` only when other methods fail (removes DerivedData)
5. **Check Processes**: Run `ps aux | grep xcodebuild` to see if processes are running

---

## 🔍 Verification Commands

Check if xcodebuild is running:

```bash
ps aux | grep xcodebuild
```

Check DerivedData size:

```bash
du -sh ~/Library/Developer/Xcode/DerivedData/
```

List all Runner DerivedData:

```bash
ls -lh ~/Library/Developer/Xcode/DerivedData/ | grep Runner
```

---

**See [README.md](README.md) for full documentation**
