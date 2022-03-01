package com.fmaldonado.siase.data.preferences

import android.content.Context
import com.fmaldonado.siase.data.models.Preferences
import com.fmaldonado.siase.data.models.PreferencesKeys
import com.fmaldonado.siase.data.models.SignInResponse
import com.fmaldonado.siase.ui.SiaseApplication
import com.google.gson.Gson
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class PreferencesService
@Inject
constructor(
    val context: SiaseApplication
) {
    private val preferences = context.getSharedPreferences(
        PREFERENCES_NAME,
        Context.MODE_PRIVATE
    )

    private val gson = Gson()

    companion object {
        private const val PREFERENCES_NAME = "SiasePreferences"

    }

    fun save(newPreferences: Preferences) {
        preferences.edit().apply {
            this.putString(PreferencesKeys.User.name, newPreferences.user)
            this.putString(PreferencesKeys.Password.name, newPreferences.password)
            this.putString(PreferencesKeys.Session.name, gson.toJson(newPreferences.session))
            this.putBoolean(PreferencesKeys.Notifications.name, newPreferences.notifications)
            apply()
        }
    }

    fun getPreferences(): Preferences {
        val savedPreferences = Preferences()
        savedPreferences.user = preferences.getString(PreferencesKeys.User.name, null)
        savedPreferences.password = preferences.getString(PreferencesKeys.Password.name, null)
        savedPreferences.notifications = preferences.getBoolean(
            PreferencesKeys.Notifications.name,
            true
        )

        val json = preferences.getString(PreferencesKeys.Session.name, null)
        if (json != null)
            savedPreferences.session = gson.fromJson(json, SignInResponse::class.java)
        return savedPreferences
    }

    fun getToken(): String? {
        val savedPreferences = Preferences()

        val json = preferences.getString(PreferencesKeys.Session.name, null)
        if (json != null)
            savedPreferences.session = gson.fromJson(json, SignInResponse::class.java)
        return savedPreferences.session?.token
    }

    fun delete() {
        preferences.edit().apply {
            clear()
            apply()
        }
    }
}