package com.fmaldonado.siase.ui.screens.home

import androidx.lifecycle.ViewModel
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.ui.base.BaseViewModel
import com.fmaldonado.siase.ui.utils.Status
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class HomeActivityViewModel
@Inject
constructor(
    private val authRepository: AuthRepository
) : BaseViewModel(authRepository) {

    init {
        status.value = Status.Loaded
    }


}