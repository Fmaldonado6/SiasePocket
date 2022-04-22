//
//  ScheduleRepository.swift
//  siase
//
//  Created by Fernando Maldonado on 28/02/22.
//

import Foundation

class ScheduleRepository{
    
    private let authRepository:AuthRepository
    private let networkDataSource:NetworkDataSource
    private let mainScheduleClassesDao:MainScheduleClassesDao
    
    private var todaySchedule:[ClassDetail]?
    private(set) var fullSchedule:ScheduleDetail?
    private var dayOfWeek:Int?
    
    init(
        authRepository:AuthRepository =
        DIContainer.shared.resolve(type: AuthRepository.self)!,
        mainScheduleClassesDao:MainScheduleClassesDao = DIContainer.shared.resolve(type: MainScheduleClassesDao.self)!,
        networkDataSource :NetworkDataSource = DIContainer.shared.resolve(type: NetworkDataSource.self)!
    ){
        self.authRepository = authRepository
        self.mainScheduleClassesDao = mainScheduleClassesDao
        self.networkDataSource = networkDataSource
    }
    
    func requiresFetch() -> Bool{
        let calendar = Calendar.current
        let today = calendar.component(.weekday,from: Date.now)
        
        if (today != dayOfWeek) {
            return true
        }
        
        if (dayOfWeek == nil){
            return true
        }
        
        if (dayOfWeek == 7) {
            return false
        }
        
        return false
    }
    
    func getTodaySchedule() -> [ClassDetail]?{
        
        if(!self.requiresFetch()) {
            return todaySchedule
        }
        
        let calendar = Calendar.current
        
        dayOfWeek = calendar.component(.weekday, from: Date.now)
        guard let fullSchedule = try? mainScheduleClassesDao.getClasses() else{ return [] }
        self.fullSchedule = fullSchedule
        todaySchedule = getScheduleByDay(day: dayOfWeek ?? 0, schedule: fullSchedule)
        
        return todaySchedule
        
    }
    
    private func getScheduleByDay(day:Int,schedule:ScheduleDetail) -> [ClassDetail]?{
        switch(day){
        case 2:return schedule.lunes.getFormattedDetail()
        case 3:return schedule.martes.getFormattedDetail()
        case 4:return schedule.miercoles.getFormattedDetail()
        case 5:return schedule.jueves.getFormattedDetail()
        case 6:return schedule.viernes.getFormattedDetail()
        case 7:return schedule.sabado.getFormattedDetail()
        default:return nil
            
        }
    }
    
    func getNextClass(schedule:[ClassDetail])-> ClassDetail?{
        if(schedule.isEmpty) {
            return nil
        }
        
        let now = Calendar.current.dateComponents([.hour,.minute], from: Date.now)
        
        for classDetail in schedule{
            let startTime = Date.parseTime(time: classDetail.horaInicio!)
            let difference = Calendar.current.dateComponents([.minute], from: now, to: startTime).minute!
            
            if(difference > 0){
                return classDetail
            }
        }
        
        return nil
    }
    
    func getSchedule(index:Int,completer:@escaping([Schedule]?,AppError? )->Void){
        
        networkDataSource.getSchedules(index: index, completer: completer)
        
    }
    
    func getScheduleDetail(index:Int,periodo:String,completer:@escaping(ScheduleDetail?,AppError? )->Void){
        networkDataSource.getScheduleDetail(index: index, periodo: periodo, completer: completer)
    }
    
    func getScheduleDetail(schedule:Schedule,completer:@escaping(ScheduleDetail?,AppError? )->Void){
       guard let index = authRepository.currentSession?.carreras.firstIndex(where: { e in
            return e.claveCarrera == schedule.claveCarrera && e.claveDependencia == schedule.claveDependencia
       })else{
           completer(nil,AppError(message:"Couldn't find career"))
           return
       }
        
        networkDataSource.getScheduleDetail(index: index, periodo: schedule.periodo ?? "", completer: completer)
    }
    
    
    
}
