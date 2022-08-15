package com.fmaldonado.siase.ui.screens.home.fragments.home

import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.models.ScheduleDetail
import com.fmaldonado.siase.data.network.AppError
import com.fmaldonado.siase.data.network.Unauthorized
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.PreferencesRepository
import com.fmaldonado.siase.data.repositories.ScheduleRepository
import com.fmaldonado.siase.ui.base.BaseViewModel
import com.fmaldonado.siase.ui.utils.Status
import com.google.firebase.crashlytics.FirebaseCrashlytics
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.lang.Exception
import java.lang.RuntimeException
import javax.inject.Inject

@HiltViewModel
class HomeFragmentViewModel
@Inject
constructor(
    private val authRepository: AuthRepository,
    private val scheduleRepository: ScheduleRepository,
    preferencesRepository: PreferencesRepository
) : BaseViewModel(authRepository,preferencesRepository) {

    val nextClass = MutableLiveData<ClassDetail?>()
    val todaySchedule = MutableLiveData<List<ClassDetail>?>()

    val userInfo = authRepository.signedInUser


    fun getTodaySchedule() {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                status.postValue(Status.Loading)
                getTodayScheduleProcess()
                status.postValue(Status.Loaded)
            } catch (e: Exception) {
                when (e) {
                    is Unauthorized -> restoreSession { getTodayScheduleProcess() }
                    else -> {
                        FirebaseCrashlytics.getInstance().recordException(e)
                        status.postValue(Status.Error)
                    }
                }
            }
        }
    }

    fun getFullSchedule() = scheduleRepository.getFullSchedule()

    private suspend fun getTodayScheduleProcess() {
        val schedule = scheduleRepository.getTodaySchedule()

        todaySchedule.postValue(schedule)
        if (schedule != null)
            nextClass.postValue(scheduleRepository.getNextClass(schedule))
        else
            nextClass.postValue(null)
    }

}