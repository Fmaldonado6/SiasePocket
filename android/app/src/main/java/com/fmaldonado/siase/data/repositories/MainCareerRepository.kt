package com.fmaldonado.siase.data.repositories

import com.fmaldonado.siase.R
import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.models.Notifications
import com.fmaldonado.siase.data.models.Schedule
import com.fmaldonado.siase.data.network.NetworkDataSource
import com.fmaldonado.siase.data.persistence.dao.MainCareerDao
import com.fmaldonado.siase.data.persistence.dao.MainScheduleClassesDao
import com.fmaldonado.siase.data.persistence.dao.MainScheduleDao
import com.fmaldonado.siase.data.persistence.dao.NotificationsDao
import com.fmaldonado.siase.data.persistence.entities.MainScheduleClassesEntity
import com.fmaldonado.siase.data.persistence.entities.NotificationsEntity
import com.fmaldonado.siase.data.persistence.mappers.CareerToEntityMapper
import com.fmaldonado.siase.data.persistence.mappers.MainScheduleClassToEntityMapper
import com.fmaldonado.siase.data.persistence.mappers.ScheduleToEntityMapper
import com.fmaldonado.siase.data.preferences.PreferencesService
import com.fmaldonado.siase.data.services.NotificationsService
import com.fmaldonado.siase.ui.SiaseApplication
import com.fmaldonado.siase.ui.utils.parseTime
import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class MainCareerRepository
@Inject
constructor(
    private val mainScheduleDao: MainScheduleDao,
    private val mainCareerDao: MainCareerDao,
    private val notificationsDao: NotificationsDao,
    private val networkDataSource: NetworkDataSource,
    private val mainScheduleClassesDao: MainScheduleClassesDao,
    private val authRepository: AuthRepository,
    private val preferencesService: PreferencesService,
    private val notificationsService: NotificationsService,
    private val application: SiaseApplication
) {

    suspend fun selectMainCareer(careers: Careers) {
        val entity = CareerToEntityMapper.careerToEntity(careers)
        mainCareerDao.addMainCareer(entity)
    }

    suspend fun selectMainSchedule(schedule: Schedule) {
        val entity = ScheduleToEntityMapper.scheduleToEntity(schedule)
        mainScheduleDao.addMainSchedule(entity)

        val mainCareer = mainCareerDao.getMainCareer() ?: return

        val index = authRepository.signedInUser!!.carreras.indexOfFirst {
            it.claveCarrera == mainCareer.claveCarrera &&
                    it.claveDependencia == mainCareer.claveDependencia
        }

        val detail = networkDataSource.getScheduleDetail(index, schedule.periodo)

        val classList = mutableListOf<MainScheduleClassesEntity>()

        classList.addAll(detail.getFormattedDetail(detail.lunes).map {
            MainScheduleClassToEntityMapper.scheduleClassToEntity(it, 2)
        })
        classList.addAll(detail.getFormattedDetail(detail.martes).map {
            MainScheduleClassToEntityMapper.scheduleClassToEntity(it, 3)
        })
        classList.addAll(detail.getFormattedDetail(detail.miercoles).map {
            MainScheduleClassToEntityMapper.scheduleClassToEntity(it, 4)
        })
        classList.addAll(detail.getFormattedDetail(detail.jueves).map {
            MainScheduleClassToEntityMapper.scheduleClassToEntity(it, 5)
        })
        classList.addAll(detail.getFormattedDetail(detail.viernes).map {
            MainScheduleClassToEntityMapper.scheduleClassToEntity(it, 6)
        })
        classList.addAll(detail.getFormattedDetail(detail.sabado).map {
            MainScheduleClassToEntityMapper.scheduleClassToEntity(it, 7)
        })
        mainScheduleClassesDao.deleteClasses()
        mainScheduleClassesDao.insertClasses(classList)

        val preferences = preferencesService.getPreferences()

        if (!preferences.notifications) return

        val oldNotifications = notificationsDao.getNotifications()
        for (oldNotification in oldNotifications) {
            notificationsService.deleteNotification(oldNotification)
        }
        notificationsDao.deleteNotifications()

        val notificationSize = (classList.size * 2) - 1
        for (i in 0..notificationSize) {

            val secondLoop = i > classList.size - 1
            val realIndex = if (secondLoop) i - classList.size else i
            val classDetail = classList[realIndex]

            val description =
                if (!secondLoop)
                    application.getString(
                        R.string.notificationDescription,
                        classDetail.nombre
                    ) else
                    application.getString(
                        R.string.notificationDescriptionFifteenMin,
                        classDetail.nombre
                    )

            var time = parseTime(classDetail.horaInicio)

            if (secondLoop)
                time = time.minusMinutes(15)

            val calendar = Calendar.getInstance()

            calendar.set(
                Calendar.HOUR_OF_DAY,
                time.hour
            )

            calendar.set(
                Calendar.MINUTE,
                time.minute
            )

            calendar.set(
                Calendar.DAY_OF_WEEK,
                classDetail.weekDay
            )

            val notification = NotificationsEntity(
                id = i,
                title = application.getString(R.string.notificationTitle),
                description = description,
                time = calendar.timeInMillis,
            )

            notificationsDao.insertNotification(notification)
            notificationsService.scheduleNotification(notification)
        }

    }

    private suspend fun disableNotifications() {
        val oldNotifications = notificationsDao.getNotifications()
        for (oldNotification in oldNotifications) {
            notificationsService.deleteNotification(oldNotification)
        }
    }

    suspend fun enableNotifications() {
        val preferences = preferencesService.getPreferences()
        if (!preferences.notifications) return

        val notifications = notificationsDao.getNotifications()
        for (notification in notifications) {
            notificationsService.scheduleNotification(notification)
        }
    }

    fun getNotificationsPreferences(): Boolean {
        val preferences = preferencesService.getPreferences()
        return preferences.notifications
    }

    suspend fun setNotificationsPreferences(enabled: Boolean) {
        val preferences = preferencesService.getPreferences()
        preferences.notifications = enabled
        preferencesService.save(preferences)

        if (preferences.notifications)
            enableNotifications()
        else
            disableNotifications()
    }

    suspend fun getMainCareer() = mainCareerDao.getMainCareer()?.let {
        CareerToEntityMapper.entityToCareer(it)
    }

    suspend fun getMainSchedule() = mainScheduleDao.getMainSchedule()?.let {
        ScheduleToEntityMapper.entityToSchedule(it)
    }

}