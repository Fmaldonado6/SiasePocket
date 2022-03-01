package com.fmaldonado.siase.data.repositories

import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.persistence.dao.TodayScheduleDao
import com.fmaldonado.siase.data.persistence.mappers.TodayClassesToEntityMapper
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ScheduleRepository
@Inject
constructor(
    private val todayScheduleDao: TodayScheduleDao
) {

    suspend fun saveSchedule(list: List<ClassDetail>) {
        todayScheduleDao.insertClasses(list.map {
            TodayClassesToEntityMapper.classToEntityMapper(it)
        })
    }

    suspend fun deleteSchedule() {
        todayScheduleDao.deleteTodaySchedule()
    }

    suspend fun getSchedule(): List<ClassDetail> = todayScheduleDao.getTodayClasses().map {
        TodayClassesToEntityMapper.entityToClassMapper(it)
    }

}