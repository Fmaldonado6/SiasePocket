package com.fmaldonado.siase.data.persistence.mappers

import com.fmaldonado.siase.data.models.Schedule
import com.fmaldonado.siase.data.persistence.entities.MainScheduleEntity

object ScheduleToEntityMapper {

    fun scheduleToEntity(schedule: Schedule): MainScheduleEntity {
        return MainScheduleEntity(
            nombre = schedule.nombre,
            claveCarrera = schedule.claveCarrera,
            claveDependencia = schedule.claveDependencia,
            claveGradoAcademico = schedule.claveGradoAcademico,
            claveModalidad = schedule.claveModalidad,
            claveNivelAcademico = schedule.claveNivelAcademico,
            clavePlanEstudios = schedule.clavePlanEstudios,
            claveUnidad = schedule.claveUnidad,
            periodo = schedule.periodo
        )
    }

    fun entityToSchedule(mainScheduleEntity: MainScheduleEntity): Schedule {
        return Schedule(
            nombre = mainScheduleEntity.nombre,
            claveCarrera = mainScheduleEntity.claveCarrera,
            claveDependencia = mainScheduleEntity.claveDependencia,
            claveGradoAcademico = mainScheduleEntity.claveGradoAcademico,
            claveModalidad = mainScheduleEntity.claveModalidad,
            claveNivelAcademico = mainScheduleEntity.claveNivelAcademico,
            clavePlanEstudios = mainScheduleEntity.clavePlanEstudios,
            claveUnidad = mainScheduleEntity.claveUnidad,
            periodo = mainScheduleEntity.periodo
        )
    }
}