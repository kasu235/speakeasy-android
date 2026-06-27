package com.yourcompany.englishpractice

import android.Manifest
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.navigation.compose.rememberNavController
import com.yourcompany.englishpractice.core.ui.theme.EnglishPracticeTheme
import com.yourcompany.englishpractice.core.util.PermissionManager
import com.yourcompany.englishpractice.data.local.LessonDataSource
import com.yourcompany.englishpractice.presentation.navigation.AppNavHost
import com.yourcompany.englishpractice.presentation.onboarding.OnboardingScreen
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class MainActivity : ComponentActivity() {

    @Inject
    lateinit var lessonDataSource: LessonDataSource

    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted: Boolean ->
        if (!isGranted) {
            Toast.makeText(this, "Microphone permission required", Toast.LENGTH_LONG).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            EnglishPracticeTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    var showOnboarding by remember { mutableStateOf(true) }

                    if (showOnboarding) {
                        OnboardingScreen(onComplete = {
                            showOnboarding = false
                            requestMicrophonePermission()
                        })
                    } else {
                        val navController = rememberNavController()
                        AppNavHost(
                            navController = navController,
                            lessonDataSource = lessonDataSource
                        )
                    }
                }
            }
        }
    }

    private fun requestMicrophonePermission() {
        if (!PermissionManager.hasMicrophonePermission(this)) {
            requestPermissionLauncher.launch(Manifest.permission.RECORD_AUDIO)
        }
    }
}
