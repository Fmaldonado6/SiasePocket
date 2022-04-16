//
//  MainCareerRepository.swift
//  siase
//
//  Created by Fernando Maldonado on 11/03/22.
//

import Foundation


class MainCareerRepository{
    
    private let mainScheduleDao:MainScheduleDao
    private let mainScheduleClassesDao:MainScheduleClassesDao
    private let mainCareerDao:MainCareerDao
    private let networkDataSource:NetworkDataSource
    private let authRepository:AuthRepository
    
    init(
        mainScheduleDao:MainScheduleDao = DIContainer.shared.resolve(type: MainScheduleDao.self)!,
        mainCareerDao:MainCareerDao = DIContainer.shared.resolve(type: MainCareerDao.self)!,
        networkDataSouce:NetworkDataSource = DIContainer.shared.resolve(type: NetworkDataSource.self)!,
        mainScheduleClassesDao:MainScheduleClassesDao = DIContainer.shared.resolve(type: MainScheduleClassesDao.self)!,
        authRepository:AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!
    ){
        self.mainCareerDao = mainCareerDao
        self.authRepository = authRepository
        self.mainScheduleDao = mainScheduleDao
        self.mainScheduleClassesDao = mainScheduleClassesDao
        self.networkDataSource = networkDataSouce
    }
    
    func getMainCareer()->Career?{
        try? mainCareerDao.getMainCareer()
    }
    
    func getMainSchedule()->Schedule?{
        try? mainScheduleDao.getMainSchedule()
    }
    
    func setMainCareer(career:Career,completer:@escaping(AppError?)->Void) {
        do{
            try mainCareerDao.addMainClass(career: career)
        }catch{
            completer(AppError(message: "Couldn't set main career"))
            return
        }
        completer(nil)
    }
    
    func setMainSchedule(schedule:Schedule,completer:@escaping(AppError?)->Void) {
        let index = authRepository.currentSession?.carreras.firstIndex(
            where: {career in
                career.claveCarrera == schedule.claveCarrera
                && career.claveDependencia == schedule.claveDependencia
                
            })
        
        networkDataSource.getScheduleDetail(
            index: index!,
            periodo: schedule.periodo!,
            completer: {(detail,error) in
    
                do{
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.lunes,
                        weekDay: 2
                    )
                    
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.martes,
                        weekDay: 3
                    )
                    
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.miercoles,
                        weekDay: 4
                    )
                    
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.jueves,
                        weekDay: 5
                    )
                    
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.viernes,
                        weekDay: 6
                    )
                    
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.sabado,
                        weekDay: 7
                    )
                    
                    try self.mainScheduleDao.addMainSchedule(schedule: schedule)
                }catch{
                    completer(AppError(message: "Couldn't save classes"))
                    return
                }
                completer(nil)
            })
    }
    
}
