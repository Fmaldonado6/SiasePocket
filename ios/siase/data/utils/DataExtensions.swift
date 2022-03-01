//
//  Extensions.swift
//  siase
//
//  Created by Fernando Maldonado on 28/02/22.
//

import Foundation


extension Array where Element == ClassDetail {
    func getFormattedDetail()-> [ClassDetail] {
        let detail = self
        
        if (detail.isEmpty) {
            return []
        }

        var newDetail:[ClassDetail] = []

        var currentSubject = detail.first!

        for var classDetail in detail {
            if (classDetail.claveMateria != currentSubject.claveMateria) {
                newDetail.append(currentSubject)
            } else {
                classDetail.horaInicio = currentSubject.horaInicio
                currentSubject.horaFin = classDetail.horaFin
            }
            currentSubject = classDetail
        }

        newDetail.append(currentSubject)
        return newDetail
    }
}
