package com.fmaldonado.siase.ui.screens.home.fragments.afis.tabs.next

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.fmaldonado.siase.data.models.Afi
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Subject
import com.fmaldonado.siase.data.network.Unauthorized
import com.fmaldonado.siase.data.repositories.AfisRepository
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.MainCareerRepository
import com.fmaldonado.siase.data.repositories.PreferencesRepository
import com.fmaldonado.siase.ui.base.BaseViewModel
import com.fmaldonado.siase.ui.utils.Status
import com.google.firebase.crashlytics.FirebaseCrashlytics
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.lang.Exception
import javax.inject.Inject

@HiltViewModel
class NextAfisViewModel
@Inject
constructor(
    private val authRepository: AuthRepository,
    private val afisRepository: AfisRepository,
    private val mainCareerRepository: MainCareerRepository,
    preferencesRepository: PreferencesRepository
) : BaseViewModel(authRepository, preferencesRepository) {

    private val afisList = MutableLiveData<List<Afi>>()

    val afis = afisList as LiveData<List<Afi>>

    fun getAfis(month: Int, cacheEnabled: Boolean = true) {
        viewModelScope.launch(Dispatchers.IO) {
            val career = mainCareerRepository.getMainCareer()

            if (career == null) {
                status.postValue(Status.Error)
                return@launch
            }

            try {
                status.postValue(Status.Loading)
                getAfisProcess(career, month, cacheEnabled)
                status.postValue(Status.Loaded)
            } catch (e: Exception) {
                Log.e("Error", "e", e)
                when (e) {
                    is Unauthorized -> restoreSession {
                        getAfisProcess(
                            career,
                            month,
                            cacheEnabled
                        )
                    }
                    else -> {
                        FirebaseCrashlytics.getInstance().recordException(e)
                        status.postValue(Status.Error)
                    }
                }
            }
        }
    }


    private suspend fun getAfisProcess(career: Careers, month: Int, cacheEnabled: Boolean = true) {
        val result = afisRepository.getAfis(career, month, cacheEnabled)
        afisList.postValue(result.sortedBy {
            return@sortedBy it.fechaInicio
        })
    }

}