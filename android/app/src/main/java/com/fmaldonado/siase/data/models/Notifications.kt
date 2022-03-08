package com.fmaldonado.siase.data.models

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import java.util.*

@Parcelize
data class Notifications(
    val id: Int,
    val title: String,
    val claveMateria:String,
    val description: String,
    val time: Calendar
) :Parcelable{
    companion object {
        const val TITLE = "NotificationTitle"
        const val DESCRIPTION = "NotificationsDescription"
        const val TIME = "NotificationsTime"
        const val ID = "NotificationsId"
        const val SUBJECT_ID = "SubjectId"
    }
}

