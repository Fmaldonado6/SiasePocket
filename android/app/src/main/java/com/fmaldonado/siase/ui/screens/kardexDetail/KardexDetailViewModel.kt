package com.fmaldonado.siase.ui.screens.kardexDetail

import android.util.Log
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Kardex
import com.fmaldonado.siase.data.models.Subject
import com.fmaldonado.siase.data.network.Unauthorized
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.KardexRepository
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
class KardexDetailViewModel
@Inject
constructor(
    private val kardexRepository: KardexRepository,
    private val authRepository: AuthRepository,
    preferencesRepository: PreferencesRepository
) : BaseViewModel(authRepository, preferencesRepository) {

    val kardexList = MutableLiveData<List<List<Subject>>>()

    fun getKardex(career: Careers, cacheEnabled: Boolean = true) {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                status.postValue(Status.Loading)
                getKardexProcess(career, cacheEnabled)
                status.postValue(Status.Loaded)
            } catch (e: Exception) {
                Log.e("Error", "e", e)
                when (e) {
                    is Unauthorized -> restoreSession { getKardexProcess(career, cacheEnabled) }
                    else -> {
                        FirebaseCrashlytics.getInstance().recordException(e)
                        status.postValue(Status.Error)
                    }
                }
            }
        }
    }


    private suspend fun getKardexProcess(career: Careers, cacheEnabled: Boolean = true) {
        val result = kardexRepository.getKardex(career, cacheEnabled)
        getKardexList(result)
    }

    private fun getKardexList(kardex: Kardex) {
        val map = HashMap<String, MutableList<Subject>>()

        for (subject in kardex.materias) {
            val value = map[subject.semestreMateria]
            if (value == null)
                map[subject.semestreMateria] = mutableListOf(subject)
            else
                value.add(subject)
        }

        kardexList.postValue(map.values.toList())
    }
}