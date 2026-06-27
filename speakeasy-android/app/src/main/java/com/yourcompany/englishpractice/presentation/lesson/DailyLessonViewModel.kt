package com.yourcompany.englishpractice.presentation.lesson

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.yourcompany.englishpractice.core.speech.SpeechRecognizerManager
import com.yourcompany.englishpractice.data.repository.UserProgressRepositoryImpl
import com.yourcompany.englishpractice.domain.model.Lesson
import com.yourcompany.englishpractice.domain.model.LessonResult
import com.yourcompany.englishpractice.domain.usecase.AiPronunciationEvaluationUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

enum class LessonStep { PROMPT, LISTENING, RESULT }

data class DailyLessonUiState(
    val lesson: Lesson = Lesson("1", "travel", "How do you politely order a coffee?", "I would like a cup of coffee, please.", 2),
    val step: LessonStep = LessonStep.PROMPT,
    val result: LessonResult? = null
)

@HiltViewModel
class DailyLessonViewModel @Inject constructor(
    private val aiEvaluationUseCase: AiPronunciationEvaluationUseCase,
    private val progressRepository: UserProgressRepositoryImpl,
    val speechManager: SpeechRecognizerManager
) : ViewModel() {

    private val _uiState = MutableStateFlow(DailyLessonUiState())
    val uiState: StateFlow<DailyLessonUiState> = _uiState.asStateFlow()

    fun startListening() {
        _uiState.update { it.copy(step = LessonStep.LISTENING, result = null) }
    }

    fun onSpeechFinished(spokenText: String) {
        viewModelScope.launch {
            val currentLesson = _uiState.value.lesson
            val result = aiEvaluationUseCase(currentLesson.id, currentLesson.targetPhrase, spokenText)
            progressRepository.saveLessonResult(currentLesson.id, currentLesson.categoryId, result)
            _uiState.update { it.copy(step = LessonStep.RESULT, result = result) }
        }
    }

    fun resetLesson() {
        _uiState.update { it.copy(step = LessonStep.PROMPT, result = null) }
    }
}
