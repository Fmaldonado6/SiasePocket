//
//  ScheduleSelectionViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 21/04/22.
//

import Foundation
import FirebaseCrashlytics
class ScheduleSelectionViewModel:BaseViewModel{
    
    let scheduleRepository:ScheduleRepository
    
    init(
        authRepository: AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        scheduleRepository:ScheduleRepository = DIContainer.shared.resolve(type: ScheduleRepository.self)!
    ) {
        self.scheduleRepository = scheduleRepository
    }
    
    
    private(set) var schedules:[Schedule] = [Schedule]()
    {
        didSet{
            bindSchedule(schedules)
        }
    }
    
    var bindSchedule:([Schedule])->Void = {schedules in}
    
    func getSchedules(index:Int){
        self.status = Status.Loading
        scheduleRepository.getSchedule(index: index){ schedules,error in
            guard schedules == nil else {
                self.processResponse(schedules: schedules!)
                return
                
            }
            guard error == nil else {
                self.processError(index:index,error: error!)
                return
            }
        }
    }
    
    private func processResponse(schedules:[Schedule]){
        self.schedules = schedules
        self.status = Status.Loaded
    }
    
    private func processError(index:Int,error:AppError){
        
        if(error is Unauthorized){
            self.restoreSession {
                self.getSchedules(index: index)
            }
        }else{
            Crashlytics.crashlytics().record(error: error)
            self.status = Status.Error
        }
        
    }
    
}
