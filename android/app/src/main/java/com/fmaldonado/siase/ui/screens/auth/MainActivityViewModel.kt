package com.fmaldonado.siase.ui.screens.auth

import android.util.Log
import androidx.annotation.StringRes
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.preference.Preference
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Preferences
import com.fmaldonado.siase.data.network.AppError
import com.fmaldonado.siase.data.preferences.PreferencesService
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.MainCareerRepository
import com.fmaldonado.siase.data.repositories.PreferencesRepository
import com.fmaldonado.siase.data.repositories.ScheduleRepository
import com.fmaldonado.siase.ui.base.BaseActivity
import com.fmaldonado.siase.ui.base.BaseViewModel
import com.fmaldonado.siase.ui.utils.Status
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.lang.Exception
import javax.inject.Inject

@HiltViewModel
class MainActivityViewModel
@Inject
constructor(
    private val authRepository: AuthRepository,
    private val mainCareerRepository: MainCareerRepository,
    private val scheduleRepository: ScheduleRepository,
    preferencesRepository: PreferencesRepository
) : BaseViewModel(authRepository, preferencesRepository) {
    
    val needsSelection = MutableLiveData<Boolean>()

    val snackBar = MutableLiveData<Triple<Int, Int?, (() -> Unit)?>>()

    private var previousSession: Preferences? = null;

    fun checkSession() {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                status.postValue(Status.Loading)
                val hasSession = authRepository.checkSession()
                previousSession = authRepository.getSession()

                if (hasSession) {
                    authRepository.restoreSession()
                    status.postValue(Status.Completed)
                    return@launch
                }
                status.postValue(Status.Loaded)

            } catch (e: Exception) {
                snackBar.postValue(Triple(R.string.sessionError, R.string.retryText) {
                    checkSession()
                })
                status.postValue(Status.Loaded)

            }
        }
    }

    fun signIn(username: String, password: String) {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                status.postValue(Status.Loading)
                previousSession = authRepository.getSession()
                authRepository.signIn(username, password)
                status.postValue(Status.Completed)
            } catch (exception: Exception) {
                snackBar.postValue(Triple(R.string.credentialsError, null, null))
                status.postValue(Status.Loaded)
            }
        }
    }

    fun checkIfNeedsSelection() {
        viewModelScope.launch(Dispatchers.IO) {
            val mainCareer = mainCareerRepository.getMainCareer()
            val mainSchedule = mainCareerRepository.getMainSchedule()
            val currentSession = authRepository.getSession()

            if (mainCareer == null || mainSchedule == null) {
                needsSelection.postValue(true)
                return@launch
            }

            if (previousSession!!.user != currentSession.user) {
                needsSelection.postValue(true)
                return@launch
            }

            needsSelection.postValue(false)
        }
    }
}