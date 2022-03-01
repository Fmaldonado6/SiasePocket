package com.fmaldonado.siase.di

import androidx.room.Room
import com.fmaldonado.siase.SiaseWearApplication
import com.fmaldonado.siase.data.persistence.Database
import com.fmaldonado.siase.data.persistence.dao.TodayScheduleDao
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
    fun provideDatabase(app: SiaseWearApplication): Database =
        Room.databaseBuilder(
            app,
            Database::class.java,
            Database.DATABASE_NAME
        ).fallbackToDestructiveMigration().build()

    @Singleton
    @Provides
    fun provideTodayScheduleDao(db: Database): TodayScheduleDao = db.todayScheduleDao()


}
