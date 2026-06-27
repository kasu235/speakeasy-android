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
