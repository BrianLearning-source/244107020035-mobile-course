# Self-verification checklist

1. The UI never calls SQLite/SharedPreferences directly; everything goes through repository + provider.

2. The app fully works in airplane mode: read, add, and delete notes.

3. The dirty badge is accurate before/after sync; cached posts render without internet.

4. flutter analyze is clean and all tests pass.

5. AI output is verified and documented in the docs/ folder.
