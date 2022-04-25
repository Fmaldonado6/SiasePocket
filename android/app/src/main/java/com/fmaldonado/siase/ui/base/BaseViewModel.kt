package com.fmaldonado.siase.ui.base

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fmaldonado.siase.data.preferences.PreferencesService
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.PreferencesRepository
import com.fmaldonado.siase.ui.utils.Status
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.lang.Exception

abstract class BaseViewModel(
    private val authRepository: AuthRepository,
    private val preferencesRepository: PreferencesRepository
) : ViewModel() {

    val status = MutableLiveData(Status.Loading)

    val themeListener = preferencesRepository.getThemeChange()

    fun getTheme(): Int =
        preferencesRepository.getTheme()


    suspend fun restoreSession(process: suspend () -> Unit) {
        try {
            status.postValue(Status.Loading)
            authRepository.restoreSession()
            process()
            status.postValue(Status.Loaded)
        } catch (e: Exception) {
            status.postValue(Status.Error)
        }
    }


}