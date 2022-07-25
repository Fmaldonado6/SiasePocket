//
//  MainScheduleDao.swift
//  siase
//
//  Created by Fernando Maldonado on 28/02/22.
//

import Foundation
import CoreData

class MainScheduleDao{
    private let container:NSPersistentContainer
    
    init(
        container:NSPersistentContainer =
        DIContainer.shared.resolve(type: NSPersistentContainer.self)!
    ){
        self.container = container
    }
    
    func getMainSchedule() throws -> Schedule? {
        let schedule = try container.viewContext.fetch(MainSchedule.fetchRequest()).first as MainSchedule?
        
        if(schedule == nil) {
            return nil
        }
        
        return Schedule(
            nombre: schedule?.nombre,
            claveDependencia: schedule?.claveDependencia,
            claveUnidad: schedule?.claveUnidad,
            claveNivelAcademico: schedule?.claveNivelAcademico,
            claveGradoAcademico: schedule?.claveGradoAcademico,
            claveModalidad: schedule?.claveModalidad,
            clavePlanEstudios: schedule?.clavePlanEstudios,
            claveCarrera: schedule?.claveCarrera,
            periodo: schedule?.periodo
        )
     
    }
    
    
    
    func addMainSchedule(schedule:Schedule) throws {
        let schedules = try container.viewContext.fetch(MainSchedule.fetchRequest()) as [MainSchedule]
        var mainSchedule = schedules.first
        
        if(schedules.isEmpty){
            mainSchedule = MainSchedule(context: self.container.viewContext)
        }
        
        mainSchedule!.nombre = schedule.nombre
        mainSchedule!.claveCarrera = schedule.claveCarrera
        mainSchedule!.claveDependencia = schedule.claveDependencia
        mainSchedule!.claveGradoAcademico = schedule.claveGradoAcademico
        mainSchedule!.claveModalidad = schedule.claveModalidad
        mainSchedule!.claveNivelAcademico = schedule.claveNivelAcademico
        mainSchedule!.clavePlanEstudios = schedule.clavePlanEstudios
        mainSchedule!.claveUnidad = schedule.claveUnidad
        mainSchedule!.periodo = schedule.periodo
        
        try container.viewContext.save()

    }
    
    func deleteMainCareer() throws {
        let request = MainSchedule.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try container.viewContext.execute(deleteRequest)
        
    }
}
