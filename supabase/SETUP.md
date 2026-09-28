# SnapFocus cloud sync setup

The React web preview and Flutter app share the Supabase `tasks` and `proof_photos` tables. Flutter also syncs `pillars`, `goals`, and `proof_notes`. Supabase Auth owns each row; Row Level Security policies restrict access to the signed-in user.

## One-time Supabase setup

1. Open the SnapFocus project in the Supabase Dashboard.
2. Open **SQL Editor** and create a new query.
3. Open `supabase/migrations/202609290001_snapfocus_sync.sql` in this repository, copy all of it into the query editor, and run it. It creates the tables, per-user policies, private proof-photo bucket, and Realtime publication entries.
4. In **Authentication → URL Configuration**, add your web preview/production origins to the allowed redirect URLs if you later enable email confirmation redirects. The current forms display the confirmation message and let the user return to sign in.

## Local configuration

- The repository-root `.env.local` is ignored by Git and holds the web URL/publishable key as `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY`.
- `mobile/supabase.local.json` is ignored by Git and supplies the same values to Flutter.
- Use only the publishable key in clients. Never put a service-role key in either app.

## Run

From the repository root, run `npm run dev` for the React preview. From `mobile`, run `flutter run --dart-define-from-file=supabase.local.json` for Flutter (or append `-d web-server --web-port=3003` to serve the Flutter web build).

The first signed-in account claims legacy local-only records on that device/browser and uploads them when the cloud table has no rows. Later accounts use separate local browser caches; Flutter clears the previous account's local cache before loading the newly signed-in account. Existing cloud rows take precedence for matching IDs, while local-only records are merged.

Task, goal, and note edits are queued locally and retried when the app reconnects or the data is loaded again. Web subscribes to Realtime updates; Flutter subscribes while the app is open. Photos are uploaded to the private `snapfocus-proofs` bucket and downloaded on other devices.
