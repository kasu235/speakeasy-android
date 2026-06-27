package com.yourcompany.englishpractice.core.di

import android.content.Context
import androidx.room.Room
import com.yourcompany.englishpractice.data.local.AppDatabase
import com.yourcompany.englishpractice.data.local.dao.ConversationDao
import com.yourcompany.englishpractice.data.local.dao.LessonDao
import com.yourcompany.englishpractice.data.local.dao.UserProgressDao
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {

    @Provides
    @Singleton
    fun provideAppDatabase(@ApplicationContext context: Context): AppDatabase {
        return Room.databaseBuilder(
            context,
            AppDatabase::class.java,
            "english_practice_db"
        ).build()
    }

    @Provides
    fun provideUserProgressDao(database: AppDatabase): UserProgressDao = database.userProgressDao()

    @Provides
    fun provideLessonDao(database: AppDatabase): LessonDao = database.lessonDao()

    @Provides
    fun provideConversationDao(database: AppDatabase): ConversationDao = database.conversationDao()
}
