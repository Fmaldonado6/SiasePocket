package com.fmaldonado.siase.data.persistence.mappers

import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.models.ScheduleDetail
import com.fmaldonado.siase.data.persistence.entities.MainScheduleClassesEntity

object MainScheduleClassToEntityMapper {

    fun scheduleClassToEntity(
        classDetail: ClassDetail,
        weekDay: Int
    ): MainScheduleClassesEntity {

        return MainScheduleClassesEntity(
            id = 0,
            tipo = classDetail.tipo,
            salon = classDetail.salon,
            oportunidad = classDetail.oportunidad,
            nombreCorto = classDetail.nombreCorto,
            modalidad = classDetail.modalidad,
            horaInicio = classDetail.horaInicio,
            horaFin = classDetail.horaFin,
            grupo = classDetail.grupo,
            fase = classDetail.fase,
            claveMateria = classDetail.claveMateria,
            nombre = classDetail.nombre,
            weekDay = weekDay
        )

    }

    fun classesToScheduleDetail(classes: List<MainScheduleClassesEntity>): ScheduleDetail {
        val detail = ScheduleDetail(
            lunes = mutableListOf(),
            martes = mutableListOf(),
            miercoles = mutableListOf(),
            jueves = mutableListOf(),
            viernes = mutableListOf(),
            sabado = mutableListOf()
        )

        for (classDetailEntity in classes) {

            val classDetail = ClassDetail(
                tipo = classDetailEntity.tipo,
                salon = classDetailEntity.salon,
                oportunidad = classDetailEntity.oportunidad,
                nombreCorto = classDetailEntity.nombreCorto,
                modalidad = classDetailEntity.modalidad,
                horaInicio = classDetailEntity.horaInicio,
                horaFin = classDetailEntity.horaFin,
                grupo = classDetailEntity.grupo,
                fase = classDetailEntity.fase,
                claveMateria = classDetailEntity.claveMateria,
                nombre = classDetailEntity.nombre,
            )

            when (classDetailEntity.weekDay) {
                2 -> detail.lunes.add(classDetail)
                3 -> detail.martes.add(classDetail)
                4 -> detail.miercoles.add(classDetail)
                5 -> detail.jueves.add(classDetail)
                6 -> detail.viernes.add(classDetail)
                7 -> detail.sabado.add(classDetail)
            }
        }

        return detail

    }

}