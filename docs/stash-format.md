# Stash format (decoded payload)

Based on DevilutionX `Source/loadsave.cpp` (`LoadStash` / `SaveStash` / `IsStashSizeValid`) and `Source/qol/stash.h`.

## Layout

| Offset | Type | Description |
|--------|------|-------------|
| 0 | uint8_t | version (StashVersion = 0) |
| 1 | uint32_t | gold |
| 5 | uint32_t | pageCount |
| ... | ... | for each page: uint32_t pageIndex + uint16_t[100] grid |
| ... | uint32_t | itemCount |
| ... | bytes | itemCount * itemSize raw Item blobs |
| end-4 | uint32_t | currentPage |

- Grid cell: `itemId + 1` or `0xFFFF` (`StashStruct::EmptyCell = -1`).
- Item size: 368 (Diablo) / 372 (Hellfire).
- Exact total size is validated by `IsStashSizeValid`. On mismatch, data is discarded (matches LoadStash).

## Notes

- This is the *decoded* content of `spstashitems` / `mpstashitems` inside the MPQ archive (`stash.sv` / `stash.hsv`).
- Full item interpretation requires the `Item` structure and `LoadItemData` / `PackItem` from DevilutionX.
- Always operate on copies. Never overwrite user originals.
- SaveStash only persists pages that contain at least one non-empty cell.
