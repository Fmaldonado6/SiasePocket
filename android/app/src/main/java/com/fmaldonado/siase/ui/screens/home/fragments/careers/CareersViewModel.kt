package com.fmaldonado.siase.ui.screens.home.fragments.careers

import androidx.lifecycle.ViewModel
import com.fmaldonado.siase.data.repositories.AuthRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class CareersViewModel
@Inject
constructor(
    private val authRepository: AuthRepository
) : ViewModel() {

    val carreras = authRepository.signedInUser?.carreras

}