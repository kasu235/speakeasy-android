package com.yourcompany.englishpractice.presentation.freetalk

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.yourcompany.englishpractice.core.speech.SpeechRecognizerManager
import com.yourcompany.englishpractice.core.speech.TextToSpeechManager

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FreeTalkScreen(
    viewModel: FreeTalkViewModel,
    speechManager: SpeechRecognizerManager,
    ttsManager: TextToSpeechManager,
    onBack: () -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()
    val isListening by speechManager.isListening.collectAsState()
    val transcribedText by speechManager.transcribedText.collectAsState()
    val isAiSpeaking by ttsManager.isSpeaking.collectAsState()

    LaunchedEffect(isListening, transcribedText) {
        if (!isListening && transcribedText.isNotBlank()) {
            viewModel.sendSpokenTextToAi(transcribedText)
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Free Talk AI") },
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.Filled.ArrowBack, contentDescription = "Back") } }
            )
        }
    ) { padding ->
        Column(modifier = Modifier.fillMaxSize().padding(padding).padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.SpaceBetween) {
            Card(modifier = Modifier.fillMaxWidth().weight(1f), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)) {
                Box(modifier = Modifier.padding(16.dp), contentAlignment = Alignment.Center) {
                    if (uiState.isLoading) CircularProgressIndicator()
                    else Text(uiState.aiResponse, style = MaterialTheme.typography.headlineSmall, textAlign = TextAlign.Center)
                }
            }
            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = when {
                    isAiSpeaking -> "AI is speaking..."
                    transcribedText.isNotEmpty() -> "\"$transcribedText\""
                    else -> "Tap the mic and start speaking..."
                },
                style = MaterialTheme.typography.bodyLarge,
                color = if (isAiSpeaking) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(24.dp))
            PulsingMicButton(isListening, isAiSpeaking) {
                if (isAiSpeaking) return@PulsingMicButton
                if (isListening) speechManager.stopListening() else speechManager.startListening()
            }
        }
    }
}

@Composable
private fun PulsingMicButton(isListening: Boolean, isAiSpeaking: Boolean, onClick: () -> Unit) {
    val infiniteTransition = rememberInfiniteTransition(label = "pulse")
    val pulseScale by infiniteTransition.animateFloat(initialValue = 1f, targetValue = 1.4f, animationSpec = infiniteRepeatable(animation = tween(1000, easing = FastOutSlowInEasing), repeatMode = RepeatMode.Restart), label = "scale")
    val pulseAlpha by infiniteTransition.animateFloat(initialValue = 0.6f, targetValue = 0f, animationSpec = infiniteRepeatable(animation = tween(1000, easing = FastOutSlowInEasing), repeatMode = RepeatMode.Restart), label = "alpha")

    Box(contentAlignment = Alignment.Center, modifier = Modifier.size(160.dp)) {
        if (isListening) {
            Box(modifier = Modifier.size(120.dp).scale(pulseScale).alpha(pulseAlpha).background(MaterialTheme.colorScheme.primary, CircleShape))
        }
        FilledIconButton(
            onClick = onClick,
            enabled = !isAiSpeaking,
            modifier = Modifier.size(80.dp),
            shape = CircleShape,
            colors = IconButtonDefaults.filledIconButtonColors(
                containerColor = when {
                    isAiSpeaking -> MaterialTheme.colorScheme.tertiary
                    isListening -> MaterialTheme.colorScheme.error
                    else -> MaterialTheme.colorScheme.primary
                },
                disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant
            )
        ) {
            Icon(
                imageVector = when {
                    isAiSpeaking -> Icons.Filled.VolumeUp
                    isListening -> Icons.Filled.Stop
                    else -> Icons.Filled.Mic
                },
                contentDescription = null,
                modifier = Modifier.size(40.dp),
                tint = Color.White
            )
        }
    }
}
