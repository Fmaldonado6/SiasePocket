package com.fmaldonado.siase.data.persistence.mappers

import com.fmaldonado.siase.data.models.Careers
import com.fmaldonado.siase.data.persistence.entities.MainCareerEntity

object CareerToEntityMapper {

    fun careerToEntity(career: Careers): MainCareerEntity {
        return MainCareerEntity(
            nombre = career.nombre,
            claveCarrera = career.claveCarrera,
            claveDependencia = career.claveDependencia,
            claveGradoAcademico = career.claveGradoAcademico,
            claveModalidad = career.claveModalidad,
            claveNivelAcademico = career.claveNivelAcademico,
            clavePlanEstudios = career.clavePlanEstudios,
            claveUnidad = career.claveUnidad,
        )
    }

    fun entityToCareer(careerEntity: MainCareerEntity): Careers {
        return Careers(
            nombre = careerEntity.nombre,
            claveCarrera = careerEntity.claveCarrera,
            claveDependencia = careerEntity.claveDependencia,
            claveGradoAcademico = careerEntity.claveGradoAcademico,
            claveModalidad = careerEntity.claveModalidad,
            claveNivelAcademico = careerEntity.claveNivelAcademico,
            clavePlanEstudios = careerEntity.clavePlanEstudios,
            claveUnidad = careerEntity.claveUnidad,
        )
    }

}