//
//  MainScheduleClassesDao.swift
//  siase
//
//  Created by Fernando Maldonado on 28/02/22.
//

import Foundation
import CoreData

class MainScheduleClassesDao{
    private let container:NSPersistentContainer
    
    init(
        container:NSPersistentContainer =
        DIContainer.shared.resolve(type: NSPersistentContainer.self)!
    ){
        self.container = container
    }
    
    func insertClasses(classes:[ClassDetail],weekDay:Int) throws {
        for classDetail in classes{
            var newClass = MainScheduleClasses(context: container.viewContext)
            
            newClass.weekDay = Int64(weekDay)
            newClass.oportunidad = classDetail.oportunidad
            newClass.modalidad = classDetail.modalidad
            newClass.claveMateria = classDetail.claveMateria
            newClass.horaFin = classDetail.horaFin
            newClass.horaInicio = classDetail.horaInicio
            newClass.salon = classDetail.salon
            newClass.grupo = classDetail.grupo
            newClass.tipo = classDetail.tipo
            newClass.fase = classDetail.fase
            newClass.nombre = classDetail.nombre
            newClass.nombreCorto = classDetail.nombreCorto
            
            try container.viewContext.save()
        }
    }
    
    
    func getClasses() throws -> ScheduleDetail{
        let classes = try container.viewContext.fetch(MainScheduleClasses.fetchRequest())
        
        var detail = ScheduleDetail()
        
        for classDetail in classes{
            let newClass = ClassDetail(
                nombre: classDetail.nombre,
                nombreCorto: classDetail.nombreCorto,
                fase: classDetail.fase,
                tipo: classDetail.tipo,
                grupo: classDetail.grupo,
                salon: classDetail.salon,
                horaInicio: classDetail.horaInicio,
                horaFin: classDetail.horaFin,
                claveMateria: classDetail.claveMateria,
                modalidad: classDetail.modalidad,
                oportunidad: classDetail.oportunidad
            )
            
            switch(classDetail.weekDay){
            case 2 :
                detail.lunes.append(newClass)
            case 3 :
                detail.martes.append(newClass)
            case 4 :
                detail.miercoles.append(newClass)
            case 5 :
                detail.jueves.append(newClass)
            case 6 :
                detail.viernes.append(newClass)
            case 7 :
                detail.sabado.append(newClass)
            default:
                print("Not implemented")
            }
        }
        
        return detail
    }
    
    func deleteClasses() throws {
        let request = MainScheduleClasses.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try container.viewContext.execute(deleteRequest)
        
    }
    
}
