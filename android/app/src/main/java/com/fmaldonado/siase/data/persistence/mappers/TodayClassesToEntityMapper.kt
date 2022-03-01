package com.fmaldonado.siase.data.persistence.mappers

import com.fmaldonado.siase.data.models.ClassDetail
import com.fmaldonado.siase.data.persistence.entities.TodayClassesEntity

object TodayClassesToEntityMapper {

    fun classToEntityMapper(todayClass: ClassDetail): TodayClassesEntity {
        return TodayClassesEntity(
            nombre = todayClass.nombre,
            claveMateria = todayClass.claveMateria,
            fase = todayClass.fase,
            grupo = todayClass.grupo,
            horaFin = todayClass.horaFin,
            horaInicio = todayClass.horaInicio,
            modalidad = todayClass.modalidad,
            nombreCorto = todayClass.nombreCorto,
            oportunidad = todayClass.oportunidad,
            salon = todayClass.salon,
            tipo = todayClass.tipo
        )
    }

    fun entityToClassMapper(todayClass: TodayClassesEntity): ClassDetail {
        return ClassDetail(
            nombre = todayClass.nombre,
            claveMateria = todayClass.claveMateria,
            fase = todayClass.fase,
            grupo = todayClass.grupo,
            horaFin = todayClass.horaFin,
            horaInicio = todayClass.horaInicio,
            modalidad = todayClass.modalidad,
            nombreCorto = todayClass.nombreCorto,
            oportunidad = todayClass.oportunidad,
            salon = todayClass.salon,
            tipo = todayClass.tipo
        )
    }

}