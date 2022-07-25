//
//  MainCareerDao.swift
//  siase
//
//  Created by Fernando Maldonado on 28/02/22.
//

import Foundation
import CoreData


class MainCareerDao{
    
    private let container:NSPersistentContainer
    
    init(
        container:NSPersistentContainer =
        DIContainer.shared.resolve(type: NSPersistentContainer.self)!
    ){
        self.container = container
    }
    
    func getMainCareer() throws -> Career? {
        let career = try container.viewContext.fetch(MainCareer.fetchRequest()).first as MainCareer?
        
        if(career == nil) {
            return nil
        }
        
        return Career(
            nombre: career?.nombre,
            claveDependencia: career?.claveDependencia,
            claveUnidad: career?.claveUnidad,
            claveNivelAcademico: career?.claveNivelAcademico,
            claveGradoAcademico: career?.claveGradoAcademico,
            claveModalidad: career?.claveModalidad,
            clavePlanEstudios: career?.clavePlanEstudios,
            claveCarrera: career?.claveCarrera
        )
     
    }
    
    func addMainClass(career:Career) throws {
        let careers = try container.viewContext.fetch(MainCareer.fetchRequest()) as [MainCareer]
        var mainCareer = careers.first
        
        if(careers.isEmpty){
            mainCareer = MainCareer(context: self.container.viewContext)
        }
        
        mainCareer!.nombre = career.nombre
        mainCareer!.claveCarrera = career.claveCarrera
        mainCareer!.claveDependencia = career.claveDependencia
        mainCareer!.claveGradoAcademico = career.claveGradoAcademico
        mainCareer!.claveModalidad = career.claveModalidad
        mainCareer!.claveNivelAcademico = career.claveNivelAcademico
        mainCareer!.clavePlanEstudios = career.clavePlanEstudios
        mainCareer!.claveUnidad = career.claveUnidad
        
        try container.viewContext.save()

    }
    
    func deleteMainCareer() throws {
        let request = MainCareer.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try container.viewContext.execute(deleteRequest)
        
    }
    
    
}
