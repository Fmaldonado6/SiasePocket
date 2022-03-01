//
//  ScheduleRepository.swift
//  siase
//
//  Created by Fernando Maldonado on 28/02/22.
//

import Foundation

class ScheduleRepository{
    
    private let authRepository:AuthRepository
    
    private var todaySchedule:[ClassDetail]?
    private var dayOfWeek:Int?
    
    init(
        authRepository:AuthRepository =
            DIContainer.shared.resolve(type: AuthRepository.self)!
    ){
        self.authRepository = authRepository
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
    
    
}
