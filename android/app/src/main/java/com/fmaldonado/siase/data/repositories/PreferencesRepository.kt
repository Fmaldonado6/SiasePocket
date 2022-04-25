package com.fmaldonado.siase.data.repositories

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.fmaldonado.siase.data.preferences.PreferencesService
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PreferencesRepository
@Inject
constructor(
    private val preferencesService: PreferencesService
) {

    private val themeChanged = MutableLiveData<Int>()

    fun getThemeChange() = themeChanged as LiveData<Int>

    fun getTheme(): Int {
        val preferences = preferencesService.getPreferences()
        return preferences.selectedTheme
    }

    fun changeTheme(theme: Int) {
        val preferences = preferencesService.getPreferences()
        preferences.selectedTheme = theme
        preferencesService.save(preferences)
        themeChanged.postValue(theme)
    }

}