package com.fmaldonado.siase.data.models

import android.os.Parcel
import android.os.Parcelable
import android.util.Log
import kotlinx.parcelize.Parcelize

data class SignInRequest(
    val user: String,
    val password: String
)

data class SignInResponse(
    val nombre: String,
    val matricula: String,
    val carreras: List<Careers>,
    val token: String,
    val foto: String
)

@Parcelize
data class Kardex(
    val nombreAlumno: String,
    val carrera: String,
    val planEstudios: String,
    val materias: List<Subject>
) : Parcelable

@Parcelize
data class Subject(
    val semestreMateria: String,
    val claveMateria: String,
    val nombre: String,
    val oportunidades: List<String>
) : Parcelable

@Parcelize
data class Schedule(
    val nombre: String,
    val claveDependencia: String,
    val claveUnidad: String,
    val claveNivelAcademico: String,
    val claveGradoAcademico: String,
    val claveModalidad: String,
    val clavePlanEstudios: String,
    val claveCarrera: String,
    val periodo: String,
) : Parcelable

@Parcelize
data class ScheduleDetail(
    val lunes: MutableList<ClassDetail>,
    val martes: MutableList<ClassDetail>,
    val miercoles: MutableList<ClassDetail>,
    val jueves: MutableList<ClassDetail>,
    val viernes: MutableList<ClassDetail>,
    val sabado: MutableList<ClassDetail>,
) : Parcelable {

    fun getFormattedDetail(detail: List<ClassDetail>): List<ClassDetail> {

        if (detail.isEmpty()) return mutableListOf()

        val newDetail = mutableListOf<ClassDetail>()

        var currentSubject = detail.first()

        for (classDetail in detail) {

            if (classDetail == currentSubject) continue

            if (classDetail.claveMateria == currentSubject.claveMateria
                && currentSubject.horaFin == classDetail.horaInicio

            ) {
                classDetail.horaInicio = currentSubject.horaInicio
                currentSubject.horaFin = classDetail.horaFin
            } else {
                newDetail.add(currentSubject)
            }
            currentSubject = classDetail
        }

        newDetail.add(currentSubject)

        return newDetail
    }


}

@Parcelize
data class ClassDetail(
    var nombre: String,
    val nombreCorto: String,
    val fase: String,
    val tipo: String,
    val grupo: String,
    val salon: String,
    var horaInicio: String,
    var horaFin: String,
    val claveMateria: String,
    val modalidad: String,
    val oportunidad: String,
) : Parcelable {

    fun getNombreCapitalized() = nombre.lowercase().replaceFirstChar { name ->
        name.uppercase()
    }

    fun getModalidadCapitalized() = modalidad.lowercase().replaceFirstChar {
        it.uppercase()
    }
}

@Parcelize
data class Careers(
    val nombre: String,
    val claveDependencia: String,
    val claveUnidad: String,
    val claveNivelAcademico: String,
    val claveGradoAcademico: String,
    val claveModalidad: String,
    val clavePlanEstudios: String,
    val claveCarrera: String,
) : Parcelable


@Parcelize
data class AfiHistorial(
    val completadas: Int,
    val total: Int,
    val afis: MutableList<AfiRegistrada>
) : Parcelable


@Parcelize
data class AfiRegistrada(
    val area: String,
    val evento: String,
    val idEvento: String,
    val indicaciones: String,
    val recinto: String,
    val sede: String,
    val direccion: String,
    val municipio: String,
    val estado: String,
    val pais: String,
    val organizador: String,
    val fechaInicio: String,
    val horaInicio: String,
    val asistencia: Boolean,
    val eventoOficial: Boolean,
    val numEventoOficial: Int,
    val periodoEscolar: String,
) : Parcelable

@Parcelize
data class Afi(
    val registrado: Boolean,
    val organizador: String,
    val area: String,
    val evento: String,
    val descripcion: String,
    val fechaInicio: String,
    val horaInicio: String,
    val fechaFin: String,
    val horaFin: String,
    val capacidad: Int,
    val alumnosRegistrados: Int,
    val disponibles: Int,
) : Parcelable