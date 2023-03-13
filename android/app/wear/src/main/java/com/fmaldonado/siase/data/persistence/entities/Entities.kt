package com.fmaldonado.siase.data.persistence.entities

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import org.jetbrains.annotations.NotNull

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