package com.yourcompany.englishpractice.data.local

import androidx.room.Database
import androidx.room.RoomDatabase
import com.yourcompany.englishpractice.data.local.dao.ConversationDao
import com.yourcompany.englishpractice.data.local.dao.LessonDao
import com.yourcompany.englishpractice.data.local.dao.UserProgressDao
import com.yourcompany.englishpractice.data.local.entity.CompletedLessonEntity
import com.yourcompany.englishpractice.data.local.entity.ConversationEntity
import com.yourcompany.englishpractice.data.local.entity.UserProgressEntity

@Database(
    entities = [UserProgressEntity::class, CompletedLessonEntity::class, ConversationEntity::class],
    version = 1,
    exportSchema = false
)
abstract class AppDatabase : RoomDatabase() {
    abstract fun userProgressDao(): UserProgressDao
    abstract fun lessonDao(): LessonDao
    abstract fun conversationDao(): ConversationDao
}
