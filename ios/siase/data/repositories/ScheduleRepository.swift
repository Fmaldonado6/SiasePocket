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
    
    private var todaySchedule:[ClassDetail]?
    private var dayOfWeek:Int?
    
    init(
        authRepository:AuthRepository =
            DIContainer.shared.resolve(type: AuthRepository.self)!,
        networkDataSource :NetworkDataSource = DIContainer.shared.resolve(type: NetworkDataSource.self)!
    ){
        self.authRepository = authRepository
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
        
        return []
        
    }
    
    func getSchedule(index:Int,completer:@escaping([Schedule]?,AppError? )->Void){
        
        networkDataSource.getSchedules(index: index, completer: completer)
        
    }
    
    
}
