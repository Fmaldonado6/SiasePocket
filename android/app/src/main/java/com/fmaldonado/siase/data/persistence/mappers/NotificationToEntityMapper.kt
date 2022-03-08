package com.fmaldonado.siase.data.persistence.mappers

import com.fmaldonado.siase.data.models.Notifications
import com.fmaldonado.siase.data.persistence.entities.NotificationsEntity
import java.util.*

object NotificationToEntityMapper {


    fun notificationToEntity(notification:Notifications):NotificationsEntity{
        return  NotificationsEntity(
            id = notification.id,
            title = notification.title,
            description = notification.description,
            time = notification.time.timeInMillis,
            claveMateria = notification.claveMateria
        )
    }

    fun entityToNotification(notification:NotificationsEntity):Notifications{
        return  Notifications(
            id = notification.id,
            title = notification.title,
            description = notification.description,
            time = Calendar.getInstance().apply {
                timeInMillis = notification.time
            },
            claveMateria = notification.claveMateria
        )
    }

}