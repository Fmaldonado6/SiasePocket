package com.fmaldonado.siase.data.network

import com.fmaldonado.siase.data.models.*
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Path

interface NetworkDataSource {

    @POST("user")
    suspend fun signIn(@Body signInRequest: SignInRequest): SignInResponse

    @GET("schedules/{index}")
    suspend fun getSchedules(@Path("index") index: Int): List<Schedule>

    @GET("kardex/{index}")
    suspend fun getKardex(@Path("index") index: Int): Kardex

    @GET("schedules/{index}/{periodo}")
    suspend fun getScheduleDetail(
        @Path("index") index: Int,
        @Path("periodo") periodo: String,
    ): ScheduleDetail
}