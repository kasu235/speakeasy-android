package com.yourcompany.englishpractice.domain.model

data class Lesson(
    val id: String,
    val categoryId: String,
    val prompt: String,
    val targetPhrase: String,
    val difficultyLevel: Int
)

data class LessonResult(
    val lessonId: String,
    val spokenText: String,
    val accuracyScore: Int,
    val feedback: FeedbackType,
    val correctedText: String?,
    val detailedFeedback: String? = null,
    val pronunciationTips: List<String> = emptyList(),
    val highlightedWords: List<WordFeedback> = emptyList()
)

data class WordFeedback(val word: String, val status: WordStatus)

enum class WordStatus { GOOD, MISSED, MISPRONOUNCED }
enum class FeedbackType { PERFECT, GREAT, GOOD, NEEDS_PRACTICE }
