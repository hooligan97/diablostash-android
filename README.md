# diablostash-android

Android app (Kotlin + Jetpack Compose + NDK C++) for viewing and managing DevilutionX / Diablo + Hellfire stash files.

## Architecture

- **C++** (`app/src/main/cpp/`): parser matching DevilutionX `LoadStash` / `SaveStash` / `IsStashSizeValid` for the decoded `spstashitems` / `mpstashitems` payload.
- **JNI**: thin bridge. Keeps last parsed `StashData` for proper round-trip serialization. Returns JSON with gold, pages, occupied cells, free slots.
- **Kotlin + Compose**: Storage Access Framework open + export (always new file). Visual 10×10 grid preview. Profile switch (Diablo 368 B / Hellfire 372 B).

## Format (decoded payload)

```
uint8_t  version          // StashVersion = 0
uint32_t gold
uint32_t pageCount
for each page:
    uint32_t pageIndex
    uint16_t grid[100]    // 10×10; value = itemIndex+1 or 0xFFFF (EmptyCell)
uint32_t itemCount
uint8_t  items[itemCount * (368|372)]
uint32_t currentPage
```

Exact size is validated (matches DevilutionX `IsStashSizeValid`). Raw item blobs are preserved for perfect round-trip.

## Current capabilities

- Parse decoded stash payloads (version, gold, multi-page 10×10 grids, item count, current page).
- Show free/occupied counts and a simple visual grid.
- Export a byte-identical copy of the last parsed stash (new file via SAF — never overwrites original).
- Empty demo payload (17 bytes) matches DevilutionX empty stash.
- Profile-aware item size (368 Diablo / 372 Hellfire).
- Guards against unreasonable page/item counts on corrupted input.
- Standalone C++ round-trip tests verified against the format.

## Build

Requires Android Studio with NDK r26+, CMake 3.22+, JDK 17.

Gradle wrapper is included:

```bash
./gradlew assembleDebug
```

**CI:** GitHub Actions (`.github/workflows/android.yml`) builds the debug APK (including NDK) on every push/PR to `main` and uploads the artifact.

Always work on **copies** of stash files. Never overwrite originals.

## Notes

- Input must be the **decoded** payload of `spstashitems`/`mpstashitems` (after MPQ extract + codec_decode).
- Full item structure interpretation is future work; currently raw blobs are preserved for perfect round-trip.
- Profile (Diablo/Hellfire) must match the source file for correct item size validation.
- Export always creates a new file selected by the user.

## References

Based on DevilutionX `Source/loadsave.cpp` (`LoadStash`, `SaveStash`, `IsStashSizeValid`, `DiabloItemSaveSize`/`HellfireItemSaveSize`) and `Source/qol/stash.h`.

## Verification

Standalone C++ tests (`tests/test_parser.cpp`) confirm exact compatibility with DevilutionX:

- Empty stash (17 bytes) round-trips perfectly.
- Single-page and multi-page payloads with items match `IsStashSizeValid` size formula.
- Size mismatch clears data (same as `LoadStash`).
- Diablo (368 B) and Hellfire (372 B) item sizes handled correctly.
- Grid cells: `itemIndex + 1` or `0xFFFF` (EmptyCell).

```bash
cd tests && cmake -S . -B build && cmake --build build && ./build/test_parser
```

All tests pass against the current DevilutionX `LoadStash` / `SaveStash` / `IsStashSizeValid` implementation.
