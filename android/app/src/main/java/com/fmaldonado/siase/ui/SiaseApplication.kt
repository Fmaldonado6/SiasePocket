package com.fmaldonado.siase.ui

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.services.NotificationsService
import com.google.android.material.color.DynamicColors
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class SiaseApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        DynamicColors.applyToActivitiesIfAvailable(
            this
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = getString(R.string.notificationsChannelName)
            val descriptionText = getString(R.string.notificationsChannelDescription)
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(NotificationsService.CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            val notificationManager: NotificationManager = getSystemService(
                Context.NOTIFICATION_SERVICE
            ) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

}