#include <iostream>
#include <vector>
#include <cstdint>
#include <cstring>
#include <cassert>

// Minimal copy of the parser logic for verification (or include if path works)
// We'll compile against the real sources.

#include "/workspace/artifacts/diablostash-android/app/src/main/cpp/stash_parser.h"

using namespace stash;

void writeLE32(std::vector<uint8_t>& out, uint32_t v) {
    out.push_back(v & 0xFF);
    out.push_back((v >> 8) & 0xFF);
    out.push_back((v >> 16) & 0xFF);
    out.push_back((v >> 24) & 0xFF);
}

void writeLE16(std::vector<uint8_t>& out, uint16_t v) {
    out.push_back(v & 0xFF);
    out.push_back((v >> 8) & 0xFF);
}

std::vector<uint8_t> makeEmpty() {
    std::vector<uint8_t> d;
    d.push_back(0); // version
    writeLE32(d, 0); // gold
    writeLE32(d, 0); // pages
    writeLE32(d, 0); // items
    writeLE32(d, 0); // current
    return d;
}

std::vector<uint8_t> makeOnePage(uint32_t gold, uint32_t pageIdx, uint32_t current, bool hellfire) {
    std::vector<uint8_t> d;
    d.push_back(0);
    writeLE32(d, gold);
    writeLE32(d, 1); // 1 page
    writeLE32(d, pageIdx);
    // 100 cells: first cell has item 0 (value 1), rest empty
    writeLE16(d, 1); // itemIndex+1
    for (int i = 1; i < 100; ++i) writeLE16(d, 0xFFFF);
    writeLE32(d, 1); // 1 item
    size_t itemSize = hellfire ? 372 : 368;
    for (size_t i = 0; i < itemSize; ++i) d.push_back(static_cast<uint8_t>(i & 0xFF));
    writeLE32(d, current);
    return d;
}

int main() {
    // Test 1: empty
    auto empty = makeEmpty();
    assert(empty.size() == 17);
    auto r = parseDecodedStash(empty, Profile::Diablo);
    assert(r.error.empty());
    assert(r.gold == 0);
    assert(r.pages.empty());
    assert(r.itemCount == 0);
    assert(r.currentPage == 0);
    auto ser = serializeStash(r, Profile::Diablo);
    assert(ser == empty);
    std::cout << "Empty round-trip OK (" << ser.size() << " bytes)\n";

    // Test 2: one page with item (Diablo)
    auto one = makeOnePage(12345, 2, 2, false);
    size_t expected = 1+4+4 + (4+200) + 4 + 368 + 4;
    assert(one.size() == expected);
    r = parseDecodedStash(one, Profile::Diablo);
    assert(r.error.empty());
    assert(r.gold == 12345);
    assert(r.pages.size() == 1);
    assert(r.pages[0].pageIndex == 2);
    assert(r.pages[0].grid[0] == 1);
    assert(r.pages[0].grid[1] == 0xFFFF);
    assert(r.itemCount == 1);
    assert(r.rawItems.size() == 368);
    assert(r.currentPage == 2);
    ser = serializeStash(r, Profile::Diablo);
    assert(ser == one);
    std::cout << "One-page Diablo round-trip OK (" << ser.size() << " bytes)\n";

    // Test 3: Hellfire size
    auto hf = makeOnePage(0, 0, 0, true);
    r = parseDecodedStash(hf, Profile::Hellfire);
    assert(r.error.empty());
    assert(r.rawItems.size() == 372);
    ser = serializeStash(r, Profile::Hellfire);
    assert(ser == hf);
    std::cout << "One-page Hellfire round-trip OK (" << ser.size() << " bytes)\n";

    // Test 4: size mismatch should clear
    auto bad = one;
    bad.pop_back(); // truncate
    r = parseDecodedStash(bad, Profile::Diablo);
    assert(!r.error.empty());
    assert(r.pages.empty());
    assert(r.itemCount == 0);
    std::cout << "Size mismatch correctly rejected: " << r.error << "\n";

    // Test 5: multi-page empty pages not present (as SaveStash does)
    std::vector<uint8_t> multi;
    multi.push_back(0);
    writeLE32(multi, 999);
    writeLE32(multi, 2); // 2 pages
    // page 5
    writeLE32(multi, 5);
    for (int i = 0; i < 100; ++i) writeLE16(multi, 0xFFFF);
    // page 10 with item
    writeLE32(multi, 10);
    writeLE16(multi, 1);
    for (int i = 1; i < 100; ++i) writeLE16(multi, 0xFFFF);
    writeLE32(multi, 1);
    for (int i = 0; i < 368; ++i) multi.push_back(0xAB);
    writeLE32(multi, 10);
    r = parseDecodedStash(multi, Profile::Diablo);
    assert(r.error.empty());
    assert(r.pages.size() == 2);
    assert(r.pages[0].pageIndex == 5);
    assert(r.pages[1].pageIndex == 10);
    assert(r.pages[1].grid[0] == 1);
    ser = serializeStash(r, Profile::Diablo);
    assert(ser == multi);
    std::cout << "Multi-page round-trip OK\n";

    std::cout << "\nAll tests passed. Parser matches DevilutionX LoadStash/SaveStash/IsStashSizeValid.\n";
    return 0;
}
