package com.yourcompany.englishpractice.core.di

import android.content.Context
import com.yourcompany.englishpractice.core.speech.SpeechRecognizerManager
import com.yourcompany.englishpractice.core.speech.TextToSpeechManager
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.components.ViewModelComponent
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.android.scopes.ViewModelScoped

@Module
@InstallIn(ViewModelComponent::class)
object SpeechModule {

    @Provides
    @ViewModelScoped
    fun provideSpeechRecognizerManager(@ApplicationContext context: Context): SpeechRecognizerManager {
        return SpeechRecognizerManager(context)
    }

    @Provides
    @ViewModelScoped
    fun provideTextToSpeechManager(@ApplicationContext context: Context): TextToSpeechManager {
        return TextToSpeechManager(context)
    }
}
