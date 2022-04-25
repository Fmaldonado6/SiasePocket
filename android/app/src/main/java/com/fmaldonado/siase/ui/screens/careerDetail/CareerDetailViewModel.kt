package com.fmaldonado.siase.ui.screens.careerDetail

import androidx.lifecycle.ViewModel
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.data.repositories.PreferencesRepository
import com.fmaldonado.siase.ui.base.BaseViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class CareerDetailViewModel
@Inject
constructor(
    private val authRepository: AuthRepository,
    preferencesRepository: PreferencesRepository
) : BaseViewModel(authRepository,preferencesRepository) {
}