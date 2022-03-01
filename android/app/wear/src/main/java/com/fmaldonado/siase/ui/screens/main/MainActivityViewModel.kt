package com.fmaldonado.siase.ui.screens.main

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.models.Preferences
import com.fmaldonado.siase.data.repositories.ScheduleRepository
import com.fmaldonado.siase.ui.utils.Status
import com.fmaldonado.siase.ui.utils.parseTime
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.time.LocalTime
import java.time.temporal.ChronoUnit
import javax.inject.Inject

@HiltViewModel
class MainActivityViewModel
@Inject
constructor(
    private val scheduleRepository: ScheduleRepository
) : ViewModel() {

    private val status = MutableLiveData(Status.Loading)

    private val todayClass = MutableLiveData<ClassDetail?>()

    private val todaySchedule = MutableLiveData<List<ClassDetail>>()

    fun getStatus() = status as LiveData<Status>

    fun getTodayClass() = todayClass as LiveData<ClassDetail?>

    fun getTodaySchedule() = todaySchedule as LiveData<List<ClassDetail>>

    fun loadCacheSchedule() {
        viewModelScope.launch(Dispatchers.IO) {
            val schedule = scheduleRepository.getSchedule()
            setSchedule(schedule)
        }
    }

    fun setTodaySchedule(schedule: List<ClassDetail>) {

        viewModelScope.launch(Dispatchers.IO) {
            scheduleRepository.deleteSchedule()
            scheduleRepository.saveSchedule(schedule)
            setSchedule(schedule)
        }

    }

    private fun setSchedule(schedule: List<ClassDetail>) {
        if (schedule.isEmpty()) {
            status.postValue(Status.Empty)
            return
        }

        val now = LocalTime.now()

        var nextClass: ClassDetail? = null

        for (classDetail in schedule) {
            val startTime = parseTime(classDetail.horaInicio)
            val difference = ChronoUnit.MINUTES.between(now, startTime)

            if (difference > 0) {
                nextClass = classDetail
                break
            }
        }

        todayClass.postValue(nextClass)
        todaySchedule.postValue(schedule)
        status.postValue(Status.Loaded)
    }

}