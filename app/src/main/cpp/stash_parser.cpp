#include "stash_parser.h"
#include <cstring>
#include <sstream>

namespace stash {

namespace {

constexpr uint8_t StashVersion = 0;
constexpr size_t DiabloItemSaveSize = 368;
constexpr size_t HellfireItemSaveSize = 372;
constexpr uint16_t EmptyCell = 0xFFFF;

template<typename T>
T readLE(const uint8_t*& ptr, const uint8_t* end, bool& ok) {
    if (ptr + sizeof(T) > end) {
        ok = false;
        return T{};
    }
    T value;
    std::memcpy(&value, ptr, sizeof(T));
    ptr += sizeof(T);
    return value;
}

template<typename T>
void writeLE(std::vector<uint8_t>& out, T value) {
    const uint8_t* bytes = reinterpret_cast<const uint8_t*>(&value);
    out.insert(out.end(), bytes, bytes + sizeof(T));
}

size_t itemSizeFor(Profile profile) {
    return profile == Profile::Hellfire ? HellfireItemSaveSize : DiabloItemSaveSize;
}

} // namespace

StashData parseDecodedStash(const std::vector<uint8_t>& data, Profile profile) {
    StashData result;
    if (data.empty()) {
        result.error = "empty data";
        return result;
    }

    const uint8_t* ptr = data.data();
    const uint8_t* end = ptr + data.size();
    bool ok = true;

    result.version = readLE<uint8_t>(ptr, end, ok);
    if (!ok || result.version > StashVersion) {
        result.error = "invalid or unsupported version";
        return result;
    }

    result.gold = readLE<uint32_t>(ptr, end, ok);
    if (!ok) {
        result.error = "truncated after version";
        return result;
    }

    uint32_t pageCount = readLE<uint32_t>(ptr, end, ok);
    if (!ok) {
        result.error = "truncated at page count";
        return result;
    }

    // Reasonable limit to prevent OOM on corrupted data
    if (pageCount > 1000) {
        result.error = "unreasonable page count";
        return result;
    }

    for (uint32_t i = 0; i < pageCount && ok; ++i) {
        StashPage page;
        page.pageIndex = readLE<uint32_t>(ptr, end, ok);
        if (!ok) break;
        page.grid.resize(100, EmptyCell);
        for (int c = 0; c < 100 && ok; ++c) {
            page.grid[c] = readLE<uint16_t>(ptr, end, ok);
        }
        if (ok) result.pages.push_back(std::move(page));
    }
    if (!ok) {
        result.error = "truncated while reading pages/grids";
        return result;
    }

    result.itemCount = readLE<uint32_t>(ptr, end, ok);
    if (!ok) {
        result.error = "truncated at item count";
        return result;
    }

    if (result.itemCount > 10000) {
        result.error = "unreasonable item count";
        return result;
    }

    const size_t itemSize = itemSizeFor(profile);
    const size_t itemBytes = static_cast<size_t>(result.itemCount) * itemSize;
    if (ptr + itemBytes > end) {
        result.error = "truncated item data";
        return result;
    }
    result.rawItems.assign(ptr, ptr + itemBytes);
    ptr += itemBytes;

    if (ptr + sizeof(uint32_t) <= end) {
        result.currentPage = readLE<uint32_t>(ptr, end, ok);
    }

    // Exact size check (DevilutionX IsStashSizeValid)
    // If mismatch, treat as invalid (matches LoadStash behavior of clearing data)
    const size_t expected = 1u
        + 4u + 4u
        + (4u + 100u * 2u) * pageCount
        + 4u
        + itemBytes
        + 4u;
    if (data.size() != expected) {
        result.error = "size mismatch (expected " + std::to_string(expected) +
                       ", got " + std::to_string(data.size()) + ")";
        // Clear parsed content on size error to match DevilutionX
        result.pages.clear();
        result.rawItems.clear();
        result.itemCount = 0;
        result.gold = 0;
        result.currentPage = 0;
        return result;
    }

    if (!ok) {
        result.error = "truncated at current page";
    }

    return result;
}

std::vector<uint8_t> serializeStash(const StashData& stash, Profile profile) {
    std::vector<uint8_t> out;
    writeLE<uint8_t>(out, stash.version);
    writeLE<uint32_t>(out, stash.gold);
    writeLE<uint32_t>(out, static_cast<uint32_t>(stash.pages.size()));
    for (const auto& page : stash.pages) {
        writeLE<uint32_t>(out, page.pageIndex);
        // Ensure exactly 100 cells
        for (int c = 0; c < 100; ++c) {
            uint16_t cell = (c < static_cast<int>(page.grid.size())) ? page.grid[c] : EmptyCell;
            writeLE<uint16_t>(out, cell);
        }
    }
    writeLE<uint32_t>(out, stash.itemCount);
    out.insert(out.end(), stash.rawItems.begin(), stash.rawItems.end());
    writeLE<uint32_t>(out, stash.currentPage);
    return out;
}

} // namespace stash
