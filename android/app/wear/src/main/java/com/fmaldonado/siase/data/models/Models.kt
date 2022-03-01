package com.fmaldonado.siase.data.models

import android.os.Parcelable
import kotlinx.parcelize.Parcelize

data class SignInRequest(
val user: String,
val password: String
)

data class Preferences(
    var user: String? = null,
    var password: String? = null,
    var session: SignInResponse? = null
)

enum class PreferencesKeys {
    User,
    Password,
    Session
}

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
    val semestre: Int,
    val claveMateria: String,
    val nombre: String,
    val calificaciones: List<Float>
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
    val lunes: List<ClassDetail>,
    val martes: List<ClassDetail>,
    val miercoles: List<ClassDetail>,
    val jueves: List<ClassDetail>,
    val viernes: List<ClassDetail>,
    val sabado: List<ClassDetail>,
) : Parcelable {

    fun getFormattedDetail(detail: List<ClassDetail>): List<ClassDetail> {

        if (detail.isEmpty()) return mutableListOf()

        val newDetail = mutableListOf<ClassDetail>()

        var currentSubject = detail.first()

        for (classDetail in detail) {
            if (classDetail.claveMateria != currentSubject.claveMateria) {
                newDetail.add(currentSubject)
            } else {
                classDetail.horaInicio = currentSubject.horaInicio
                currentSubject.horaFin = classDetail.horaFin
            }
            currentSubject = classDetail
        }

        newDetail.add(currentSubject)
        return newDetail
    }


}

@Parcelize
data class ClassDetail(
    val nombre: String,
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
) : Parcelable

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