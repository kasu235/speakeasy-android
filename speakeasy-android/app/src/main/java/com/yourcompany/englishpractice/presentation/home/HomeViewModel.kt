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
