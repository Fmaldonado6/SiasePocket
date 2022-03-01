package com.fmaldonado.siase.data.persistence.dao

import androidx.room.*
import com.fmaldonado.siase.data.persistence.entities.MainScheduleClassesEntity
import com.fmaldonado.siase.data.persistence.entities.NotificationsEntity

@Dao
abstract class NotificationsDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    abstract suspend fun insertNotification(todayClassesEntity: NotificationsEntity): Long

    @Transaction
    @Query("SELECT * from notifications")
    abstract suspend fun getNotifications(): List<NotificationsEntity>


    @Transaction
    @Query("delete from notifications")
    abstract suspend fun deleteNotifications()

    suspend fun insertNotifications(notifications: List<NotificationsEntity>) {
        for (notification in notifications) {
            insertNotification(notification)
        }
    }
}