package com.yourcompany.englishpractice.presentation.freetalk

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.yourcompany.englishpractice.core.speech.SpeechRecognizerManager
import com.yourcompany.englishpractice.core.speech.TextToSpeechManager
import com.yourcompany.englishpractice.data.remote.ChatMessage
import com.yourcompany.englishpractice.data.remote.ChatRequest
import com.yourcompany.englishpractice.data.remote.LlmApiService
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

data class FreeTalkUiState(
    val isLoading: Boolean = false,
    val aiResponse: String = "Hello! I am your AI English partner. What would you like to talk about today?",
    val error: String? = null
)

@HiltViewModel
class FreeTalkViewModel @Inject constructor(
    private val apiService: LlmApiService,
    val ttsManager: TextToSpeechManager,
    val speechManager: SpeechRecognizerManager
) : ViewModel() {

    private val _uiState = MutableStateFlow(FreeTalkUiState())
    val uiState: StateFlow<FreeTalkUiState> = _uiState.asStateFlow()

    private val conversationHistory = mutableListOf(
        ChatMessage("system", "You are a friendly English conversation partner. Keep responses concise.")
    )

    fun sendSpokenTextToAi(userText: String) {
        if (userText.isBlank()) return
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true, error = null) }
            conversationHistory.add(ChatMessage("user", userText))
            try {
                val response = apiService.getChatCompletion(ChatRequest(messages = conversationHistory))
                val aiText = response.choices.firstOrNull()?.message?.content ?: "Sorry, I did not catch that."
                conversationHistory.add(ChatMessage("assistant", aiText))
                _uiState.update { it.copy(isLoading = false, aiResponse = aiText) }
                ttsManager.speak(aiText)
            } catch (e: Exception) {
                _uiState.update { it.copy(isLoading = false, error = "Network error.") }
            }
        }
    }

    override fun onCleared() {
        super.onCleared()
        ttsManager.destroy()
    }
}
