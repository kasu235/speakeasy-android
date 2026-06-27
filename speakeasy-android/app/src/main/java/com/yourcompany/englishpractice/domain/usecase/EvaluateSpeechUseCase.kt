package com.yourcompany.englishpractice.domain.usecase

import com.yourcompany.englishpractice.domain.model.FeedbackType
import com.yourcompany.englishpractice.domain.model.LessonResult
import kotlin.math.roundToInt

class EvaluateSpeechUseCase {
    operator fun invoke(targetPhrase: String, spokenText: String): LessonResult {
        if (spokenText.isBlank()) {
            return LessonResult("", spokenText, 0, FeedbackType.NEEDS_PRACTICE, targetPhrase)
        }

        val normalizedTarget = normalizeText(targetPhrase)
        val normalizedSpoken = normalizeText(spokenText)
        val targetWords = normalizedTarget.split(" ")
        val spokenWords = normalizedSpoken.split(" ")

        val matches = countMatchingWords(targetWords, spokenWords)
        val rawScore = (matches.toFloat() / targetWords.size.toFloat()) * 100
        val accuracyScore = rawScore.roundToInt().coerceIn(0, 100)
        val feedback = getFeedbackType(accuracyScore)
        val correctedText = if (accuracyScore == 100) null else targetPhrase

        return LessonResult("", spokenText, accuracyScore, feedback, correctedText)
    }

    private fun normalizeText(text: String): String =
        text.lowercase().replace(Regex("[^a-z0-9\\s]"), "").trim().replace(Regex("\\s+"), " ")

    private fun countMatchingWords(targetWords: List<String>, spokenWords: List<String>): Int {
        val spokenSet = spokenWords.toMutableList()
        var matches = 0
        for (word in targetWords) {
            if (spokenSet.contains(word)) {
                matches++
                spokenSet.remove(word)
            }
        }
        return matches
    }

    private fun getFeedbackType(score: Int): FeedbackType = when {
        score >= 90 -> FeedbackType.PERFECT
        score >= 75 -> FeedbackType.GREAT
        score >= 50 -> FeedbackType.GOOD
        else -> FeedbackType.NEEDS_PRACTICE
    }
}
