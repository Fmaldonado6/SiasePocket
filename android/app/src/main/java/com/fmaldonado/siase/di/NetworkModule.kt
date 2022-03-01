package com.fmaldonado.siase.di

import com.fmaldonado.siase.BuildConfig
import com.fmaldonado.siase.data.network.NetworkDataSource
import com.fmaldonado.siase.data.network.NetworkInterceptor
import com.fmaldonado.siase.data.preferences.PreferencesService
import com.fmaldonado.siase.data.repositories.AuthRepository
import com.fmaldonado.siase.ui.SiaseApplication
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {

    @Provides
    @Singleton
    fun provideSiaseDataSource(networkInterceptor: NetworkInterceptor): NetworkDataSource {
        val okHttpClient =
            OkHttpClient.Builder()
                .addInterceptor(networkInterceptor)
                .build()

        return Retrofit.Builder()
            .baseUrl(BuildConfig.BASE_URL)
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(NetworkDataSource::class.java)
    }

    @Singleton
    @Provides
    fun providePreferences(siaseApplication: SiaseApplication) =
        PreferencesService(siaseApplication)


    @Singleton
    @Provides
    fun provideNetworkInterceptor(
        preferencesService: PreferencesService
    ): NetworkInterceptor =
        NetworkInterceptor(preferencesService)

}