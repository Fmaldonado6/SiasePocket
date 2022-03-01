package com.fmaldonado.siase.data.persistence

import androidx.room.Database
import androidx.room.RoomDatabase
import com.fmaldonado.siase.data.persistence.dao.TodayScheduleDao
import com.fmaldonado.siase.data.persistence.entities.TodayClassesEntity

@Database(
    version = 2,
    entities = [
        TodayClassesEntity::class
    ]
)
abstract class Database : RoomDatabase() {


    abstract fun todayScheduleDao(): TodayScheduleDao

    companion object {
        val DATABASE_NAME = "siase_wear_db"
    }
}