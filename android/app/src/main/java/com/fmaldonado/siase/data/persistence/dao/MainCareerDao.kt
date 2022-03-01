package com.fmaldonado.siase.data.persistence.dao

import androidx.room.*
import com.fmaldonado.siase.data.persistence.entities.MainCareerEntity

@Dao
abstract class MainCareerDao {

    @Transaction
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    abstract suspend fun addMainCareer(mainCareerEntity: MainCareerEntity): Long

    @Transaction
    @Query("SELECT * from mainCareer where id=0")
    abstract suspend fun getMainCareer(): MainCareerEntity?

    @Transaction
    @Query("delete from mainCareer")
    abstract suspend fun deleteMainCareer()

}