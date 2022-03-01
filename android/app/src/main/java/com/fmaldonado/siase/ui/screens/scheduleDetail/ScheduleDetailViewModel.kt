package com.fmaldonado.siase.ui.screens.scheduleDetail

import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.models.ScheduleDetail
import com.fmaldonado.siase.data.network.Unauthorized
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.ScheduleRepository
import com.fmaldonado.siase.ui.base.BaseViewModel
import com.fmaldonado.siase.ui.utils.Status
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.lang.Exception
import javax.inject.Inject

@HiltViewModel
class ScheduleDetailViewModel
@Inject
constructor(
    private val scheduleRepository: ScheduleRepository,
    private val authRepository: AuthRepository
) : BaseViewModel(authRepository) {

    val schedule = MutableLiveData<List<List<ClassDetail>>>()


    fun getSchedule(careers: Careers, periodo: String) {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                status.postValue(Status.Loading)
                getScheduleProcess(careers, periodo)
                status.postValue(Status.Loaded)
            } catch (e: Exception) {
                when (e) {
                    is Unauthorized -> restoreSession { getScheduleProcess(careers, periodo) }
                    else -> status.postValue(Status.Error)
                }
            }
        }

    }

    private suspend fun getScheduleProcess(careers: Careers, periodo: String) {
        val detail = scheduleRepository.getScheduleDetail(careers, periodo)
        getScheduleList(detail)
    }

    fun getScheduleList(detail: ScheduleDetail) {
        val scheduleList = mutableListOf<List<ClassDetail>>()
        scheduleList.add(detail.getFormattedDetail(detail.lunes))
        scheduleList.add(detail.getFormattedDetail(detail.martes))
        scheduleList.add(detail.getFormattedDetail(detail.miercoles))
        scheduleList.add(detail.getFormattedDetail(detail.jueves))
        scheduleList.add(detail.getFormattedDetail(detail.viernes))
        scheduleList.add(detail.getFormattedDetail(detail.sabado))
        schedule.postValue(scheduleList)
        status.postValue(Status.Loaded)
    }

}