//
//  SignedInUserCareers+CoreDataProperties.swift
//  siase
//
//  Created by Fernando Maldonado on 01/02/23.
//
//

import Foundation
import CoreData


extension SignedInUserCareers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SignedInUserCareers> {
        return NSFetchRequest<SignedInUserCareers>(entityName: "SignedInUserCareers")
    }

    @NSManaged public var nombre: String?
    @NSManaged public var claveDependencia: String?
    @NSManaged public var claveUnidad: String?
    @NSManaged public var claveNivelAcademico: String?
    @NSManaged public var claveGradoAcademico: String?
    @NSManaged public var claveModalidad: String?
    @NSManaged public var clavePlanEstudios: String?
    @NSManaged public var claveCarrera: String?
    @NSManaged public var userRelation: SignedInUser?

}

extension SignedInUserCareers : Identifiable {

}
