package com.yourcompany.englishpractice.presentation.lesson

import androidx.compose.animation.Crossfade
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.yourcompany.englishpractice.core.speech.SpeechRecognizerManager
import com.yourcompany.englishpractice.domain.model.FeedbackType
import com.yourcompany.englishpractice.domain.model.Lesson
import com.yourcompany.englishpractice.domain.model.LessonResult

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DailyLessonScreen(
    viewModel: DailyLessonViewModel,
    speechManager: SpeechRecognizerManager,
    onBack: () -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()
    val isListening by speechManager.isListening.collectAsState()
    val transcribedText by speechManager.transcribedText.collectAsState()

    LaunchedEffect(isListening, transcribedText) {
        if (uiState.step == LessonStep.LISTENING && !isListening && transcribedText.isNotBlank()) {
            viewModel.onSpeechFinished(transcribedText)
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Daily Lesson") },
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.Filled.ArrowBack, contentDescription = "Back") } }
            )
        }
    ) { padding ->
        Crossfade(targetState = uiState.step, modifier = Modifier.fillMaxSize().padding(padding).padding(24.dp)) { currentStep ->
            when (currentStep) {
                LessonStep.PROMPT -> PromptView(uiState.lesson) {
                    viewModel.startListening()
                    speechManager.startListening()
                }
                LessonStep.LISTENING -> ListeningView(transcribedText)
                LessonStep.RESULT -> uiState.result?.let { result ->
                    ResultView(result, uiState.lesson.targetPhrase) {
                        viewModel.resetLesson()
                    }
                }
            }
        }
    }
}

@Composable
private fun PromptView(lesson: Lesson, onStart: () -> Unit) {
    Column(modifier = Modifier.fillMaxSize(), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.Center) {
        Text("Say this phrase:", style = MaterialTheme.typography.titleMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
        Spacer(modifier = Modifier.height(16.dp))
        Card(modifier = Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
            Text(lesson.targetPhrase, style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold, textAlign = TextAlign.Center, modifier = Modifier.padding(24.dp).fillMaxWidth())
        }
        Spacer(modifier = Modifier.height(48.dp))
        Button(onClick = onStart, modifier = Modifier.size(100.dp), shape = MaterialTheme.shapes.extraLarge, contentPadding = PaddingValues(0.dp)) {
            Icon(Icons.Filled.Mic, contentDescription = "Start Speaking", modifier = Modifier.size(48.dp))
        }
        Spacer(modifier = Modifier.height(16.dp))
        Text("Tap to start speaking", style = MaterialTheme.typography.bodyMedium)
    }
}

@Composable
private fun ListeningView(transcribedText: String) {
    Column(modifier = Modifier.fillMaxSize(), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.Center) {
        Text("Listening...", style = MaterialTheme.typography.headlineMedium, color = MaterialTheme.colorScheme.primary)
        Spacer(modifier = Modifier.height(32.dp))
        Icon(Icons.Filled.Mic, contentDescription = null, tint = MaterialTheme.colorScheme.error, modifier = Modifier.size(80.dp))
        Spacer(modifier = Modifier.height(32.dp))
        Text(if (transcribedText.isNotEmpty()) "\"$transcribedText\"" else "Speak clearly", style = MaterialTheme.typography.bodyLarge, textAlign = TextAlign.Center, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
}

@Composable
private fun ResultView(result: LessonResult, targetPhrase: String, onTryAgain: () -> Unit) {
    Column(modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Spacer(modifier = Modifier.height(16.dp))
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text("${result.accuracyScore}%", style = MaterialTheme.typography.displayLarge, fontWeight = FontWeight.Black, color = getScoreColor(result.feedback))
            Text(getFeedbackText(result.feedback), style = MaterialTheme.typography.headlineSmall, color = getScoreColor(result.feedback))
        }
        if (!result.detailedFeedback.isNullOrBlank()) {
            Card(modifier = Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Row(modifier = Modifier.padding(16.dp), verticalAlignment = Alignment.Top) {
                    Icon(Icons.Filled.School, contentDescription = null, tint = MaterialTheme.colorScheme.onPrimaryContainer)
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(result.detailedFeedback, style = MaterialTheme.typography.bodyLarge, color = MaterialTheme.colorScheme.onPrimaryContainer)
                }
            }
        }
        Card(modifier = Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("Target:", style = MaterialTheme.typography.labelMedium, color = MaterialTheme.colorScheme.primary)
                Text(targetPhrase, style = MaterialTheme.typography.bodyLarge, fontWeight = FontWeight.SemiBold)
                Spacer(modifier = Modifier.height(12.dp))
                HorizontalDivider()
                Spacer(modifier = Modifier.height(12.dp))
                Text("You said:", style = MaterialTheme.typography.labelMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
                Text(result.spokenText, style = MaterialTheme.typography.bodyLarge)
            }
        }
        Button(onClick = onTryAgain, modifier = Modifier.fillMaxWidth().height(56.dp), shape = MaterialTheme.shapes.large) {
            Icon(Icons.Filled.Refresh, contentDescription = null)
            Spacer(modifier = Modifier.width(8.dp))
            Text("Try Again", style = MaterialTheme.typography.titleMedium)
        }
        Spacer(modifier = Modifier.height(16.dp))
    }
}

private fun getScoreColor(feedback: FeedbackType): Color = when (feedback) {
    FeedbackType.PERFECT -> Color(0xFF4CAF50)
    FeedbackType.GREAT -> Color(0xFF8BC34A)
    FeedbackType.GOOD -> Color(0xFFFFC107)
    FeedbackType.NEEDS_PRACTICE -> Color(0xFFF44336)
}

private fun getFeedbackText(feedback: FeedbackType): String = when (feedback) {
    FeedbackType.PERFECT -> "Perfect!"
    FeedbackType.GREAT -> "Great job!"
    FeedbackType.GOOD -> "Good effort!"
    FeedbackType.NEEDS_PRACTICE -> "Keep practicing!"
}
