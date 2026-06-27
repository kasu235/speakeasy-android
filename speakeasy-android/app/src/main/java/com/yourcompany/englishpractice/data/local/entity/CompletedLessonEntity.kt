package com.yourcompany.englishpractice.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "completed_lessons")
data class CompletedLessonEntity(
    @PrimaryKey val lessonId: String,
    val categoryId: String,
    val score: Int,
    val spokenText: String,
    val completedAt: Long = System.currentTimeMillis()
)
