package com.fmaldonado.siase.ui.screens.mainCareerSelection

import androidx.lifecycle.ViewModel
import com.fmaldonado.siase.data.repositories.AuthRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class MainCareerSelectionViewModel
@Inject
constructor(
    private val authRepository: AuthRepository
) : ViewModel() {

    val careers = authRepository.signedInUser!!.carreras

}