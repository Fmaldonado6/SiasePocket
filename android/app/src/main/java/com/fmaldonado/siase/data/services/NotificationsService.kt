package com.fmaldonado.siase.data.services

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat.getSystemService
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Notifications
import com.fmaldonado.siase.data.persistence.entities.NotificationsEntity
import com.fmaldonado.siase.ui.SiaseApplication
import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class NotificationsService
@Inject
constructor(
    private val application: SiaseApplication
) {

    companion object {
        const val CHANNEL_ID = "Schedules"

    }

    init {
        createNotificationChannel()
    }

    private fun createNotificationChannel() {


    }

    fun scheduleNotification(notification: NotificationsEntity) {
        val intent = Intent(application, NotificationReceiver::class.java)
        intent.putExtra(Notifications.TITLE, notification.title)
        intent.putExtra(Notifications.DESCRIPTION, notification.description)
        intent.putExtra(Notifications.TIME, notification.time)
        intent.putExtra(Notifications.ID, notification.id)

        val pendingIntent = PendingIntent.getBroadcast(
            application,
            notification.id,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        val time = Calendar.getInstance().apply { timeInMillis = notification.time }
        val calendar = Calendar.getInstance()

        calendar.timeInMillis = System.currentTimeMillis()
        calendar.set(
            Calendar.HOUR_OF_DAY,
            time.get(Calendar.HOUR_OF_DAY)
        )
        calendar.set(
            Calendar.MINUTE,
            time.get(Calendar.MINUTE)
        )

        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)

        calendar.set(
            Calendar.DAY_OF_WEEK,
            time.get(Calendar.DAY_OF_WEEK)
        )

        if (calendar.timeInMillis < System.currentTimeMillis())
            calendar.add(Calendar.DAY_OF_YEAR, 7)

        val alarmManager = application.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(pendingIntent)
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            calendar.timeInMillis,
            pendingIntent
        )

    }

    fun deleteNotification(notification: NotificationsEntity) {
        val intent = Intent(application, NotificationReceiver::class.java)
        intent.putExtra(Notifications.TITLE, notification.title)
        intent.putExtra(Notifications.DESCRIPTION, notification.description)
        intent.putExtra(Notifications.TIME, notification.time)
        intent.putExtra(Notifications.ID, notification.id)

        val pendingIntent = PendingIntent.getBroadcast(
            application,
            notification.id,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val alarmManager = application.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(pendingIntent)
    }


}