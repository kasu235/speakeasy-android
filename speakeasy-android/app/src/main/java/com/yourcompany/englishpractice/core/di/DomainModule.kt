package com.yourcompany.englishpractice.core.di

import com.yourcompany.englishpractice.data.remote.LlmApiService
import com.yourcompany.englishpractice.domain.usecase.AiPronunciationEvaluationUseCase
import com.yourcompany.englishpractice.domain.usecase.EvaluateSpeechUseCase
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DomainModule {

    @Provides
    @Singleton
    fun provideEvaluateSpeechUseCase(): EvaluateSpeechUseCase {
        return EvaluateSpeechUseCase()
    }

    @Provides
    @Singleton
    fun provideAiEvaluationUseCase(
        apiService: LlmApiService,
        fallbackUseCase: EvaluateSpeechUseCase
    ): AiPronunciationEvaluationUseCase {
        return AiPronunciationEvaluationUseCase(apiService, fallbackUseCase)
    }
}
