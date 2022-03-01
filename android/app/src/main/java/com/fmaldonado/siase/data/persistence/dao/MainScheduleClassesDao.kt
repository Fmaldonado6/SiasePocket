package com.fmaldonado.siase.data.persistence.dao

import androidx.room.*
import com.fmaldonado.siase.data.persistence.entities.MainScheduleClassesEntity
import com.fmaldonado.siase.data.persistence.entities.NotificationsEntity

@Dao
abstract class MainScheduleClassesDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    abstract suspend fun insertClass(todayClassesEntity: MainScheduleClassesEntity): Long

    @Transaction
    @Query("SELECT * from mainScheduleClasses")
    abstract suspend fun getClasses(): List<MainScheduleClassesEntity>


    @Transaction
    @Query("delete from mainScheduleClasses")
    abstract suspend fun deleteClasses()

    suspend fun insertClasses(classes: List<MainScheduleClassesEntity>) {
        for (classDetail in classes) {
            insertClass(classDetail)
        }
    }
}