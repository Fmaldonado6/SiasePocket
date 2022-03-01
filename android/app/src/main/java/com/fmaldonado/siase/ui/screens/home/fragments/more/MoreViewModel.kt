package com.fmaldonado.siase.ui.screens.home.fragments.more

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Schedule
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.MainCareerRepository
import com.fmaldonado.siase.data.repositories.ScheduleRepository
import com.fmaldonado.siase.ui.base.BaseViewModel
import com.fmaldonado.siase.ui.utils.Status
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MoreViewModel
@Inject
constructor(
    private val authRepository: AuthRepository,
    private val scheduleRepository: ScheduleRepository,
    private val mainCareerRepository: MainCareerRepository
) : BaseViewModel(authRepository) {

    val currentUser = authRepository.signedInUser!!

    val mainCareer = MutableLiveData<Careers>()

    val mainSchedule = MutableLiveData<Schedule>()
    val notifications = MutableLiveData<Boolean>()

    fun getCurrentCareer() {
        viewModelScope.launch(Dispatchers.IO) {
            val career = mainCareerRepository.getMainCareer()
            career?.let {
                mainCareer.postValue(it)
            }
        }
    }

    fun signOut() {
        viewModelScope.launch(Dispatchers.IO) {
            authRepository.signOut()
            scheduleRepository.resetSchedule()
            status.postValue(Status.Completed)
        }
    }

    fun getCurrentSchedule() {
        viewModelScope.launch(Dispatchers.IO) {
            val schedule = mainCareerRepository.getMainSchedule()
            schedule?.let {
                mainSchedule.postValue(it)
            }
        }
    }

    fun getNotificationsPreferences() {
        val hasNotifications = mainCareerRepository.getNotificationsPreferences()
        notifications.postValue(hasNotifications)
    }

    fun setNotificationsPreferences(checked:Boolean){
        viewModelScope.launch {
            mainCareerRepository.setNotificationsPreferences(checked)
            notifications.postValue(checked)
        }
    }

}