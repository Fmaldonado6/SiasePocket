package com.fmaldonado.siase.data.models


data class Preferences(
    var user: String? = null,
    var password: String? = null,
    var session: SignInResponse? = null,
    var notifications: Boolean = true,
    var selectedTheme: Int = Themes.Default.ordinal
)

enum class PreferencesKeys {
    User,
    Password,
    Session,
    Notifications,
    SelectedTheme
}
