package com.fmaldonado.siase.data.models

import java.util.*

data class Notifications(
    val id: Int,
    val title: String,
    val description: String,
    val time: Calendar
) {
    companion object {
        const val TITLE = "NotificationTitle"
        const val DESCRIPTION = "NotificationsDescription"
        const val TIME = "NotificationsTime"
        const val ID = "NotificationsId"
    }
}

