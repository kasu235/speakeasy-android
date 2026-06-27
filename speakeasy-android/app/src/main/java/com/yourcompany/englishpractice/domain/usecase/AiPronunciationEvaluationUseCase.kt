package com.yourcompany.englishpractice.domain.usecase

import com.yourcompany.englishpractice.data.remote.ChatMessage
import com.yourcompany.englishpractice.data.remote.ChatRequest
import com.yourcompany.englishpractice.data.remote.LlmApiService
import com.yourcompany.englishpractice.domain.model.FeedbackType
import com.yourcompany.englishpractice.domain.model.LessonResult
import com.yourcompany.englishpractice.domain.model.WordFeedback
import com.yourcompany.englishpractice.domain.model.WordStatus
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlinx.serialization.json.int

class AiPronunciationEvaluationUseCase(
    private val apiService: LlmApiService,
    private val fallbackUseCase: EvaluateSpeechUseCase
) {
    private val json = Json { ignoreUnknownKeys = true }

    suspend operator fun invoke(lessonId: String, targetPhrase: String, spokenText: String): LessonResult {
        if (spokenText.isBlank()) return fallbackUseCase(targetPhrase, spokenText).copy(lessonId = lessonId)
        return try {
            val prompt = """
                Compare target phrase with student speech.
                Target: "$targetPhrase"
                Student said: "$spokenText"
                Return ONLY JSON: {"score":0-100,"feedback_type":"PERFECT|GREAT|GOOD|NEEDS_PRACTICE","detailed_feedback":"...","pronunciation_tips":["..."],"word_feedback":[{"word":"...","status":"GOOD|MISSED|MISPRONOUNCED"}]}
            """.trimIndent()
            val response = apiService.getChatCompletion(
                ChatRequest(messages = listOf(
                    ChatMessage("system", "You are an English pronunciation coach. Return valid JSON only."),
                    ChatMessage("user", prompt)
                ))
            )
            val aiText = response.choices.first().message.content
            parseAiResponse(aiText, targetPhrase, spokenText).copy(lessonId = lessonId)
        } catch (e: Exception) {
            fallbackUseCase(targetPhrase, spokenText).copy(lessonId = lessonId)
        }
    }

    private fun parseAiResponse(aiText: String, target: String, spoken: String): LessonResult {
        val cleanJson = aiText.replace(Regex("```json\\s*|```\\s*"), "").trim()
        val jsonObj = json.parseToJsonElement(cleanJson).jsonObject
        val score = jsonObj["score"]?.jsonPrimitive?.int ?: 0
        val feedbackType = try {
            FeedbackType.valueOf(jsonObj["feedback_type"]!!.jsonPrimitive.content)
        } catch (e: Exception) { FeedbackType.GOOD }
        val detailedFeedback = jsonObj["detailed_feedback"]?.jsonPrimitive?.content
        val tips = jsonObj["pronunciation_tips"]?.jsonArray?.map { it.jsonPrimitive.content } ?: emptyList()
        val wordFeedback = jsonObj["word_feedback"]?.jsonArray?.map { element ->
            val wordObj = element.jsonObject
            WordFeedback(
                word = wordObj["word"]!!.jsonPrimitive.content,
                status = try { WordStatus.valueOf(wordObj["status"]!!.jsonPrimitive.content) } catch (e: Exception) { WordStatus.GOOD }
            )
        } ?: emptyList()
        return LessonResult("", spoken, score, feedbackType, if (score == 100) null else target, detailedFeedback, tips, wordFeedback)
    }
}
