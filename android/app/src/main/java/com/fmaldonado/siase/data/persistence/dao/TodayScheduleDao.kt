package com.fmaldonado.siase.data.persistence.dao

import androidx.room.*
import com.fmaldonado.siase.data.persistence.entities.MainScheduleEntity
import com.fmaldonado.siase.data.persistence.entities.TodayClassesEntity

@Dao
abstract class TodayScheduleDao {

    @Transaction
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    abstract suspend fun insertClass(todayClassesEntity: TodayClassesEntity): Long

    @Transaction
    @Query("SELECT * from todaySchedule")
    abstract suspend fun getTodayClasses(): List<TodayClassesEntity>


    @Transaction
    @Query("delete from todaySchedule")
    abstract suspend fun deleteTodaySchedule()

    suspend fun insertClasses(classes: List<TodayClassesEntity>) {
        for (todayClass in classes) {
            insertClass(todayClass)
        }
    }

}