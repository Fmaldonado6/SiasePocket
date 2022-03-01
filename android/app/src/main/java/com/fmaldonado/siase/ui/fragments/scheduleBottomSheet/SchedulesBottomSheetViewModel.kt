package com.fmaldonado.siase.ui.fragments.scheduleBottomSheet

import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Schedule
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
class SchedulesBottomSheetViewModel
@Inject
constructor(
    authRepository: AuthRepository,
    private val scheduleRepository: ScheduleRepository,
) : BaseViewModel(authRepository) {

    val schedules = MutableLiveData<List<Schedule>>()

    fun getSchedules(career: Careers) {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                status.postValue(Status.Loading)
                getSchedulesProcess(career)
                status.postValue(Status.Loaded)
            } catch (e: Exception) {
                Log.e("Error", "error", e)
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

}