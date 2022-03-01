package com.fmaldonado.siase.data.repositories

import android.util.Log
import com.fmaldonado.siase.data.models.Preferences
import com.fmaldonado.siase.data.models.SignInRequest
import com.fmaldonado.siase.data.models.SignInResponse
import com.fmaldonado.siase.data.network.NetworkDataSource
import com.fmaldonado.siase.data.persistence.dao.MainCareerDao
import com.fmaldonado.siase.data.persistence.dao.MainScheduleDao
import com.fmaldonado.siase.data.preferences.PreferencesService
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthRepository
@Inject
constructor(
    private val networkDataSource: NetworkDataSource,
    private val preferencesService: PreferencesService,
    private val mainCareerDao: MainCareerDao,
    private val mainScheduleDao: MainScheduleDao
) {

    var signedInUser: SignInResponse?
        private set(value) {
            val preferences = preferencesService.getPreferences()
            preferences.session = value
            preferencesService.save(preferences)
        }
        get() {
            val preferences = preferencesService.getPreferences()
            return preferences.session
        }


    fun getSession(): Preferences {
        return preferencesService.getPreferences()
    }

    fun checkSession(): Boolean {
        val preferences = preferencesService.getPreferences()

        if (preferences.user == null ||
            preferences.password == null
        )
            return false

        return true
    }

    suspend fun restoreSession() {
        val preferences = preferencesService.getPreferences()
        signIn(preferences.user!!, preferences.password!!)
    }

    suspend fun signIn(username: String, password: String): SignInResponse? {
        val result = networkDataSource.signIn(SignInRequest(username, password))

        val preferences = preferencesService.getPreferences()

        preferences.session = result
        preferences.user = username
        preferences.password = password

        preferencesService.save(preferences)

        return signedInUser
    }

    suspend fun signOut() {
        preferencesService.delete()
        mainCareerDao.deleteMainCareer()
        mainScheduleDao.deleteMainSchedule()
    }

}