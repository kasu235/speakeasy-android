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
