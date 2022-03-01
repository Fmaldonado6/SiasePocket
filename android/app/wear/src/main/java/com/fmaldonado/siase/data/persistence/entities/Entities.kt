package com.fmaldonado.siase.data.persistence.entities

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import org.jetbrains.annotations.NotNull

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