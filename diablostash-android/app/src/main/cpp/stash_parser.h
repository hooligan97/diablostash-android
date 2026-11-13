#pragma once

#include <cstdint>
#include <string>
#include <vector>

namespace stash {

enum class Profile { Diablo = 0, Hellfire = 1 };

struct StashPage {
    uint32_t pageIndex = 0;
    std::vector<uint16_t> grid; // 10x10 = 100 cells; value = itemIndex+1 or 0xFFFF
};

struct StashData {
    uint8_t version = 0;
    uint32_t gold = 0;
    std::vector<StashPage> pages;
    uint32_t itemCount = 0;
    std::vector<uint8_t> rawItems; // raw item blobs for round-trip
    uint32_t currentPage = 0;
    std::string error;
};

// Parse the decoded "spstashitems"/"mpstashitems" binary payload
// (after MPQ extract + codec_decode)
StashData parseDecodedStash(const std::vector<uint8_t>& data, Profile profile);

// Serialize back to the same binary format (items kept as raw bytes)
std::vector<uint8_t> serializeStash(const StashData& stash, Profile profile);

} // namespace stash
