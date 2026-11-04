package com.hooligan97.diablostash.native

object NativeBridge {
    init {
        System.loadLibrary("stash_native")
    }

    external fun parseStash(data: ByteArray, profile: Int): String
    external fun serializeStash(jsonData: String, profile: Int): ByteArray?
    external fun getLastStatus(): String
}