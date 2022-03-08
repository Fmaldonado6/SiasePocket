package com.fmaldonado.siase.ui.screens.home

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.MainCareerRepository
import com.fmaldonado.siase.ui.base.BaseViewModel
import com.fmaldonado.siase.ui.utils.Status
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class HomeActivityViewModel
@Inject
constructor(
    private val authRepository: AuthRepository,
    private val mainCareerRepository: MainCareerRepository
) : BaseViewModel(authRepository) {

    val classDetail = MutableLiveData<ClassDetail>()

    init {
        status.value = Status.Loaded
    }

    fun openFragment(claveMateria: String) {
        viewModelScope.launch(Dispatchers.IO) {
            val savedClass = mainCareerRepository.getNotificationClass(claveMateria)
            savedClass?.let {
                classDetail.postValue(it)
            }
        }
    }


}