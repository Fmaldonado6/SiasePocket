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
import com.fmaldonado.siase.data.repositories.ScheduleRepository
import com.fmaldonado.siase.ui.base.BaseViewModel
import com.fmaldonado.siase.ui.utils.Status
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
    private val authRepository: AuthRepository
) : BaseViewModel(authRepository) {


    val schedules = MutableLiveData<List<Schedule>>()

    fun getSchedules(careerId: String) {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                status.postValue(Status.Loading)
                getSchedulesProcess(careerId)
                status.postValue(Status.Loaded)

            } catch (e: Exception) {
                when (e) {
                    is Unauthorized -> restoreSession { getSchedulesProcess(careerId) }
                    else -> status.postValue(Status.Error)
                }

            }
        }
    }

    private suspend fun getSchedulesProcess(careerId: String) {
        val careers = authRepository.signedInUser!!.carreras
        val index = careers.indexOfFirst { it.claveCarrera == careerId }
        val result = scheduleRepository.getSchedules(index)
        schedules.postValue(result)
    }

    fun setMainCareerAndSchedule(career: Careers, schedule: Schedule) {
        viewModelScope.launch {
            try {
                status.postValue(Status.Loading)
                mainCareerRepository.selectMainCareer(career)
                mainCareerRepository.selectMainSchedule(schedule)
                scheduleRepository.resetSchedule()
                status.postValue(Status.Completed)

            } catch (e: Exception) {
                status.postValue(Status.Error)
            }
        }
    }

}