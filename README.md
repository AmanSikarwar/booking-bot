# Saathi

Saathi is an English and Hindi lab-booking companion for finding test packages and simulating home sample collections. The catalogue, patient profiles, addresses, availability and bookings use synthetic data.

[Web demo](https://amansikarwar.github.io/booking-bot/) · [Android demo APK](https://github.com/AmanSikarwar/booking-bot/releases/tag/v0.1.0) · [Project plan](PLAN.md)

## Run locally

Use Flutter 3.50.0 and Dart 3.14.0. From the repository root, run the app against the demo backend.

```sh
cd app
flutter pub get --enforce-lockfile
flutter run -d chrome
```

To use a separate hosted Supabase project, apply the migration under `supabase/migrations`, enable anonymous sign-in, and deploy `supabase/functions/chat`. Set `LLM_MODE=mock` in that project's function secrets to use scripted responses without an OpenRouter key. For live mode, set `LLM_MODE=live` and `OPENROUTER_API_KEY` in the function secrets. Copy `.env.example` to `.env`, fill in the target URL and publishable key, then launch with `flutter run -d chrome --dart-define-from-file=../.env` from `app/`.

## How it works

- Flutter stores chats, bookings, profiles and the message outbox locally in Drift. The bundled catalogue works offline. The outbox replays queued messages in order when the connection returns, using each message's ID to prevent duplicates.
- The Supabase Edge Function streams replies and card events using server-sent events. The agent can search packages, present a native booking form and confirm a mock slot.
- Saathi explains packages in plain language and stays within booking and preparation questions. Shared keyword rules detect clear red flags on the device and server. The server's decision model handles paraphrases and selected context-dependent matches. Escalated conversations pause booking.

## Verify changes

```sh
(cd app && flutter analyze && flutter test)
(cd supabase/functions/chat && deno lint && deno task test)
scripts/sync_shared.sh
git diff --exit-code -- app/assets/shared supabase/functions/chat/_shared
```

Update the source catalogue or safety rules before running `scripts/sync_shared.sh`. Run `dart run build_runner build` from `app/` after changing models, routes, dependency injection or translations that use code generation.

The [latest safety eval](evals/RESULTS-safety.md) compared keyword detection alone with the full hosted flow. The hosted flow showed the correct card for 28/28 flagged cases, with zero false alarms on 15 routine cases. Keyword detection alone caught 15/28 with three false alarms. The earlier [68-turn report](evals/RESULTS.md) includes package ranking and persona checks. The [eval notes](evals/README.md) record $0.015 in model spend for the initial run, with 97 chat requests and 65 free decision requests.

## Release the demo

Build the installable APK with `flutter build apk --release` from `app/`. The output is `app/build/app/outputs/flutter-apk/app-release.apk` relative to the repository root. The demo uses Android's debug signing configuration for sideloading.

Set the repository's Pages source to GitHub Actions and run the **Publish web demo** workflow on `main`. It builds Flutter for the configured Pages path. The Android APK is the primary way to try the offline flow. Web storage depends on browser support and can be cleared by the browser. The iOS project is included for development.
