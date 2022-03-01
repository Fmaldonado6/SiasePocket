package com.fmaldonado.siase.data.services

import android.app.Notification
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Notifications
import com.fmaldonado.siase.data.persistence.entities.NotificationsEntity
import com.fmaldonado.siase.ui.utils.safeLet
import dagger.hilt.android.AndroidEntryPoint
import java.util.*
import javax.inject.Inject

@AndroidEntryPoint
class NotificationReceiver : BroadcastReceiver() {

    @Inject
    lateinit var notificationsService: NotificationsService

    override fun onReceive(context: Context?, intent: Intent?) {

        safeLet(context, intent) { con, int ->

            val notificationData = NotificationsEntity(
                id = int.getIntExtra(Notifications.ID, 0),
                title = int.getStringExtra(Notifications.TITLE) ?: "",
                description = int.getStringExtra(Notifications.DESCRIPTION) ?: "",
                time = Calendar.getInstance().apply {
                    timeInMillis = int.getLongExtra(Notifications.TIME, this.timeInMillis)
                    add(Calendar.DAY_OF_YEAR, 7)
                }.timeInMillis

            )

            val notification = NotificationCompat.Builder(
                con,
                NotificationsService.CHANNEL_ID,
                ).setSmallIcon(R.drawable.notification_icon)
                .setContentTitle(notificationData.title)
                .setContentText(notificationData.description)
                .setDefaults(Notification.DEFAULT_ALL)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .build()

            notificationsService.scheduleNotification(
                notificationData
            )

            val manager = con.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.notify(
                notificationData.id,
                notification
            )
        }
    }
}