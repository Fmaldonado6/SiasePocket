//
//  Models.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation

struct LoginResponse:Codable{
    var nombre: String
    var matricula: String
    var token:String
    var carreras:[Career]
}

struct Preferences:Codable{
    var user:String?
    var password:String?
    var session:LoginResponse?
}

class PreferencesKeys{
    static let UserKey = "UserKey"
    static let PasswordKey = "PasswordKey"
    static let SessionKey = "SessionKey"
}

struct Career:Codable{
    var nombre:String?
    var claveDependencia: String?
    var claveUnidad: String?
    var claveNivelAcademico: String?
    var claveGradoAcademico: String?
    var claveModalidad: String?
    var clavePlanEstudios: String?
    var claveCarrera: String?
}

struct Schedule:Codable{
    var nombre: String?
    var claveDependencia: String?
    var claveUnidad: String?
    var claveNivelAcademico: String?
    var claveGradoAcademico: String?
    var claveModalidad: String?
    var clavePlanEstudios: String?
    var claveCarrera: String?
    var periodo: String?
}

struct ClassDetail:Codable{
    var nombre: String?
    var nombreCorto:String?
    var fase: String?
    var tipo: String?
    var grupo: String?
    var salon: String?
    var horaInicio: String?
    var horaFin: String?
    var claveMateria: String?
    var modalidad: String?
    var oportunidad: String?
}

struct ScheduleDetail:Codable{
    var lunes: [ClassDetail] = []
    var martes: [ClassDetail] = []
    var miercoles: [ClassDetail] = []
    var jueves: [ClassDetail] = []
    var viernes: [ClassDetail] = []
    var sabado: [ClassDetail] = []
    
    
}
