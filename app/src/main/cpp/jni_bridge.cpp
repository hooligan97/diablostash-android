#include <jni.h>
#include <string>
#include <vector>
#include <android/log.h>
#include <sstream>
#include <iomanip>
#include <mutex>

#include "stash_parser.h"

#define LOG_TAG "StashNative"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

namespace {

std::mutex g_mutex;
stash::StashData g_lastStash;
stash::Profile g_lastProfile = stash::Profile::Diablo;

std::string escapeJson(const std::string& s) {
    std::string out;
    for (char c : s) {
        switch (c) {
            case '"': out += "\\\""; break;
            case '\\': out += "\\\\"; break;
            case '\n': out += "\\n"; break;
            case '\r': out += "\\r"; break;
            default: out += c;
        }
    }
    return out;
}

std::string toJson(const stash::StashData& result) {
    std::ostringstream json;
    json << "{";
    if (!result.error.empty()) {
        json << "\"error\":\"" << escapeJson(result.error) << "\",";
    }
    json << "\"status\":\"" << (result.error.empty() ? "ok" : "partial") << "\","
         << "\"version\":" << static_cast<int>(result.version) << ","
         << "\"gold\":" << result.gold << ","
         << "\"pageCount\":" << result.pages.size() << ","
         << "\"itemCount\":" << result.itemCount << ","
         << "\"currentPage\":" << result.currentPage << ","
         << "\"itemBytes\":" << result.rawItems.size() << ","
         << "\"pages\":[";
    for (size_t i = 0; i < result.pages.size(); ++i) {
        const auto& page = result.pages[i];
        if (i) json << ",";
        int occupied = 0;
        std::ostringstream cells;
        cells << "[";
        bool first = true;
        for (int c = 0; c < 100; ++c) {
            uint16_t cell = page.grid[c];
            if (cell != 0xFFFF) {
                ++occupied;
                if (!first) cells << ",";
                cells << "{\"idx\":" << c << ",\"item\":" << (cell - 1) << "}";
                first = false;
            }
        }
        cells << "]";
        json << "{\"pageIndex\":" << page.pageIndex
             << ",\"occupied\":" << occupied
             << ",\"free\":" << (100 - occupied)
             << ",\"cells\":" << cells.str() << "}";
    }
    json << "]}";
    return json.str();
}

} // namespace

extern "C" {

JNIEXPORT jstring JNICALL
Java_com_hooligan97_diablostash_native_NativeBridge_parseStash(
        JNIEnv *env,
        jobject /* this */,
        jbyteArray data,
        jint profile) {

    if (data == nullptr) {
        return env->NewStringUTF(R"({"error":"null data"})");
    }

    jsize len = env->GetArrayLength(data);
    jbyte *bytes = env->GetByteArrayElements(data, nullptr);
    if (bytes == nullptr) {
        return env->NewStringUTF(R"({"error":"failed to get bytes"})");
    }

    std::vector<uint8_t> buffer(reinterpret_cast<uint8_t*>(bytes),
                                reinterpret_cast<uint8_t*>(bytes) + len);
    env->ReleaseByteArrayElements(data, bytes, JNI_ABORT);

    auto prof = static_cast<stash::Profile>(profile);
    auto result = stash::parseDecodedStash(buffer, prof);

    {
        std::lock_guard<std::mutex> lock(g_mutex);
        g_lastStash = result;
        g_lastProfile = prof;
    }

    return env->NewStringUTF(toJson(result).c_str());
}

JNIEXPORT jbyteArray JNICALL
Java_com_hooligan97_diablostash_native_NativeBridge_serializeStash(
        JNIEnv *env,
        jobject /* this */,
        jstring /* jsonData */,
        jint profile) {

    stash::StashData toSerialize;
    {
        std::lock_guard<std::mutex> lock(g_mutex);
        toSerialize = g_lastStash;
    }

    // If no previous parse, produce empty valid stash
    if (toSerialize.pages.empty() && toSerialize.itemCount == 0 && toSerialize.error.empty()) {
        toSerialize.version = 0;
        toSerialize.gold = 0;
        toSerialize.currentPage = 0;
    }

    auto out = stash::serializeStash(toSerialize, static_cast<stash::Profile>(profile));

    jbyteArray result = env->NewByteArray(static_cast<jsize>(out.size()));
    if (result != nullptr) {
        env->SetByteArrayRegion(result, 0, static_cast<jsize>(out.size()),
                                reinterpret_cast<const jbyte*>(out.data()));
    }
    return result;
}

JNIEXPORT jstring JNICALL
Java_com_hooligan97_diablostash_native_NativeBridge_getLastStatus(
        JNIEnv *env,
        jobject /* this */) {
    std::lock_guard<std::mutex> lock(g_mutex);
    return env->NewStringUTF(toJson(g_lastStash).c_str());
}

} // extern "C"
