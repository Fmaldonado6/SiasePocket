//
//  SignedInUser+CoreDataProperties.swift
//  siase
//
//  Created by Fernando Maldonado on 01/02/23.
//
//

import Foundation
import CoreData


extension SignedInUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SignedInUser> {
        return NSFetchRequest<SignedInUser>(entityName: "SignedInUser")
    }

    @NSManaged public var nombre: String?
    @NSManaged public var matricula: String?
    @NSManaged public var careers: NSSet?

}

// MARK: Generated accessors for careers
extension SignedInUser {

    @objc(addCareersObject:)
    @NSManaged public func addToCareers(_ value: SignedInUserCareers)

    @objc(removeCareersObject:)
    @NSManaged public func removeFromCareers(_ value: SignedInUserCareers)

    @objc(addCareers:)
    @NSManaged public func addToCareers(_ values: NSSet)

    @objc(removeCareers:)
    @NSManaged public func removeFromCareers(_ values: NSSet)

}

extension SignedInUser : Identifiable {

}
