package com.fmaldonado.siase.data.persistence.dao

import androidx.room.*
import com.fmaldonado.siase.data.persistence.entities.MainCareerEntity
import com.fmaldonado.siase.data.persistence.entities.MainScheduleEntity

@Dao
abstract class MainScheduleDao {
    @Transaction
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    abstract suspend fun addMainSchedule(mainScheduleEntity: MainScheduleEntity): Long

    @Transaction
    @Query("SELECT * from mainSchedule where id=0")
    abstract suspend fun getMainSchedule(): MainScheduleEntity?

    @Transaction
    @Query("delete from mainSchedule")
    abstract suspend fun deleteMainSchedule()
}