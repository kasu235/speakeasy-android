package com.yourcompany.englishpractice.data.repository

import com.yourcompany.englishpractice.data.local.dao.LessonDao
import com.yourcompany.englishpractice.data.local.dao.UserProgressDao
import com.yourcompany.englishpractice.data.local.entity.CompletedLessonEntity
import com.yourcompany.englishpractice.data.local.entity.UserProgressEntity
import com.yourcompany.englishpractice.domain.model.LessonResult
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import java.util.Calendar
import javax.inject.Inject

class UserProgressRepositoryImpl @Inject constructor(
    private val userProgressDao: UserProgressDao,
    private val lessonDao: LessonDao
) {
    fun getUserProgress(): Flow<UserProgressEntity?> = userProgressDao.getProgress()
    fun getCompletedLessons(): Flow<List<CompletedLessonEntity>> = lessonDao.getAllCompletedLessons()

    suspend fun saveLessonResult(lessonId: String, categoryId: String, result: LessonResult) {
        lessonDao.insertCompletedLesson(
            CompletedLessonEntity(lessonId, categoryId, result.accuracyScore, result.spokenText)
        )
        updateProgressAfterLesson(result.accuracyScore)
    }

    private suspend fun updateProgressAfterLesson(score: Int) {
        val current = userProgressDao.getProgress().first() ?: UserProgressEntity()
        val totalLessons = current.totalLessonsCompleted + 1
        val newAverage = ((current.averageScore * current.totalLessonsCompleted) + score) / totalLessons

        val today = getStartOfDay(System.currentTimeMillis())
        val lastPractice = getStartOfDay(current.lastPracticeDate)
        val yesterday = today - (24 * 60 * 60 * 1000)

        val newStreak = when {
            lastPractice == today -> current.currentStreak
            lastPractice == yesterday -> current.currentStreak + 1
            else -> 1
        }

        userProgressDao.insertProgress(
            current.copy(
                totalLessonsCompleted = totalLessons,
                averageScore = newAverage,
                currentStreak = newStreak,
                longestStreak = maxOf(current.longestStreak, newStreak),
                lastPracticeDate = System.currentTimeMillis()
            )
        )
    }

    private fun getStartOfDay(timestamp: Long): Long {
        val calendar = Calendar.getInstance().apply {
            timeInMillis = timestamp
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        return calendar.timeInMillis
    }
}
