package com.fmaldonado.siase.data.repositories

import android.util.Log
import androidx.lifecycle.MutableLiveData
import com.fmaldonado.siase.data.models.*
import com.fmaldonado.siase.data.network.NetworkDataSource
import com.fmaldonado.siase.data.persistence.dao.MainCareerDao
import com.fmaldonado.siase.data.persistence.dao.MainScheduleClassesDao
import com.fmaldonado.siase.data.persistence.dao.MainScheduleDao
import com.fmaldonado.siase.data.persistence.dao.TodayScheduleDao
import com.fmaldonado.siase.data.persistence.mappers.MainScheduleClassToEntityMapper
import com.fmaldonado.siase.data.persistence.mappers.TodayClassesToEntityMapper
import com.fmaldonado.siase.data.services.NotificationsService
import com.fmaldonado.siase.ui.utils.parseTime
import java.time.LocalTime
import java.time.temporal.ChronoUnit
import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ScheduleRepository
@Inject
constructor(
    private val networkDataSource: NetworkDataSource,
    private val mainCareerDao: MainCareerDao,
    private val authRepository: AuthRepository,
    private val mainScheduleDao: MainScheduleDao,
    private val todayScheduleDao: TodayScheduleDao,
    private val mainScheduleClassesDao: MainScheduleClassesDao,
    private val notificationsService: NotificationsService
) {

    private var todaySchedule: List<ClassDetail>? = null
    private var fullSchedule: ScheduleDetail? = null
    private var dayOfWeek: Int? = null

    suspend fun getSchedules(index: Int): List<Schedule> {
        return networkDataSource.getSchedules(index)
    }

    fun getFullSchedule() = fullSchedule

    suspend fun getSchedules(career: Careers): List<Schedule> {
        val index = authRepository.signedInUser!!.carreras.indexOfFirst {
            it.claveCarrera == career.claveCarrera &&
                    it.claveDependencia == career.claveDependencia
        }

        return networkDataSource.getSchedules(index)
    }

    suspend fun getScheduleDetail(career: Careers, periodo: String): ScheduleDetail {
        val index = authRepository.signedInUser!!.carreras.indexOfFirst {
            it.claveCarrera == career.claveCarrera &&
                    it.claveDependencia == career.claveDependencia
        }

        return networkDataSource.getScheduleDetail(index, periodo)
    }

    fun resetSchedule() {
        todaySchedule = null
        fullSchedule = null
        dayOfWeek = null
    }


    private fun requiresFetch(): Boolean {
        val today = Calendar.getInstance().get(Calendar.DAY_OF_WEEK)
        if (today != dayOfWeek) return true

        if (dayOfWeek == null) return true

        if (dayOfWeek == 7) return false

        return false
    }

    suspend fun getTodaySchedule(): List<ClassDetail>? {
        if (!requiresFetch()) return todaySchedule

        dayOfWeek = Calendar.getInstance().get(Calendar.DAY_OF_WEEK)

        fullSchedule = MainScheduleClassToEntityMapper
            .classesToScheduleDetail(mainScheduleClassesDao.getClasses())

        todaySchedule = when (dayOfWeek) {
            2 -> fullSchedule!!.getFormattedDetail(fullSchedule!!.lunes)
            3 -> fullSchedule!!.getFormattedDetail(fullSchedule!!.martes)
            4 -> fullSchedule!!.getFormattedDetail(fullSchedule!!.miercoles)
            5 -> fullSchedule!!.getFormattedDetail(fullSchedule!!.jueves)
            6 -> fullSchedule!!.getFormattedDetail(fullSchedule!!.viernes)
            7 -> fullSchedule!!.getFormattedDetail(fullSchedule!!.sabado)
            else -> null
        }

        todayScheduleDao.deleteTodaySchedule()

        todaySchedule?.let {
            todayScheduleDao.insertClasses(it.map { detail ->
                TodayClassesToEntityMapper.classToEntityMapper(detail)
            })
        }

        return todaySchedule
    }

    fun getNextClass(schedule: List<ClassDetail>): ClassDetail? {

        if (schedule.isEmpty()) return null

        val now = LocalTime.now()

        for (classDetail in schedule) {
            val startTime = parseTime(classDetail.horaInicio)
            val difference = ChronoUnit.MINUTES.between(now, startTime)

            if (difference > 0)
                return classDetail
        }

        return null

    }

}