package com.fmaldonado.siase.data.persistence.entities

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import org.jetbrains.annotations.NotNull
import org.jetbrains.annotations.Nullable

@Entity(tableName = "mainCareer")
data class MainCareerEntity(
    @PrimaryKey(autoGenerate = false)
    @NotNull
    @ColumnInfo(name = "id")
    val id: Int = 0,
    @NotNull
    @ColumnInfo(name = "nombre")
    val nombre: String,
    @NotNull
    @ColumnInfo(name = "claveDependencia")
    val claveDependencia: String,
    @NotNull
    @ColumnInfo(name = "claveUnidad")
    val claveUnidad: String,
    @NotNull
    @ColumnInfo(name = "claveNivelAcademico")
    val claveNivelAcademico: String,
    @NotNull
    @ColumnInfo(name = "claveGradoAcademico")
    val claveGradoAcademico: String,
    @NotNull
    @ColumnInfo(name = "claveModalidad")
    val claveModalidad: String,
    @NotNull
    @ColumnInfo(name = "clavePlanEstudios")
    val clavePlanEstudios: String,
    @NotNull
    @ColumnInfo(name = "claveCarrera")
    val claveCarrera: String,
)

@Entity(tableName = "mainSchedule")
data class MainScheduleEntity(
    @PrimaryKey(autoGenerate = false)
    @NotNull
    @ColumnInfo(name = "id")
    val id: Int = 0,
    @NotNull
    @ColumnInfo(name = "nombre")
    val nombre: String,
    @NotNull
    @ColumnInfo(name = "claveDependencia")
    val claveDependencia: String,
    @NotNull
    @ColumnInfo(name = "claveUnidad")
    val claveUnidad: String,
    @NotNull
    @ColumnInfo(name = "claveNivelAcademico")
    val claveNivelAcademico: String,
    @NotNull
    @ColumnInfo(name = "claveGradoAcademico")
    val claveGradoAcademico: String,
    @NotNull
    @ColumnInfo(name = "claveModalidad")
    val claveModalidad: String,
    @NotNull
    @ColumnInfo(name = "clavePlanEstudios")
    val clavePlanEstudios: String,
    @NotNull
    @ColumnInfo(name = "claveCarrera")
    val claveCarrera: String,
    @NotNull
    @ColumnInfo(name = "periodo")
    val periodo: String,
)

@Entity(tableName = "todaySchedule")
data class TodayClassesEntity(
    @PrimaryKey(autoGenerate = true)
    @NotNull
    @ColumnInfo(name = "id")
    val id: Int = 0,
    @NotNull
    @ColumnInfo(name = "nombre")
    val nombre: String,
    @NotNull
    @ColumnInfo(name = "nombreCorto")
    val nombreCorto: String,
    @NotNull
    @ColumnInfo(name = "fase")
    val fase: String,
    @NotNull
    @ColumnInfo(name = "tipo")
    val tipo: String,
    @NotNull
    @ColumnInfo(name = "grupo")
    val grupo: String,
    @NotNull
    @ColumnInfo(name = "salon")
    val salon: String,
    @NotNull
    @ColumnInfo(name = "horaInicio")
    var horaInicio: String,
    @NotNull
    @ColumnInfo(name = "horaFin")
    var horaFin: String,
    @NotNull
    @ColumnInfo(name = "claveMateria")
    val claveMateria: String,
    @NotNull
    @ColumnInfo(name = "modalidad")
    val modalidad: String,
    @NotNull
    @ColumnInfo(name = "oportunidad")
    val oportunidad: String,
)

@Entity(tableName = "notifications")
data class NotificationsEntity(
    @PrimaryKey(autoGenerate = true)
    @NotNull
    @ColumnInfo(name = "id")
    val id:Int = 0,
    @NotNull
    @ColumnInfo(name = "title")
    val title:String,
    @NotNull
    @ColumnInfo(name = "description")
    val description:String,
    @NotNull
    @ColumnInfo(name = "time")
    val time:Long
)

@Entity(tableName = "mainScheduleClasses")
data class MainScheduleClassesEntity(
    @PrimaryKey(autoGenerate = true)
    @NotNull
    @ColumnInfo(name = "id")
    val id: Int = 0,
    @Nullable
    @ColumnInfo(name = "notificationId")
    var notificationId: Int? = 0,
    @NotNull
    @ColumnInfo(name = "weekDay")
    val weekDay: Int = 0,
    @NotNull
    @ColumnInfo(name = "nombre")
    val nombre: String,
    @NotNull
    @ColumnInfo(name = "nombreCorto")
    val nombreCorto: String,
    @NotNull
    @ColumnInfo(name = "fase")
    val fase: String,
    @NotNull
    @ColumnInfo(name = "tipo")
    val tipo: String,
    @NotNull
    @ColumnInfo(name = "grupo")
    val grupo: String,
    @NotNull
    @ColumnInfo(name = "salon")
    val salon: String,
    @NotNull
    @ColumnInfo(name = "horaInicio")
    var horaInicio: String,
    @NotNull
    @ColumnInfo(name = "horaFin")
    var horaFin: String,
    @NotNull
    @ColumnInfo(name = "claveMateria")
    val claveMateria: String,
    @NotNull
    @ColumnInfo(name = "modalidad")
    val modalidad: String,
    @NotNull
    @ColumnInfo(name = "oportunidad")
    val oportunidad: String,
)