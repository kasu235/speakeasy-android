package com.yourcompany.englishpractice.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "user_progress")
data class UserProgressEntity(
    @PrimaryKey val id: String = "main_progress",
    val totalLessonsCompleted: Int = 0,
    val averageScore: Float = 0f,
    val currentStreak: Int = 0,
    val longestStreak: Int = 0,
    val lastPracticeDate: Long = 0L,
    val totalMinutesPracticed: Int = 0
)
