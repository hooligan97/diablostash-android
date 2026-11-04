package com.hooligan97.diablostash

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.darkColorScheme
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import com.hooligan97.diablostash.ui.StashScreen

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme(
                colorScheme = darkColorScheme(
                    primary = Color(0xFFAA5500),
                    background = Color(0xFF1A0F0A),
                    surface = Color(0xFF2A1F1A)
                )
            ) {
                Surface(modifier = Modifier.fillMaxSize()) {
                    StashScreen()
                }
            }
        }
    }
}