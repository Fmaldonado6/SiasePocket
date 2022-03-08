package com.fmaldonado.siase.data.persistence

import androidx.room.Database
import androidx.room.RoomDatabase
import com.fmaldonado.siase.data.persistence.dao.*
import com.fmaldonado.siase.data.persistence.entities.*

@Database(
    version = 10,
    entities = [
        MainScheduleEntity::class,
        MainCareerEntity::class,
        TodayClassesEntity::class,
        NotificationsEntity::class,
        MainScheduleClassesEntity::class
    ],

    )
abstract class Database : RoomDatabase() {


    abstract fun mainCareerDao(): MainCareerDao

    abstract fun mainScheduleDao(): MainScheduleDao

    abstract fun todaySchedule(): TodayScheduleDao

    abstract fun notificationsDao(): NotificationsDao

    abstract fun mainScheduleClassesDao(): MainScheduleClassesDao

    companion object {
        const val DATABASE_NAME = "siase_db"

    }
}