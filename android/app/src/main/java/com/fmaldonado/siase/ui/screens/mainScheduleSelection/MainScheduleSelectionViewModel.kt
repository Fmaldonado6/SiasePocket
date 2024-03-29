package com.fmaldonado.siase.ui.screens.mainScheduleSelection

import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Schedule
import com.fmaldonado.siase.data.network.Unauthorized
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.MainCareerRepository
import com.fmaldonado.siase.data.repositories.PreferencesRepository
import com.fmaldonado.siase.data.repositories.ScheduleRepository
import com.fmaldonado.siase.ui.base.BaseViewModel
import com.fmaldonado.siase.ui.utils.Status
import com.google.firebase.crashlytics.FirebaseCrashlytics
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.lang.Exception
import javax.inject.Inject

@HiltViewModel
class MainScheduleSelectionViewModel
@Inject
constructor(
    private val scheduleRepository: ScheduleRepository,
    private val mainCareerRepository: MainCareerRepository,
    private val authRepository: AuthRepository,
    preferencesRepository: PreferencesRepository
) : BaseViewModel(authRepository, preferencesRepository) {


    val schedules = MutableLiveData<List<Schedule>>()

    fun getSchedules(career: Careers) {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                status.postValue(Status.Loading)
                getSchedulesProcess(career)
                status.postValue(Status.Loaded)

            } catch (e: Exception) {
                when (e) {
                    is Unauthorized -> restoreSession { getSchedulesProcess(career) }
                    else -> status.postValue(Status.Error)
                }

            }
        }
    }

    private suspend fun getSchedulesProcess(career: Careers) {
        val result = scheduleRepository.getSchedules(career)
        schedules.postValue(result)
    }

    private suspend fun getMainCareerAndScheduleProcess(career: Careers, schedule: Schedule) {
        mainCareerRepository.selectMainCareer(career)
        mainCareerRepository.selectMainSchedule(schedule)
        scheduleRepository.resetSchedule()
    }

    fun setMainCareerAndSchedule(career: Careers, schedule: Schedule) {
        viewModelScope.launch {
            try {
                status.postValue(Status.Loading)
                getMainCareerAndScheduleProcess(career, schedule)
                status.postValue(Status.Completed)

            } catch (e: Exception) {
                when (e) {
                    is Unauthorized -> restoreSession {
                        getMainCareerAndScheduleProcess(career, schedule)
                    }
                    else -> status.postValue(Status.Error)
                }

            }
        }
    }

}