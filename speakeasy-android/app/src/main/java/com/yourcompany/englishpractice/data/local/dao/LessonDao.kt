package com.yourcompany.englishpractice.data.local.dao

import androidx.room.*
import com.yourcompany.englishpractice.data.local.entity.CompletedLessonEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface LessonDao {
    @Query("SELECT * FROM completed_lessons ORDER BY completedAt DESC")
    fun getAllCompletedLessons(): Flow<List<CompletedLessonEntity>>

    @Query("SELECT * FROM completed_lessons WHERE categoryId = :categoryId")
    fun getLessonsByCategory(categoryId: String): Flow<List<CompletedLessonEntity>>

    @Query("SELECT COUNT(*) FROM completed_lessons")
    suspend fun getCompletedLessonCount(): Int

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCompletedLesson(lesson: CompletedLessonEntity)
}
