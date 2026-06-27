package com.yourcompany.englishpractice.presentation.onboarding

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.School
import androidx.compose.material.icons.filled.SmartToy
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch

data class OnboardingPage(val icon: ImageVector, val title: String, val description: String)

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun OnboardingScreen(onComplete: () -> Unit) {
    val pages = listOf(
        OnboardingPage(Icons.Filled.School, "Welcome to SpeakEasy!", "Your personal AI-powered English speaking coach."),
        OnboardingPage(Icons.Filled.Mic, "Practice Speaking", "Complete daily lessons and get instant pronunciation feedback."),
        OnboardingPage(Icons.Filled.SmartToy, "Chat with AI", "Have natural conversations to build fluency and confidence.")
    )
    val pagerState = rememberPagerState(pageCount = { pages.size })
    val coroutineScope = rememberCoroutineScope()

    Column(modifier = Modifier.fillMaxSize().padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.SpaceBetween) {
        Spacer(modifier = Modifier.height(48.dp))
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.Center) {
            repeat(pages.size) { index ->
                Box(modifier = Modifier.padding(horizontal = 4.dp).size(if (pagerState.currentPage == index) 12.dp else 8.dp)) {
                    Surface(modifier = Modifier.fillMaxSize(), shape = MaterialTheme.shapes.small, color = if (pagerState.currentPage == index) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.3f)) {}
                }
            }
        }
        HorizontalPager(state = pagerState, modifier = Modifier.fillMaxWidth().weight(1f)) { page ->
            Column(modifier = Modifier.fillMaxSize(), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.Center) {
                Icon(pages[page].icon, contentDescription = null, modifier = Modifier.size(120.dp), tint = MaterialTheme.colorScheme.primary)
                Spacer(modifier = Modifier.height(48.dp))
                Text(pages[page].title, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold, textAlign = TextAlign.Center)
                Spacer(modifier = Modifier.height(16.dp))
                Text(pages[page].description, style = MaterialTheme.typography.bodyLarge, textAlign = TextAlign.Center, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
        }
        Column(modifier = Modifier.fillMaxWidth(), horizontalAlignment = Alignment.CenterHorizontally) {
            if (pagerState.currentPage == pages.size - 1) {
                Button(onClick = onComplete, modifier = Modifier.fillMaxWidth().height(56.dp), shape = MaterialTheme.shapes.large) { Text("Get Started", style = MaterialTheme.typography.titleMedium) }
            } else {
                Button(onClick = { coroutineScope.launch { pagerState.animateScrollToPage(pagerState.currentPage + 1) } }, modifier = Modifier.fillMaxWidth().height(56.dp), shape = MaterialTheme.shapes.large) { Text("Next", style = MaterialTheme.typography.titleMedium) }
            }
            Spacer(modifier = Modifier.height(12.dp))
            TextButton(onClick = onComplete) { Text("Skip") }
        }
    }
}
