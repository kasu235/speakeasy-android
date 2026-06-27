package com.yourcompany.englishpractice.presentation.navigation

sealed class Screen(val route: String) {
    object Home : Screen("home")
    object DailyLesson : Screen("daily_lesson")
    object FreeTalk : Screen("free_talk")
    object CategoryDetail : Screen("category_detail/{categoryId}") {
        fun createRoute(categoryId: String) = "category_detail/$categoryId"
    }
}
