package com.fmaldonado.siase.data.persistence.entities

import androidx.room.*
@Entity(tableName = "mainCareer")
data class MainCareerEntity(
    @PrimaryKey(autoGenerate = false)
    @ColumnInfo(name = "id")
    val id: Int = 0,
    @ColumnInfo(name = "nombre")
    val nombre: String,
    @ColumnInfo(name = "claveDependencia")
    val claveDependencia: String,
    @ColumnInfo(name = "claveUnidad")
    val claveUnidad: String,
    @ColumnInfo(name = "claveNivelAcademico")
    val claveNivelAcademico: String,
    @ColumnInfo(name = "claveGradoAcademico")
    val claveGradoAcademico: String,
    @ColumnInfo(name = "claveModalidad")
    val claveModalidad: String,
    @ColumnInfo(name = "clavePlanEstudios")
    val clavePlanEstudios: String,
    @ColumnInfo(name = "claveCarrera")
    val claveCarrera: String,
)

@Entity(tableName = "mainSchedule")
data class MainScheduleEntity(
    @PrimaryKey(autoGenerate = false)
    @ColumnInfo(name = "id")
    val id: Int = 0,
    @ColumnInfo(name = "nombre")
    val nombre: String,
    @ColumnInfo(name = "claveDependencia")
    val claveDependencia: String,
    @ColumnInfo(name = "claveUnidad")
    val claveUnidad: String,
    @ColumnInfo(name = "claveNivelAcademico")
    val claveNivelAcademico: String,
    @ColumnInfo(name = "claveGradoAcademico")
    val claveGradoAcademico: String,
    @ColumnInfo(name = "claveModalidad")
    val claveModalidad: String,
    @ColumnInfo(name = "clavePlanEstudios")
    val clavePlanEstudios: String,
    @ColumnInfo(name = "claveCarrera")
    val claveCarrera: String,
    @ColumnInfo(name = "periodo")
    val periodo: String,
)

@Entity(tableName = "todaySchedule")
data class TodayClassesEntity(
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    val id: Int = 0,
    @ColumnInfo(name = "nombre")
    val nombre: String,
    @ColumnInfo(name = "nombreCorto")
    val nombreCorto: String,
    @ColumnInfo(name = "fase")
    val fase: String,
    @ColumnInfo(name = "tipo")
    val tipo: String,
    @ColumnInfo(name = "grupo")
    val grupo: String,
    @ColumnInfo(name = "salon")
    val salon: String,
    @ColumnInfo(name = "horaInicio")
    var horaInicio: String,
    @ColumnInfo(name = "horaFin")
    var horaFin: String,
    @ColumnInfo(name = "claveMateria")
    val claveMateria: String,
    @ColumnInfo(name = "modalidad")
    val modalidad: String,
    @ColumnInfo(name = "oportunidad")
    val oportunidad: String,
)

@Entity(
    tableName = "notifications",

)
data class NotificationsEntity(
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    val id:Int = 0,
    @ColumnInfo(name = "title")
    val title:String,
    @ColumnInfo(name = "description")
    val description:String,
    @ColumnInfo(name = "time")
    val time:Long,
    @ColumnInfo(name = "claveMateria")
    val claveMateria: String
)

@Entity(
    tableName = "mainScheduleClasses",
    indices = [Index(value = ["claveMateria"])]
    )
data class MainScheduleClassesEntity(
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo(name = "id")
    val id: Int = 0,
    @ColumnInfo(name = "notificationId")
    var notificationId: Int? = 0,
    @ColumnInfo(name = "weekDay")
    val weekDay: Int = 0,
    @ColumnInfo(name = "nombre")
    val nombre: String,
    @ColumnInfo(name = "nombreCorto")
    val nombreCorto: String,
    @ColumnInfo(name = "fase")
    val fase: String,
    @ColumnInfo(name = "tipo")
    val tipo: String,
    @ColumnInfo(name = "grupo")
    val grupo: String,
    @ColumnInfo(name = "salon")
    val salon: String,
    @ColumnInfo(name = "horaInicio")
    var horaInicio: String,
    @ColumnInfo(name = "horaFin")
    var horaFin: String,
    @ColumnInfo(name = "claveMateria")
    val claveMateria: String,
    @ColumnInfo(name = "modalidad")
    val modalidad: String,
    @ColumnInfo(name = "oportunidad")
    val oportunidad: String,
)