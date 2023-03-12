//
//  SignedInUserDao.swift
//  siase
//
//  Created by Fernando Maldonado on 01/02/23.
//

import Foundation
import CoreData

class SignedInUserDao{
    private let container:NSPersistentContainer
    
    init(
        container:NSPersistentContainer =
        DIContainer.shared.resolve(type: NSPersistentContainer.self)!
    ){
        self.container = container
    }
    
    func getUser() throws -> LoginResponse? {
        let user = try container.viewContext.fetch(SignedInUser.fetchRequest()).first as SignedInUser?
        
        if(user == nil) {
            return nil
        }
        
        let userCareers = user!.careers?.allObjects as! [SignedInUserCareers]
        
        return LoginResponse(
            nombre:user?.nombre ?? "",
            matricula: user?.matricula ?? "",
            token: user?.token ?? "",
            carreras:  userCareers.map{ career in
                Career(
                    nombre: career.nombre,
                    claveDependencia: career.claveDependencia,
                    claveUnidad: career.claveUnidad,
                    claveNivelAcademico: career.claveNivelAcademico,
                    claveGradoAcademico: career.claveGradoAcademico,
                    claveModalidad: career.claveModalidad,
                    clavePlanEstudios: career.clavePlanEstudios,
                    claveCarrera: career.claveCarrera
                )
            }
            
        )
     
    }
    
    
    func insertUser(user:LoginResponse) throws {
        
        let request = SignedInUser.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try container.viewContext.execute(deleteRequest)
        
        let newUser = SignedInUser(context: container.viewContext)
    
        newUser.nombre = user.nombre
        newUser.matricula = user.matricula
        newUser.token = user.token
        
        user.carreras.forEach{ career in
            let newCareer = SignedInUserCareers(context: container.viewContext)
            newCareer.claveCarrera = career.claveCarrera
            newCareer.nombre = career.nombre
            newCareer.claveDependencia = career.claveDependencia
            newCareer.claveGradoAcademico = career.claveGradoAcademico
            newCareer.claveModalidad = career.claveModalidad
            newCareer.claveNivelAcademico = career.claveNivelAcademico
            newCareer.clavePlanEstudios = career.clavePlanEstudios
            newCareer.claveCarrera = career.claveCarrera
            newCareer.claveUnidad = career.claveUnidad
            newUser.addToCareers(newCareer)
            
        }
        
        try container.viewContext.save()
        
    }
    
    
}
