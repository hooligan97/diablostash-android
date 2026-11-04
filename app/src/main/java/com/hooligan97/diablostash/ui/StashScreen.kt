package com.hooligan97.diablostash.ui

import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.hooligan97.diablostash.native.NativeBridge
import org.json.JSONObject
import java.io.BufferedInputStream

@Composable
fun StashScreen() {
    val context = LocalContext.current
    var result by remember { mutableStateOf("Load a decoded stash payload (spstashitems / mpstashitems)") }
    var gold by remember { mutableStateOf(0) }
    var pageCount by remember { mutableStateOf(0) }
    var itemCount by remember { mutableStateOf(0) }
    var currentPage by remember { mutableStateOf(0) }
    var lastBytes by remember { mutableStateOf<ByteArray?>(null) }
    var profile by remember { mutableIntStateOf(0) } // 0=Diablo, 1=Hellfire
    var fileName by remember { mutableStateOf<String?>(null) }
    var statusOk by remember { mutableStateOf(false) }
    var selectedPage by remember { mutableIntStateOf(0) }
    var pagesJson by remember { mutableStateOf("") }

    val openDocument = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.OpenDocument()
    ) { uri: Uri? ->
        if (uri == null) return@rememberLauncherForActivityResult
        try {
            context.contentResolver.openInputStream(uri)?.use { stream ->
                val bytes = BufferedInputStream(stream).readBytes()
                fileName = uri.lastPathSegment ?: "unknown"
                lastBytes = bytes
                val json = NativeBridge.parseStash(bytes, profile)
                result = json
                val obj = try { JSONObject(json) } catch (_: Exception) { null }
                statusOk = obj?.optString("status") == "ok"
                parseSummary(json) { g, pc, ic, cp, pj ->
                    gold = g
                    pageCount = pc
                    itemCount = ic
                    currentPage = cp
                    pagesJson = pj
                    selectedPage = 0
                }
            }
        } catch (e: Exception) {
            result = "Error reading file: ${e.message}"
            statusOk = false
        }
    }

    val createDocument = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.CreateDocument("application/octet-stream")
    ) { uri: Uri? ->
        if (uri == null) return@rememberLauncherForActivityResult
        try {
            val data = NativeBridge.serializeStash("", profile)
            if (data != null) {
                context.contentResolver.openOutputStream(uri)?.use { out ->
                    out.write(data)
                }
                result = "Exported ${data.size} bytes to new file (backup created by user choice of location)."
            }
        } catch (e: Exception) {
            result = "Export error: ${e.message}"
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Diablo Stash Tool", style = MaterialTheme.typography.headlineMedium)
        Text("Decoded payload parser · Diablo 368B / Hellfire 372B", style = MaterialTheme.typography.bodyMedium)

        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            FilterChip(selected = profile == 0, onClick = {
                profile = 0
                lastBytes?.let { bytes ->
                    val json = NativeBridge.parseStash(bytes, 0)
                    result = json
                    val obj = try { JSONObject(json) } catch (_: Exception) { null }
                    statusOk = obj?.optString("status") == "ok"
                    parseSummary(json) { g, pc, ic, cp, pj ->
                        gold = g
                        pageCount = pc
                        itemCount = ic
                        currentPage = cp
                        pagesJson = pj
                        selectedPage = 0
                    }
                }
            }, label = { Text("Diablo") })
            FilterChip(selected = profile == 1, onClick = {
                profile = 1
                lastBytes?.let { bytes ->
                    val json = NativeBridge.parseStash(bytes, 1)
                    result = json
                    val obj = try { JSONObject(json) } catch (_: Exception) { null }
                    statusOk = obj?.optString("status") == "ok"
                    parseSummary(json) { g, pc, ic, cp, pj ->
                        gold = g
                        pageCount = pc
                        itemCount = ic
                        currentPage = cp
                        pagesJson = pj
                        selectedPage = 0
                    }
                }
            }, label = { Text("Hellfire") })
        }

        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = { openDocument.launch(arrayOf("*/*")) }) {
                Text("Open Payload")
            }
            Button(
                onClick = { createDocument.launch("stash_export.bin") },
                enabled = statusOk
            ) {
                Text("Export Copy")
            }
        }

        fileName?.let { Text("File: $it", style = MaterialTheme.typography.bodySmall) }

        Card(modifier = Modifier.fillMaxWidth()) {
            Column(Modifier.padding(12.dp), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Text("Gold: $gold", style = MaterialTheme.typography.titleMedium)
                Text("Pages: $pageCount")
                Text("Items: $itemCount")
                Text("Current page: $currentPage")
                Text(
                    if (statusOk) "Status: ok" else "Status: error / invalid",
                    color = if (statusOk) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.error
                )
                val err = try { JSONObject(result).optString("error", "") } catch (_: Exception) { "" }
                if (err.isNotEmpty()) {
                    Text("Error: $err", color = MaterialTheme.colorScheme.error, style = MaterialTheme.typography.bodySmall)
                }
            }
        }

        if (pageCount > 0) {
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Button(onClick = { if (selectedPage > 0) selectedPage-- }, enabled = selectedPage > 0) {
                    Text("<")
                }
                Text("Page $selectedPage / ${pageCount - 1}")
                Button(onClick = { if (selectedPage < pageCount - 1) selectedPage++ }, enabled = selectedPage < pageCount - 1) {
                    Text(">")
                }
            }
            StashGridPreview(pagesJson, selectedPage)
        }

        Text(
            result,
            style = MaterialTheme.typography.bodySmall,
            modifier = Modifier.fillMaxWidth()
        )

        Button(onClick = {
            val empty = byteArrayOf(
                0,                      // version
                0, 0, 0, 0,             // gold
                0, 0, 0, 0,             // pageCount
                0, 0, 0, 0,             // itemCount
                0, 0, 0, 0              // currentPage
            )
            lastBytes = empty
            val json = NativeBridge.parseStash(empty, profile)
            result = json
            statusOk = json.contains("\"status\":\"ok\"")
            parseSummary(json) { g, pc, ic, cp, pj ->
                gold = g
                pageCount = pc
                itemCount = ic
                currentPage = cp
                pagesJson = pj
                selectedPage = 0
            }
            fileName = "empty demo (17 B)"
        }) {
            Text("Parse Empty Demo (17 B)")
        }

        Text(
            "Works on decoded spstashitems/mpstashitems (after MPQ + codec). " +
            "Never overwrites originals — export always creates a new file. " +
            "Raw item blobs are preserved for round-trip.",
            style = MaterialTheme.typography.labelSmall
        )
    }
}

private fun parseSummary(
    json: String,
    onResult: (gold: Int, pages: Int, items: Int, current: Int, pagesJson: String) -> Unit
) {
    try {
        val obj = JSONObject(json)
        val g = obj.optInt("gold", 0)
        val pc = obj.optInt("pageCount", 0)
        val ic = obj.optInt("itemCount", 0)
        val cp = obj.optInt("currentPage", 0)
        val pages = obj.optJSONArray("pages")?.toString() ?: "[]"
        onResult(g, pc, ic, cp, pages)
    } catch (_: Exception) {
        onResult(0, 0, 0, 0, "[]")
    }
}

@Composable
private fun StashGridPreview(pagesJson: String, pageIndex: Int) {
    val occupied = remember(pagesJson, pageIndex) {
        try {
            val arr = org.json.JSONArray(pagesJson)
            if (pageIndex in 0 until arr.length()) {
                val page = arr.getJSONObject(pageIndex)
                val cells = page.optJSONArray("cells") ?: return@remember emptySet()
                (0 until cells.length()).map { cells.getJSONObject(it).getInt("idx") }.toSet()
            } else emptySet()
        } catch (_: Exception) {
            emptySet()
        }
    }

    Canvas(
        modifier = Modifier
            .size(280.dp)
            .background(Color(0xFF1A1A1A))
            .border(1.dp, Color(0xFF444444))
    ) {
        val cellSize = size.width / 10f
        for (y in 0 until 10) {
            for (x in 0 until 10) {
                val idx = y * 10 + x
                val color = if (occupied.contains(idx)) Color(0xFFAA5500) else Color(0xFF333333)
                drawRect(
                    color = color,
                    topLeft = androidx.compose.ui.geometry.Offset(x * cellSize, y * cellSize),
                    size = androidx.compose.ui.geometry.Size(cellSize - 1f, cellSize - 1f)
                )
            }
        }
    }
}
