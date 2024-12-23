package com.fmaldonado.siase.data.network

import com.fmaldonado.siase.data.models.*
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.POST
import retrofit2.http.Path

interface NetworkDataSource {


    companion object {
        const val EnableCache = ""
        const val DisableCache = "no-cache"

    }

    @POST("user")
    suspend fun signIn(@Body signInRequest: SignInRequest): SignInResponse

    @GET("schedules/{index}")
    suspend fun getSchedules(@Path("index") index: Int): List<Schedule>

    @GET("kardex/{index}")
    suspend fun getKardex(
        @Path("index") index: Int,
        @Header("Cache-Control") cache: String = EnableCache,
    ): Kardex

    @GET("schedules/{index}/{periodo}")
    suspend fun getScheduleDetail(
        @Path("index") index: Int,
        @Path("periodo") periodo: String,
    ): ScheduleDetail

    @GET("afis/{index}/{month}")
    suspend fun getAfis(
        @Path("index") index: Int,
        @Path("month") month: Int,
        @Header("Cache-Control") cache: String = EnableCache,
    ): MutableList<Afi>

    @GET("schedules/{index}/history")
    suspend fun getAfisHistory(
        @Path("index") index: Int,
        @Header("Cache-Control") cache: String = EnableCache,
    ): AfiHistorial
}