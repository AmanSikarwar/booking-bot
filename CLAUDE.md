# booking-bot

## Toolchain (verified 2026-11-20)
- Flutter 3.50.0 stable, Dart 3.14.0, DevTools 2.61.0 — latest stable. SDK at `~/Development/flutter`.
- Dart MCP server (`dart mcp-server` 1.2.2) registered in `.mcp.json`. Tools: analyze_files, dart_fix, dart_format, run_tests, pub, pub_dev_search, launch_app, hot_reload, hot_restart, get_runtime_errors, widget_inspector, flutter_driver, lsp.
- Project skills in `.claude/skills` (from `flutter/agent-plugins`, tracked in `skills-lock.json`): dart-use-primary-constructors, dart-use-path-package, dart-use-doc-examples, dart-write-documentation. Other Flutter/Dart skills are installed globally.

## Hot reload
After editing `lib/**/*.dart` (not comments/whitespace) with an app running: `hot_reload` via the Dart MCP server; use `hot_restart` when `main()`, `initState`, or global/static state changed. Skip for `test/`, `integration_test/`, `example/`.

## Flutter/Dart changes newer than model training (June 2026)
Full notes in memory `flutter-dart-changes-2026h2`. Key rules for this repo:

### Material / Cupertino moved to packages (Flutter 3.47 → deprecated in-SDK in 3.50)
- Import `package:material_ui/material_ui.dart` and `package:cupertino_ui/cupertino_ui.dart`, NOT `package:flutter/material.dart` / `cupertino.dart`. `flutter create` now uses `material_ui` by default.
- Migrate: `dart fix --apply --code=migrate_design_widgets`, then `dart fix --apply`. If pubspec isn't updated: `flutter pub add material_ui` (and `cupertino_ui`).
- Localizations: `localizationsDelegates: GlobalMaterialLocalizations.delegates` (bundles Material + Cupertino + Widgets delegates).
- Dependency still on old imports → `MaterialApp(builder: (context, child) => MaterialUiCompatibilityBridge(child: child!))`. Doesn't fix type mismatches (e.g. passing `ColorScheme` across the boundary).
- `material_ui` ships on its own schedule (e.g. 1.8.0: `DropdownButtonFormField.enabled`, `onChanged` optional).

### Dart language (3.12–3.14)
- 3.12: private named params `Point({required this._x})` — callers pass `x:`.
- 3.13: primary constructors `class Point(var int x, var int y);`, `this : assert(...)` body; in-body `new(...)` / `factory name(...)` without repeating class name. `final`/`var` banned on non-declaring params.
- 3.13 core: `Future.pause`, `List.unmodifiableOf`, `Map.unmodifiableOf`, `int.trailingZeroBitCount`, `int.oneBitCount`.
- 3.13 lints: `no_raw_types`, `no_dynamic_casts` replace `strict-raw-types`/`strict-casts`; new `use_declaring_parameters`, `unnecessary_type_name_in_constructor`, `async_return_with_no_await`, `empty_container_bodies`.
- 3.14: no new syntax. `dart migrate [--dry-run|--apply|--target-sdk|--step cleanup|all]` bumps SDK constraint one minor at a time. `dart run -e '<expr>'`. `dart pub upgrade pkg@latest`. Lint `future_sync_value` → `Future.syncValue`. `dart:mirrors` deprecated.

### Web
- `dart:html`, `dart:js`, `dart:js_util`, `package:js` deprecated → use `package:web` + `dart:js_interop`. Gate with `flutter build web --no-deprecated-js-interop`.
- Wasm (`flutter build web --wasm`, falls back to JS) runs on Chrome/Edge 137+, and opt-in Safari 26.2+/Firefox 147+ via `wasmAllowList` (`webkit`, `gecko`) in `flutter_bootstrap.js`.
- `SafeArea` honors `viewport-fit=cover` on web.

### Platforms
- Min iOS 15, macOS 12. UIScene lifecycle mandatory with Xcode 27. Swift Package Manager is the default; CocoaPods deprecated (cutoff Dec 2026).
- Android defaults: compileSdk/targetSdk 36, minSdk 24; AGP 9.1 / Gradle 9.3.1 / KGP 2.4 / Java 17. Use AGP built-in Kotlin (don't apply KGP manually; breaks on AGP 10).
- Android release builds ignore Intent-supplied routes/entrypoints/cached engines and engine flags (`--dart-flags`). Deep links still work.
- Impeller is default on macOS, Windows, Linux too.

### Framework
- Widget Previews stable (`.widget_preview/` cache, `PreviewThemeData`).
- FFIgen/JNIgen stable; Pigeon generates through them.
- Removed `describeEnum` → `enum.name`. Deprecated: `ReorderableList.onReorder`, `cacheExtent`/`cacheExtentStyle`, `TextInputConnection.setStyle`. `IconData` is `final`.
- Soft hyphens render at line breaks; `WidgetSpan` follows bidi order in RTL.
