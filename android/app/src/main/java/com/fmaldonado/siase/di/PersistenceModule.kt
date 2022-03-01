package com.fmaldonado.siase.di

import androidx.room.Room
import com.fmaldonado.siase.data.persistence.Database
import com.fmaldonado.siase.data.persistence.dao.*
import com.fmaldonado.siase.ui.SiaseApplication
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton


@Module
@InstallIn(SingletonComponent::class)
object PersistenceModule {

    @Singleton
    @Provides
    fun provideDatabase(app: SiaseApplication): Database =
        Room.databaseBuilder(
            app,
            Database::class.java,
            Database.DATABASE_NAME
        ).fallbackToDestructiveMigration().build()

    @Singleton
    @Provides
    fun provideMainCareerDao(db: Database): MainCareerDao = db.mainCareerDao()

    @Singleton
    @Provides
    fun provideMainScheduleDao(db: Database): MainScheduleDao = db.mainScheduleDao()

    @Singleton
    @Provides
    fun provideTodayScheduleDao(db: Database): TodayScheduleDao = db.todaySchedule()

    @Singleton
    @Provides
    fun provideMainScheduleClassesDao(db: Database): MainScheduleClassesDao = db.mainScheduleClassesDao()

    @Singleton
    @Provides
    fun provideNotificationsDao(db: Database): NotificationsDao = db.notificationsDao()

}
