#!/bin/bash

# SpeakEasy Project Generator
# Creates all 42 files + ZIP archive

set -e

PROJECT_NAME="speakeasy-android"
echo "🚀 Creating SpeakEasy project structure..."

# Clean up if exists
rm -rf "$PROJECT_NAME"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create directory structure
echo "📁 Creating directories..."
mkdir -p ".github/workflows"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/core/di"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/core/speech"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/core/ui/theme"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/core/util"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/data/local/dao"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/data/local/entity"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/data/remote"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/data/repository"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/domain/model"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/domain/usecase"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/presentation/category"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/presentation/freetalk"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/presentation/home"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/presentation/lesson"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/presentation/navigation"
mkdir -p "app/src/main/java/com/yourcompany/englishpractice/presentation/onboarding"
mkdir -p "app/src/main/res/values"
mkdir -p "app/src/main/res/values-night"
mkdir -p "app/src/main/res/mipmap-hdpi"
mkdir -p "gradle/wrapper"

echo "📝 Creating files..."

# ============ ROOT FILES ============

cat > "build.gradle.kts" << 'EOF'
plugins {
    id("com.android.application") version "8.2.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.22" apply false
    id("com.google.dagger.hilt.android") version "2.51.1" apply false
    id("com.google.devtools.ksp") version "1.9.22-1.0.17" apply false
}
EOF

cat > "settings.gradle.kts" << 'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "SpeakEasy"
include(":app")
EOF

cat > "gradle.properties" << 'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
kotlin.code.style=official
android.nonTransitiveRClass=true
EOF

cat > "local.properties" << 'EOF'
# Auto-generated - leave empty for GitHub Actions
sdk.dir=
EOF

# ============ APP BUILD FILE ============

cat > "app/build.gradle.kts" << 'EOF'
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.dagger.hilt.android")
    id("com.google.devtools.ksp")
    id("org.jetbrains.kotlin.plugin.serialization") version "1.9.22"
}

android {
    namespace = "com.yourcompany.englishpractice"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.yourcompany.englishpractice"
        minSdk = 26
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        compose = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.10"
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.activity:activity-compose:1.8.2")

    implementation(platform("androidx.compose:compose-bom:2024.02.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")

    implementation("androidx.navigation:navigation-compose:2.7.7")

    implementation("com.google.dagger:hilt-android:2.51.1")
    ksp("com.google.dagger:hilt-android-compiler:2.51.1")
    implementation("androidx.hilt:hilt-navigation-compose:1.2.0")

    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")

    val room_version = "2.6.1"
    implementation("androidx.room:room-runtime:$room_version")
    implementation("androidx.room:room-ktx:$room_version")
    ksp("androidx.room:room-compiler:$room_version")

    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.3")

    debugImplementation("androidx.compose.ui:ui-tooling")
}
EOF

cat > "app/proguard-rules.pro" << 'EOF'
-keepattributes *Annotation*
-keep class * extends androidx.lifecycle.ViewModel { *; }
EOF

# ============ ANDROID MANIFEST ============

cat > "app/src/main/AndroidManifest.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.INTERNET" />

    <queries>
        <intent>
            <action android:name="android.speech.action.RECOGNIZE_SPEECH" />
        </intent>
    </queries>

    <application
        android:name=".EnglishPracticeApp"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="SpeakEasy"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.EnglishPractice"
        tools:targetApi="34">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:theme="@style/Theme.EnglishPractice">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

# ============ RESOURCE FILES ============

cat > "app/src/main/res/values/strings.xml" << 'EOF'
<resources>
    <string name="app_name">SpeakEasy</string>
</resources>
EOF

cat > "app/src/main/res/values/colors.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="purple_200">#FFBB86FC</color>
    <color name="purple_500">#FF6200EE</color>
    <color name="purple_700">#FF3700B3</color>
    <color name="teal_200">#FF03DAC5</color>
    <color name="teal_700">#FF018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
</resources>
EOF

cat > "app/src/main/res/values/themes.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.EnglishPractice" parent="android:Theme.Material.Light.NoActionBar" />
</resources>
EOF

cat > "app/src/main/res/values-night/themes.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.EnglishPractice" parent="android:Theme.Material.NoActionBar" />
</resources>
EOF

# ============ KOTLIN FILES ============

# EnglishPracticeApp.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/EnglishPracticeApp.kt" << 'EOF'
package com.yourcompany.englishpractice

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class EnglishPracticeApp : Application()
EOF

# MainActivity.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/MainActivity.kt" << 'EOF'
package com.yourcompany.englishpractice

import android.Manifest
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.navigation.compose.rememberNavController
import com.yourcompany.englishpractice.core.ui.theme.EnglishPracticeTheme
import com.yourcompany.englishpractice.core.util.PermissionManager
import com.yourcompany.englishpractice.data.local.LessonDataSource
import com.yourcompany.englishpractice.presentation.navigation.AppNavHost
import com.yourcompany.englishpractice.presentation.onboarding.OnboardingScreen
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class MainActivity : ComponentActivity() {

    @Inject
    lateinit var lessonDataSource: LessonDataSource

    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted: Boolean ->
        if (!isGranted) {
            Toast.makeText(this, "Microphone permission required", Toast.LENGTH_LONG).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            EnglishPracticeTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    var showOnboarding by remember { mutableStateOf(true) }

                    if (showOnboarding) {
                        OnboardingScreen(onComplete = {
                            showOnboarding = false
                            requestMicrophonePermission()
                        })
                    } else {
                        val navController = rememberNavController()
                        AppNavHost(
                            navController = navController,
                            lessonDataSource = lessonDataSource
                        )
                    }
                }
            }
        }
    }

    private fun requestMicrophonePermission() {
        if (!PermissionManager.hasMicrophonePermission(this)) {
            requestPermissionLauncher.launch(Manifest.permission.RECORD_AUDIO)
        }
    }
}
EOF

# core/ui/theme/Color.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/core/ui/theme/Color.kt" << 'EOF'
package com.yourcompany.englishpractice.core.ui.theme

import androidx.compose.ui.graphics.Color

val Purple80 = Color(0xFFD0BCFF)
val PurpleGrey80 = Color(0xFFCCC2DC)
val Pink80 = Color(0xFFEFB8C8)

val Purple40 = Color(0xFF6650a4)
val PurpleGrey40 = Color(0xFF625b71)
val Pink40 = Color(0xFF7D5260)
EOF

# core/ui/theme/Theme.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/core/ui/theme/Theme.kt" << 'EOF'
package com.yourcompany.englishpractice.core.ui.theme

import android.app.Activity
import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

private val DarkColorScheme = darkColorScheme(
    primary = Purple80,
    secondary = PurpleGrey80,
    tertiary = Pink80
)

private val LightColorScheme = lightColorScheme(
    primary = Purple40,
    secondary = PurpleGrey40,
    tertiary = Pink40
)

@Composable
fun EnglishPracticeTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = true,
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = colorScheme.primary.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = !darkTheme
        }
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}
EOF

# core/ui/theme/Type.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/core/ui/theme/Type.kt" << 'EOF'
package com.yourcompany.englishpractice.core.ui.theme

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    )
)
EOF

# core/util/PermissionManager.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/core/util/PermissionManager.kt" << 'EOF'
package com.yourcompany.englishpractice.core.util

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat

object PermissionManager {
    fun hasMicrophonePermission(context: Context): Boolean {
        return ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED
    }
}
EOF

# core/speech/SpeechRecognizerManager.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/core/speech/SpeechRecognizerManager.kt" << 'EOF'
package com.yourcompany.englishpractice.core.speech

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import java.util.Locale

sealed class SpeechError {
    object NoSpeech : SpeechError()
    object MicBlockedOrUnavailable : SpeechError()
    object NetworkError : SpeechError()
    object Unknown : SpeechError()
}

class SpeechRecognizerManager(context: Context) : RecognitionListener {

    private val speechRecognizer: SpeechRecognizer = SpeechRecognizer.createSpeechRecognizer(context)

    private val _isListening = MutableStateFlow(false)
    val isListening: StateFlow<Boolean> = _isListening.asStateFlow()

    private val _transcribedText = MutableStateFlow("")
    val transcribedText: StateFlow<String> = _transcribedText.asStateFlow()

    private val _errorEvents = MutableSharedFlow<SpeechError>()
    val errorEvents: SharedFlow<SpeechError> = _errorEvents.asSharedFlow()

    init {
        speechRecognizer.setRecognitionListener(this)
    }

    fun startListening() {
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.ENGLISH.toString())
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 1)
        }
        _transcribedText.value = ""
        _isListening.value = true
        speechRecognizer.startListening(intent)
    }

    fun stopListening() {
        speechRecognizer.stopListening()
        _isListening.value = false
    }

    fun destroy() {
        speechRecognizer.destroy()
    }

    override fun onReadyForSpeech(params: Bundle?) { _isListening.value = true }
    override fun onBeginningOfSpeech() {}
    override fun onRmsChanged(rmsdB: Float) {}
    override fun onBufferReceived(buffer: ByteArray?) {}
    override fun onEndOfSpeech() { _isListening.value = false }

    override fun onError(error: Int) {
        _isListening.value = false
        val speechError = when (error) {
            SpeechRecognizer.ERROR_NO_MATCH, SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> SpeechError.NoSpeech
            SpeechRecognizer.ERROR_AUDIO, SpeechRecognizer.ERROR_CLIENT, SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> SpeechError.MicBlockedOrUnavailable
            SpeechRecognizer.ERROR_NETWORK, SpeechRecognizer.ERROR_NETWORK_TIMEOUT -> SpeechError.NetworkError
            else -> SpeechError.Unknown
        }
        _errorEvents.tryEmit(speechError)
    }

    override fun onResults(results: Bundle?) {
        val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
        if (!matches.isNullOrEmpty()) {
            _transcribedText.value = matches[0]
        }
    }

    override fun onPartialResults(partialResults: Bundle?) {
        val matches = partialResults?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
        if (!matches.isNullOrEmpty()) {
            _transcribedText.value = matches[0]
        }
    }

    override fun onEvent(eventType: Int, params: Bundle?) {}
}
EOF

# core/speech/TextToSpeechManager.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/core/speech/TextToSpeechManager.kt" << 'EOF'
package com.yourcompany.englishpractice.core.speech

import android.content.Context
import android.os.Bundle
import android.speech.tts.TextToSpeech
import android.speech.tts.UtteranceProgressListener
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.util.Locale

class TextToSpeechManager(context: Context) : TextToSpeech.OnInitListener {

    private var tts: TextToSpeech? = null

    private val _isSpeaking = MutableStateFlow(false)
    val isSpeaking: StateFlow<Boolean> = _isSpeaking.asStateFlow()

    private val _isInitialized = MutableStateFlow(false)
    val isInitialized: StateFlow<Boolean> = _isInitialized.asStateFlow()

    init {
        tts = TextToSpeech(context.applicationContext, this)
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            val result = tts?.setLanguage(Locale.US)
            if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                _isInitialized.value = false
            } else {
                tts?.setPitch(1.0f)
                tts?.setSpeechRate(0.95f)
                tts?.setOnUtteranceProgressListener(object : UtteranceProgressListener() {
                    override fun onStart(utteranceId: String?) { _isSpeaking.value = true }
                    override fun onDone(utteranceId: String?) { _isSpeaking.value = false }
                    override fun onError(utteranceId: String?) { _isSpeaking.value = false }
                })
                _isInitialized.value = true
            }
        } else {
            _isInitialized.value = false
        }
    }

    fun speak(text: String) {
        if (text.isBlank() || !_isInitialized.value) return
        val params = Bundle().apply {
            putFloat(TextToSpeech.Engine.KEY_PARAM_VOLUME, 1.0f)
        }
        tts?.speak(text, TextToSpeech.QUEUE_FLUSH, params, "ai_response_${System.currentTimeMillis()}")
    }

    fun stop() {
        tts?.stop()
        _isSpeaking.value = false
    }

    fun destroy() {
        tts?.stop()
        tts?.shutdown()
        tts = null
    }
}
EOF

# core/di/NetworkModule.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/core/di/NetworkModule.kt" << 'EOF'
package com.yourcompany.englishpractice.core.di

import com.yourcompany.englishpractice.data.remote.LlmApiService
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {

    @Provides
    @Singleton
    fun provideOkHttpClient(): OkHttpClient {
        return OkHttpClient.Builder()
            .addInterceptor { chain ->
                val request = chain.request().newBuilder()
                    .addHeader("Authorization", "Bearer YOUR_API_KEY_HERE")
                    .build()
                chain.proceed(request)
            }
            .build()
    }

    @Provides
    @Singleton
    fun provideRetrofit(okHttpClient: OkHttpClient): Retrofit {
        return Retrofit.Builder()
            .baseUrl("https://api.openai.com/")
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    @Provides
    @Singleton
    fun provideLlmApiService(retrofit: Retrofit): LlmApiService {
        return retrofit.create(LlmApiService::class.java)
    }
}
EOF

# core/di/DomainModule.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/core/di/DomainModule.kt" << 'EOF'
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
EOF

# core/di/SpeechModule.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/core/di/SpeechModule.kt" << 'EOF'
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
EOF

# core/di/DatabaseModule.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/core/di/DatabaseModule.kt" << 'EOF'
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
EOF

# data/remote/LlmApiService.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/data/remote/LlmApiService.kt" << 'EOF'
package com.yourcompany.englishpractice.data.remote

import retrofit2.http.Body
import retrofit2.http.POST

data class ChatMessage(val role: String, val content: String)
data class ChatRequest(val model: String = "gpt-3.5-turbo", val messages: List<ChatMessage>)
data class ChatResponse(val choices: List<Choice>)
data class Choice(val message: ChatMessage)

interface LlmApiService {
    @POST("v1/chat/completions")
    suspend fun getChatCompletion(@Body request: ChatRequest): ChatResponse
}
EOF

# data/local/entity/UserProgressEntity.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/data/local/entity/UserProgressEntity.kt" << 'EOF'
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
EOF

# data/local/entity/CompletedLessonEntity.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/data/local/entity/CompletedLessonEntity.kt" << 'EOF'
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
EOF

# data/local/entity/ConversationEntity.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/data/local/entity/ConversationEntity.kt" << 'EOF'
package com.yourcompany.englishpractice.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "conversations")
data class ConversationEntity(
    @PrimaryKey val id: String,
    val title: String,
    val messages: String,
    val createdAt: Long = System.currentTimeMillis()
)
EOF

# data/local/dao/UserProgressDao.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/data/local/dao/UserProgressDao.kt" << 'EOF'
package com.yourcompany.englishpractice.data.local.dao

import androidx.room.*
import com.yourcompany.englishpractice.data.local.entity.UserProgressEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface UserProgressDao {
    @Query("SELECT * FROM user_progress WHERE id = 'main_progress'")
    fun getProgress(): Flow<UserProgressEntity?>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertProgress(progress: UserProgressEntity)

    @Update
    suspend fun updateProgress(progress: UserProgressEntity)
}
EOF

# data/local/dao/LessonDao.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/data/local/dao/LessonDao.kt" << 'EOF'
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
EOF

# data/local/dao/ConversationDao.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/data/local/dao/ConversationDao.kt" << 'EOF'
package com.yourcompany.englishpractice.data.local.dao

import androidx.room.*
import com.yourcompany.englishpractice.data.local.entity.ConversationEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface ConversationDao {
    @Query("SELECT * FROM conversations ORDER BY createdAt DESC")
    fun getAllConversations(): Flow<List<ConversationEntity>>

    @Query("SELECT * FROM conversations WHERE id = :id")
    suspend fun getConversationById(id: String): ConversationEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertConversation(conversation: ConversationEntity)

    @Delete
    suspend fun deleteConversation(conversation: ConversationEntity)
}
EOF

# data/local/AppDatabase.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/data/local/AppDatabase.kt" << 'EOF'
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
EOF

# data/local/LessonDataSource.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/data/local/LessonDataSource.kt" << 'EOF'
package com.yourcompany.englishpractice.data.local

import com.yourcompany.englishpractice.domain.model.Lesson
import javax.inject.Inject
import javax.inject.Singleton

data class Category(
    val id: String,
    val name: String,
    val description: String,
    val iconName: String,
    val lessons: List<Lesson>
)

@Singleton
class LessonDataSource @Inject constructor() {

    fun getCategories(): List<Category> = listOf(
        Category(
            id = "travel", name = "Travel",
            description = "Essential phrases for traveling abroad",
            iconName = "flight",
            lessons = listOf(
                Lesson("travel_1", "travel", "How do you politely order a coffee?", "I would like a cup of coffee, please.", 2),
                Lesson("travel_2", "travel", "How do you ask for directions?", "Excuse me, could you tell me how to get to the train station?", 3),
                Lesson("travel_3", "travel", "How do you check into a hotel?", "Hello, I have a reservation under the name Smith.", 2)
            )
        ),
        Category(
            id = "business", name = "Business",
            description = "Professional communication skills",
            iconName = "briefcase",
            lessons = listOf(
                Lesson("business_1", "business", "How do you start a business meeting?", "Thank you all for coming. Let us get started.", 3),
                Lesson("business_2", "business", "How do you politely disagree?", "I see your point, but I have a different perspective.", 4)
            )
        ),
        Category(
            id = "daily", name = "Daily Life",
            description = "Common everyday conversations",
            iconName = "coffee",
            lessons = listOf(
                Lesson("daily_1", "daily", "How do you greet a neighbor?", "Good morning! How are you doing today?", 1),
                Lesson("daily_2", "daily", "How do you ask about the weekend?", "Hey! How was your weekend? Did you do anything fun?", 2)
            )
        )
    )

    fun getLessonById(lessonId: String): Lesson? =
        getCategories().flatMap { it.lessons }.find { it.id == lessonId }

    fun getLessonsByCategory(categoryId: String): List<Lesson> =
        getCategories().find { it.id == categoryId }?.lessons ?: emptyList()
}
EOF

# data/repository/UserProgressRepositoryImpl.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/data/repository/UserProgressRepositoryImpl.kt" << 'EOF'
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
EOF

# domain/model/Lesson.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/domain/model/Lesson.kt" << 'EOF'
package com.yourcompany.englishpractice.domain.model

data class Lesson(
    val id: String,
    val categoryId: String,
    val prompt: String,
    val targetPhrase: String,
    val difficultyLevel: Int
)

data class LessonResult(
    val lessonId: String,
    val spokenText: String,
    val accuracyScore: Int,
    val feedback: FeedbackType,
    val correctedText: String?,
    val detailedFeedback: String? = null,
    val pronunciationTips: List<String> = emptyList(),
    val highlightedWords: List<WordFeedback> = emptyList()
)

data class WordFeedback(val word: String, val status: WordStatus)

enum class WordStatus { GOOD, MISSED, MISPRONOUNCED }
enum class FeedbackType { PERFECT, GREAT, GOOD, NEEDS_PRACTICE }
EOF

# domain/usecase/EvaluateSpeechUseCase.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/domain/usecase/EvaluateSpeechUseCase.kt" << 'EOF'
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
EOF

# domain/usecase/AiPronunciationEvaluationUseCase.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/domain/usecase/AiPronunciationEvaluationUseCase.kt" << 'EOF'
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
EOF

# presentation/navigation/Screen.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/navigation/Screen.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.navigation

sealed class Screen(val route: String) {
    object Home : Screen("home")
    object DailyLesson : Screen("daily_lesson")
    object FreeTalk : Screen("free_talk")
    object CategoryDetail : Screen("category_detail/{categoryId}") {
        fun createRoute(categoryId: String) = "category_detail/$categoryId"
    }
}
EOF

# presentation/navigation/AppNavHost.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/navigation/AppNavHost.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.navigation

import androidx.compose.runtime.Composable
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.navArgument
import com.yourcompany.englishpractice.data.local.LessonDataSource
import com.yourcompany.englishpractice.presentation.category.CategoryDetailScreen
import com.yourcompany.englishpractice.presentation.freetalk.FreeTalkScreen
import com.yourcompany.englishpractice.presentation.freetalk.FreeTalkViewModel
import com.yourcompany.englishpractice.presentation.home.HomeScreen
import com.yourcompany.englishpractice.presentation.lesson.DailyLessonScreen
import com.yourcompany.englishpractice.presentation.lesson.DailyLessonViewModel

@Composable
fun AppNavHost(navController: NavHostController, lessonDataSource: LessonDataSource) {
    NavHost(navController = navController, startDestination = Screen.Home.route) {
        composable(Screen.Home.route) {
            HomeScreen(
                onNavigateToLesson = { navController.navigate(Screen.DailyLesson.route) },
                onNavigateToFreeTalk = { navController.navigate(Screen.FreeTalk.route) },
                onCategoryClick = { categoryId -> navController.navigate(Screen.CategoryDetail.createRoute(categoryId)) }
            )
        }
        composable(Screen.DailyLesson.route) {
            val viewModel: DailyLessonViewModel = hiltViewModel()
            DailyLessonScreen(viewModel = viewModel, speechManager = viewModel.speechManager, onBack = { navController.popBackStack() })
        }
        composable(Screen.FreeTalk.route) {
            val viewModel: FreeTalkViewModel = hiltViewModel()
            FreeTalkScreen(viewModel = viewModel, speechManager = viewModel.speechManager, ttsManager = viewModel.ttsManager, onBack = { navController.popBackStack() })
        }
        composable(Screen.CategoryDetail.route, arguments = listOf(navArgument("categoryId") { type = NavType.StringType })) { backStackEntry ->
            val categoryId = backStackEntry.arguments?.getString("categoryId") ?: return@composable
            val category = lessonDataSource.getCategories().find { it.id == categoryId } ?: return@composable
            CategoryDetailScreen(
                category = category,
                completedLessonIds = emptyList(),
                onBack = { navController.popBackStack() },
                onLessonClick = { navController.navigate(Screen.DailyLesson.route) }
            )
        }
    }
}
EOF

# presentation/home/HomeUiState.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/home/HomeUiState.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.home

data class HomeUiState(
    val userName: String = "Learner",
    val categories: List<CategoryItem> = emptyList(),
    val isLoading: Boolean = false
)

data class CategoryItem(
    val id: String,
    val title: String,
    val iconName: String,
    val lessonCount: Int
)
EOF

# presentation/home/HomeViewModel.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/home/HomeViewModel.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.home

import androidx.lifecycle.ViewModel
import com.yourcompany.englishpractice.data.local.LessonDataSource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject

@HiltViewModel
class HomeViewModel @Inject constructor(
    lessonDataSource: LessonDataSource
) : ViewModel() {
    private val _uiState = MutableStateFlow(HomeUiState())
    val uiState: StateFlow<HomeUiState> = _uiState.asStateFlow()

    init {
        val categories = lessonDataSource.getCategories().map {
            CategoryItem(it.id, it.name, it.iconName, it.lessons.size)
        }
        _uiState.value = HomeUiState(userName = "Learner", categories = categories)
    }
}
EOF

# presentation/home/HomeScreen.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/home/HomeScreen.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.home

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    viewModel: HomeViewModel = hiltViewModel(),
    onNavigateToLesson: () -> Unit = {},
    onNavigateToFreeTalk: () -> Unit = {},
    onCategoryClick: (String) -> Unit = {}
) {
    val uiState by viewModel.uiState.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("SpeakEasy", style = MaterialTheme.typography.titleLarge) },
                actions = {
                    IconButton(onClick = {}) { Icon(Icons.Outlined.Settings, contentDescription = "Settings") }
                }
            )
        }
    ) { paddingValues ->
        LazyColumn(
            modifier = Modifier.fillMaxSize().padding(paddingValues).padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp),
            contentPadding = PaddingValues(vertical = 16.dp)
        ) {
            item {
                Column {
                    Text("Hello, ${uiState.userName}!", style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("Ready to improve your English today?", style = MaterialTheme.typography.bodyLarge, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            }
            item {
                Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    Button(onClick = onNavigateToLesson, modifier = Modifier.fillMaxWidth().height(64.dp), shape = MaterialTheme.shapes.large) {
                        Icon(Icons.Filled.School, contentDescription = null, modifier = Modifier.size(24.dp))
                        Spacer(modifier = Modifier.width(12.dp))
                        Text("Start Daily Lesson", style = MaterialTheme.typography.titleMedium)
                    }
                    OutlinedButton(onClick = onNavigateToFreeTalk, modifier = Modifier.fillMaxWidth().height(64.dp), shape = MaterialTheme.shapes.large) {
                        Icon(Icons.Filled.SmartToy, contentDescription = null, modifier = Modifier.size(24.dp))
                        Spacer(modifier = Modifier.width(12.dp))
                        Text("Free Talk with AI", style = MaterialTheme.typography.titleMedium)
                    }
                }
            }
            item { Text("Practice Categories", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold) }
            items(uiState.categories) { category ->
                Card(
                    onClick = { onCategoryClick(category.id) },
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
                ) {
                    Row(modifier = Modifier.fillMaxWidth().padding(16.dp), verticalAlignment = Alignment.CenterVertically) {
                        Icon(imageVector = getIconForCategory(category.iconName), contentDescription = null, tint = MaterialTheme.colorScheme.primary, modifier = Modifier.size(40.dp))
                        Spacer(modifier = Modifier.width(16.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text(category.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold)
                            Text("${category.lessonCount} lessons available", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                        }
                        Icon(Icons.Filled.ChevronRight, contentDescription = null, tint = MaterialTheme.colorScheme.onSurfaceVariant)
                    }
                }
            }
        }
    }
}

private fun getIconForCategory(name: String): ImageVector = when (name) {
    "flight" -> Icons.Filled.FlightTakeoff
    "briefcase" -> Icons.Filled.BusinessCenter
    "coffee" -> Icons.Filled.LocalCafe
    else -> Icons.Filled.Category
}
EOF

# presentation/lesson/DailyLessonViewModel.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/lesson/DailyLessonViewModel.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.lesson

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.yourcompany.englishpractice.core.speech.SpeechRecognizerManager
import com.yourcompany.englishpractice.data.repository.UserProgressRepositoryImpl
import com.yourcompany.englishpractice.domain.model.Lesson
import com.yourcompany.englishpractice.domain.model.LessonResult
import com.yourcompany.englishpractice.domain.usecase.AiPronunciationEvaluationUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

enum class LessonStep { PROMPT, LISTENING, RESULT }

data class DailyLessonUiState(
    val lesson: Lesson = Lesson("1", "travel", "How do you politely order a coffee?", "I would like a cup of coffee, please.", 2),
    val step: LessonStep = LessonStep.PROMPT,
    val result: LessonResult? = null
)

@HiltViewModel
class DailyLessonViewModel @Inject constructor(
    private val aiEvaluationUseCase: AiPronunciationEvaluationUseCase,
    private val progressRepository: UserProgressRepositoryImpl,
    val speechManager: SpeechRecognizerManager
) : ViewModel() {

    private val _uiState = MutableStateFlow(DailyLessonUiState())
    val uiState: StateFlow<DailyLessonUiState> = _uiState.asStateFlow()

    fun startListening() {
        _uiState.update { it.copy(step = LessonStep.LISTENING, result = null) }
    }

    fun onSpeechFinished(spokenText: String) {
        viewModelScope.launch {
            val currentLesson = _uiState.value.lesson
            val result = aiEvaluationUseCase(currentLesson.id, currentLesson.targetPhrase, spokenText)
            progressRepository.saveLessonResult(currentLesson.id, currentLesson.categoryId, result)
            _uiState.update { it.copy(step = LessonStep.RESULT, result = result) }
        }
    }

    fun resetLesson() {
        _uiState.update { it.copy(step = LessonStep.PROMPT, result = null) }
    }
}
EOF

# presentation/lesson/DailyLessonScreen.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/lesson/DailyLessonScreen.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.lesson

import androidx.compose.animation.Crossfade
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.yourcompany.englishpractice.core.speech.SpeechRecognizerManager
import com.yourcompany.englishpractice.domain.model.FeedbackType
import com.yourcompany.englishpractice.domain.model.Lesson
import com.yourcompany.englishpractice.domain.model.LessonResult

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DailyLessonScreen(
    viewModel: DailyLessonViewModel,
    speechManager: SpeechRecognizerManager,
    onBack: () -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()
    val isListening by speechManager.isListening.collectAsState()
    val transcribedText by speechManager.transcribedText.collectAsState()

    LaunchedEffect(isListening, transcribedText) {
        if (uiState.step == LessonStep.LISTENING && !isListening && transcribedText.isNotBlank()) {
            viewModel.onSpeechFinished(transcribedText)
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Daily Lesson") },
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.Filled.ArrowBack, contentDescription = "Back") } }
            )
        }
    ) { padding ->
        Crossfade(targetState = uiState.step, modifier = Modifier.fillMaxSize().padding(padding).padding(24.dp)) { currentStep ->
            when (currentStep) {
                LessonStep.PROMPT -> PromptView(uiState.lesson) {
                    viewModel.startListening()
                    speechManager.startListening()
                }
                LessonStep.LISTENING -> ListeningView(transcribedText)
                LessonStep.RESULT -> uiState.result?.let { result ->
                    ResultView(result, uiState.lesson.targetPhrase) {
                        viewModel.resetLesson()
                    }
                }
            }
        }
    }
}

@Composable
private fun PromptView(lesson: Lesson, onStart: () -> Unit) {
    Column(modifier = Modifier.fillMaxSize(), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.Center) {
        Text("Say this phrase:", style = MaterialTheme.typography.titleMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
        Spacer(modifier = Modifier.height(16.dp))
        Card(modifier = Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
            Text(lesson.targetPhrase, style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold, textAlign = TextAlign.Center, modifier = Modifier.padding(24.dp).fillMaxWidth())
        }
        Spacer(modifier = Modifier.height(48.dp))
        Button(onClick = onStart, modifier = Modifier.size(100.dp), shape = MaterialTheme.shapes.extraLarge, contentPadding = PaddingValues(0.dp)) {
            Icon(Icons.Filled.Mic, contentDescription = "Start Speaking", modifier = Modifier.size(48.dp))
        }
        Spacer(modifier = Modifier.height(16.dp))
        Text("Tap to start speaking", style = MaterialTheme.typography.bodyMedium)
    }
}

@Composable
private fun ListeningView(transcribedText: String) {
    Column(modifier = Modifier.fillMaxSize(), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.Center) {
        Text("Listening...", style = MaterialTheme.typography.headlineMedium, color = MaterialTheme.colorScheme.primary)
        Spacer(modifier = Modifier.height(32.dp))
        Icon(Icons.Filled.Mic, contentDescription = null, tint = MaterialTheme.colorScheme.error, modifier = Modifier.size(80.dp))
        Spacer(modifier = Modifier.height(32.dp))
        Text(if (transcribedText.isNotEmpty()) "\"$transcribedText\"" else "Speak clearly", style = MaterialTheme.typography.bodyLarge, textAlign = TextAlign.Center, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
}

@Composable
private fun ResultView(result: LessonResult, targetPhrase: String, onTryAgain: () -> Unit) {
    Column(modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState()), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Spacer(modifier = Modifier.height(16.dp))
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text("${result.accuracyScore}%", style = MaterialTheme.typography.displayLarge, fontWeight = FontWeight.Black, color = getScoreColor(result.feedback))
            Text(getFeedbackText(result.feedback), style = MaterialTheme.typography.headlineSmall, color = getScoreColor(result.feedback))
        }
        if (!result.detailedFeedback.isNullOrBlank()) {
            Card(modifier = Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)) {
                Row(modifier = Modifier.padding(16.dp), verticalAlignment = Alignment.Top) {
                    Icon(Icons.Filled.School, contentDescription = null, tint = MaterialTheme.colorScheme.onPrimaryContainer)
                    Spacer(modifier = Modifier.width(12.dp))
                    Text(result.detailedFeedback, style = MaterialTheme.typography.bodyLarge, color = MaterialTheme.colorScheme.onPrimaryContainer)
                }
            }
        }
        Card(modifier = Modifier.fillMaxWidth(), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("Target:", style = MaterialTheme.typography.labelMedium, color = MaterialTheme.colorScheme.primary)
                Text(targetPhrase, style = MaterialTheme.typography.bodyLarge, fontWeight = FontWeight.SemiBold)
                Spacer(modifier = Modifier.height(12.dp))
                HorizontalDivider()
                Spacer(modifier = Modifier.height(12.dp))
                Text("You said:", style = MaterialTheme.typography.labelMedium, color = MaterialTheme.colorScheme.onSurfaceVariant)
                Text(result.spokenText, style = MaterialTheme.typography.bodyLarge)
            }
        }
        Button(onClick = onTryAgain, modifier = Modifier.fillMaxWidth().height(56.dp), shape = MaterialTheme.shapes.large) {
            Icon(Icons.Filled.Refresh, contentDescription = null)
            Spacer(modifier = Modifier.width(8.dp))
            Text("Try Again", style = MaterialTheme.typography.titleMedium)
        }
        Spacer(modifier = Modifier.height(16.dp))
    }
}

private fun getScoreColor(feedback: FeedbackType): Color = when (feedback) {
    FeedbackType.PERFECT -> Color(0xFF4CAF50)
    FeedbackType.GREAT -> Color(0xFF8BC34A)
    FeedbackType.GOOD -> Color(0xFFFFC107)
    FeedbackType.NEEDS_PRACTICE -> Color(0xFFF44336)
}

private fun getFeedbackText(feedback: FeedbackType): String = when (feedback) {
    FeedbackType.PERFECT -> "Perfect!"
    FeedbackType.GREAT -> "Great job!"
    FeedbackType.GOOD -> "Good effort!"
    FeedbackType.NEEDS_PRACTICE -> "Keep practicing!"
}
EOF

# presentation/freetalk/FreeTalkViewModel.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/freetalk/FreeTalkViewModel.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.freetalk

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.yourcompany.englishpractice.core.speech.SpeechRecognizerManager
import com.yourcompany.englishpractice.core.speech.TextToSpeechManager
import com.yourcompany.englishpractice.data.remote.ChatMessage
import com.yourcompany.englishpractice.data.remote.ChatRequest
import com.yourcompany.englishpractice.data.remote.LlmApiService
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

data class FreeTalkUiState(
    val isLoading: Boolean = false,
    val aiResponse: String = "Hello! I am your AI English partner. What would you like to talk about today?",
    val error: String? = null
)

@HiltViewModel
class FreeTalkViewModel @Inject constructor(
    private val apiService: LlmApiService,
    val ttsManager: TextToSpeechManager,
    val speechManager: SpeechRecognizerManager
) : ViewModel() {

    private val _uiState = MutableStateFlow(FreeTalkUiState())
    val uiState: StateFlow<FreeTalkUiState> = _uiState.asStateFlow()

    private val conversationHistory = mutableListOf(
        ChatMessage("system", "You are a friendly English conversation partner. Keep responses concise.")
    )

    fun sendSpokenTextToAi(userText: String) {
        if (userText.isBlank()) return
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true, error = null) }
            conversationHistory.add(ChatMessage("user", userText))
            try {
                val response = apiService.getChatCompletion(ChatRequest(messages = conversationHistory))
                val aiText = response.choices.firstOrNull()?.message?.content ?: "Sorry, I did not catch that."
                conversationHistory.add(ChatMessage("assistant", aiText))
                _uiState.update { it.copy(isLoading = false, aiResponse = aiText) }
                ttsManager.speak(aiText)
            } catch (e: Exception) {
                _uiState.update { it.copy(isLoading = false, error = "Network error.") }
            }
        }
    }

    override fun onCleared() {
        super.onCleared()
        ttsManager.destroy()
    }
}
EOF

# presentation/freetalk/FreeTalkScreen.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/freetalk/FreeTalkScreen.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.freetalk

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.yourcompany.englishpractice.core.speech.SpeechRecognizerManager
import com.yourcompany.englishpractice.core.speech.TextToSpeechManager

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FreeTalkScreen(
    viewModel: FreeTalkViewModel,
    speechManager: SpeechRecognizerManager,
    ttsManager: TextToSpeechManager,
    onBack: () -> Unit
) {
    val uiState by viewModel.uiState.collectAsState()
    val isListening by speechManager.isListening.collectAsState()
    val transcribedText by speechManager.transcribedText.collectAsState()
    val isAiSpeaking by ttsManager.isSpeaking.collectAsState()

    LaunchedEffect(isListening, transcribedText) {
        if (!isListening && transcribedText.isNotBlank()) {
            viewModel.sendSpokenTextToAi(transcribedText)
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Free Talk AI") },
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.Filled.ArrowBack, contentDescription = "Back") } }
            )
        }
    ) { padding ->
        Column(modifier = Modifier.fillMaxSize().padding(padding).padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.SpaceBetween) {
            Card(modifier = Modifier.fillMaxWidth().weight(1f), colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)) {
                Box(modifier = Modifier.padding(16.dp), contentAlignment = Alignment.Center) {
                    if (uiState.isLoading) CircularProgressIndicator()
                    else Text(uiState.aiResponse, style = MaterialTheme.typography.headlineSmall, textAlign = TextAlign.Center)
                }
            }
            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = when {
                    isAiSpeaking -> "AI is speaking..."
                    transcribedText.isNotEmpty() -> "\"$transcribedText\""
                    else -> "Tap the mic and start speaking..."
                },
                style = MaterialTheme.typography.bodyLarge,
                color = if (isAiSpeaking) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center,
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(24.dp))
            PulsingMicButton(isListening, isAiSpeaking) {
                if (isAiSpeaking) return@PulsingMicButton
                if (isListening) speechManager.stopListening() else speechManager.startListening()
            }
        }
    }
}

@Composable
private fun PulsingMicButton(isListening: Boolean, isAiSpeaking: Boolean, onClick: () -> Unit) {
    val infiniteTransition = rememberInfiniteTransition(label = "pulse")
    val pulseScale by infiniteTransition.animateFloat(initialValue = 1f, targetValue = 1.4f, animationSpec = infiniteRepeatable(animation = tween(1000, easing = FastOutSlowInEasing), repeatMode = RepeatMode.Restart), label = "scale")
    val pulseAlpha by infiniteTransition.animateFloat(initialValue = 0.6f, targetValue = 0f, animationSpec = infiniteRepeatable(animation = tween(1000, easing = FastOutSlowInEasing), repeatMode = RepeatMode.Restart), label = "alpha")

    Box(contentAlignment = Alignment.Center, modifier = Modifier.size(160.dp)) {
        if (isListening) {
            Box(modifier = Modifier.size(120.dp).scale(pulseScale).alpha(pulseAlpha).background(MaterialTheme.colorScheme.primary, CircleShape))
        }
        FilledIconButton(
            onClick = onClick,
            enabled = !isAiSpeaking,
            modifier = Modifier.size(80.dp),
            shape = CircleShape,
            colors = IconButtonDefaults.filledIconButtonColors(
                containerColor = when {
                    isAiSpeaking -> MaterialTheme.colorScheme.tertiary
                    isListening -> MaterialTheme.colorScheme.error
                    else -> MaterialTheme.colorScheme.primary
                },
                disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant
            )
        ) {
            Icon(
                imageVector = when {
                    isAiSpeaking -> Icons.Filled.VolumeUp
                    isListening -> Icons.Filled.Stop
                    else -> Icons.Filled.Mic
                },
                contentDescription = null,
                modifier = Modifier.size(40.dp),
                tint = Color.White
            )
        }
    }
}
EOF

# presentation/category/CategoryDetailScreen.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/category/CategoryDetailScreen.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.category

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.yourcompany.englishpractice.data.local.Category
import com.yourcompany.englishpractice.domain.model.Lesson

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CategoryDetailScreen(
    category: Category,
    completedLessonIds: List<String>,
    onBack: () -> Unit,
    onLessonClick: (Lesson) -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(category.name) },
                navigationIcon = { IconButton(onClick = onBack) { Icon(Icons.Filled.ArrowBack, contentDescription = "Back") } }
            )
        }
    ) { padding ->
        LazyColumn(modifier = Modifier.fillMaxSize().padding(padding).padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            item { Text(category.description, style = MaterialTheme.typography.bodyLarge, color = MaterialTheme.colorScheme.onSurfaceVariant, modifier = Modifier.padding(bottom = 16.dp)) }
            items(category.lessons) { lesson ->
                Card(
                    onClick = { onLessonClick(lesson) },
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = if (lesson.id in completedLessonIds) MaterialTheme.colorScheme.primaryContainer else MaterialTheme.colorScheme.surfaceVariant)
                ) {
                    Row(modifier = Modifier.fillMaxWidth().padding(16.dp), verticalAlignment = Alignment.CenterVertically) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text(lesson.prompt, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold)
                            Spacer(modifier = Modifier.height(4.dp))
                            Text("Difficulty: ${"★".repeat(lesson.difficultyLevel)}", style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                        }
                        if (lesson.id in completedLessonIds) Icon(Icons.Filled.Star, contentDescription = "Completed", tint = MaterialTheme.colorScheme.primary, modifier = Modifier.size(32.dp))
                    }
                }
            }
        }
    }
}
EOF

# presentation/onboarding/OnboardingScreen.kt
cat > "app/src/main/java/com/yourcompany/englishpractice/presentation/onboarding/OnboardingScreen.kt" << 'EOF'
package com.yourcompany.englishpractice.presentation.onboarding

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.School
import androidx.compose.material.icons.filled.SmartToy
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch

data class OnboardingPage(val icon: ImageVector, val title: String, val description: String)

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun OnboardingScreen(onComplete: () -> Unit) {
    val pages = listOf(
        OnboardingPage(Icons.Filled.School, "Welcome to SpeakEasy!", "Your personal AI-powered English speaking coach."),
        OnboardingPage(Icons.Filled.Mic, "Practice Speaking", "Complete daily lessons and get instant pronunciation feedback."),
        OnboardingPage(Icons.Filled.SmartToy, "Chat with AI", "Have natural conversations to build fluency and confidence.")
    )
    val pagerState = rememberPagerState(pageCount = { pages.size })
    val coroutineScope = rememberCoroutineScope()

    Column(modifier = Modifier.fillMaxSize().padding(24.dp), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.SpaceBetween) {
        Spacer(modifier = Modifier.height(48.dp))
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.Center) {
            repeat(pages.size) { index ->
                Box(modifier = Modifier.padding(horizontal = 4.dp).size(if (pagerState.currentPage == index) 12.dp else 8.dp)) {
                    Surface(modifier = Modifier.fillMaxSize(), shape = MaterialTheme.shapes.small, color = if (pagerState.currentPage == index) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.3f)) {}
                }
            }
        }
        HorizontalPager(state = pagerState, modifier = Modifier.fillMaxWidth().weight(1f)) { page ->
            Column(modifier = Modifier.fillMaxSize(), horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.Center) {
                Icon(pages[page].icon, contentDescription = null, modifier = Modifier.size(120.dp), tint = MaterialTheme.colorScheme.primary)
                Spacer(modifier = Modifier.height(48.dp))
                Text(pages[page].title, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold, textAlign = TextAlign.Center)
                Spacer(modifier = Modifier.height(16.dp))
                Text(pages[page].description, style = MaterialTheme.typography.bodyLarge, textAlign = TextAlign.Center, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
        }
        Column(modifier = Modifier.fillMaxWidth(), horizontalAlignment = Alignment.CenterHorizontally) {
            if (pagerState.currentPage == pages.size - 1) {
                Button(onClick = onComplete, modifier = Modifier.fillMaxWidth().height(56.dp), shape = MaterialTheme.shapes.large) { Text("Get Started", style = MaterialTheme.typography.titleMedium) }
            } else {
                Button(onClick = { coroutineScope.launch { pagerState.animateScrollToPage(pagerState.currentPage + 1) } }, modifier = Modifier.fillMaxWidth().height(56.dp), shape = MaterialTheme.shapes.large) { Text("Next", style = MaterialTheme.typography.titleMedium) }
            }
            Spacer(modifier = Modifier.height(12.dp))
            TextButton(onClick = onComplete) { Text("Skip") }
        }
    }
}
EOF

# ============ GITHUB ACTIONS ============

cat > ".github/workflows/build-apk.yml" << 'EOF'
name: Build APK

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up JDK 17
      uses: actions/setup-java@v4
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: gradle

    - name: Setup Android SDK
      uses: android-actions/setup-android@v3

    - name: Generate Gradle Wrapper
      run: |
        gradle wrapper --gradle-version 8.4 || true

    - name: Grant execute permission for gradlew
      run: chmod +x gradlew || true

    - name: Build Debug APK
      run: ./gradlew assembleDebug --stacktrace

    - name: Upload APK
      uses: actions/upload-artifact@v4
      with:
        name: SpeakEasy-APK
        path: app/build/outputs/apk/debug/app-debug.apk
        retention-days: 30
EOF

# ============ CREATE ZIP ============

cd ..
echo ""
echo "✅ All 42 files created successfully!"
echo ""
echo "📦 Creating ZIP archive..."

# Create ZIP file
if command -v zip &> /dev/null; then
    zip -r "$PROJECT_NAME.zip" "$PROJECT_NAME" -x "*.DS_Store"
    echo ""
    echo "🎉 SUCCESS! Your ZIP file is ready:"
    echo "   📁 $(pwd)/$PROJECT_NAME.zip"
    echo ""
    echo "📱 Next steps:"
    echo "   1. Upload the ZIP contents to GitHub"
    echo "   2. Add GitHub Actions workflow"
    echo "   3. Build APK in the cloud"
    echo ""
else
    echo "⚠️  'zip' command not found. Creating tar.gz instead..."
    tar -czf "$PROJECT_NAME.tar.gz" "$PROJECT_NAME"
    echo ""
    echo "🎉 SUCCESS! Your archive is ready:"
    echo "   📁 $(pwd)/$PROJECT_NAME.tar.gz"
fi