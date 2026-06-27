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
