package com.fmaldonado.siase.data.network

import android.util.Log
import com.fmaldonado.siase.data.preferences.PreferencesService
import com.fmaldonado.siase.data.repositories.AuthRepository
import okhttp3.Interceptor
import okhttp3.Response
import javax.inject.Inject

class NetworkInterceptor(private val preferencesService: PreferencesService) : Interceptor {


    override fun intercept(chain: Interceptor.Chain): Response {
        var request = chain.request()
        preferencesService.getToken()?.let {
            request = request.newBuilder()
                .addHeader("Authorization", "Bearer $it")
                .build()


        }

        val response = chain.proceed(request)

        if (response.isSuccessful)
            return response
        if (response.code() == 400)
            throw BadInput(response.message())
        if (response.code() == 404)
            throw NotFoundError(response.message())
        if (response.code() == 501 || response.code() == 401)
            throw Unauthorized(response.message())

        throw  AppError(response.message())


    }
}