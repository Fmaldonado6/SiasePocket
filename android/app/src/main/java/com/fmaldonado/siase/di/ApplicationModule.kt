package com.fmaldonado.siase.di

import android.content.Context
import com.fmaldonado.siase.ui.SiaseApplication
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object ApplicationModule {
    @Singleton
    @Provides
    fun provideApplication(@ApplicationContext app: Context): SiaseApplication =
        app as SiaseApplication
}