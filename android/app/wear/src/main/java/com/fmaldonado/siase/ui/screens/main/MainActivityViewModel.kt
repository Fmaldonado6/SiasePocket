package com.fmaldonado.siase.ui.screens.main

import android.os.Handler
import android.os.Looper
import android.util.Log
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

    private val isPhoneConnected = MutableLiveData(true)

    private val isAppInstalled = MutableLiveData(true)

    private val messageTimer = Handler(Looper.getMainLooper())

    fun getStatus() = status as LiveData<Status>

    fun getTodayClass() = todayClass as LiveData<ClassDetail?>

    fun getTodaySchedule() = todaySchedule as LiveData<List<ClassDetail>>

    fun getIsPhoneConnected() = isPhoneConnected as LiveData<Boolean>

    fun getIsAppInstalled() = isAppInstalled as LiveData<Boolean>

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

    fun setIsAppInstalled(installed: Boolean) {
        isAppInstalled.postValue(installed)

    }

    fun setIsPhoneConnected(connected: Boolean) {
        isPhoneConnected.postValue(connected)
    }

    fun setStatus(status: Status) {
        this.status.postValue(status)
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

    fun startMessageTimer() {
        messageTimer.removeCallbacksAndMessages(null)
        messageTimer.postDelayed({
            isPhoneConnected.postValue(false)
            isAppInstalled.postValue(false)


        }, 5000)
    }

    fun stopTimer() {
        messageTimer.removeCallbacksAndMessages(null)
    }

}