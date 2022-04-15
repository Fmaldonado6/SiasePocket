//
//  MainScheduleSelectionViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 15/04/22.
//

import Foundation


class MainScheduleSelectionViewModel  : BaseViewModel {
    
    private let scheduleRepository:ScheduleRepository
    
    
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
    
    func setMainSchedule(career:Career,schedule:Schedule){
        status = Status.Completed
    }
    
    private func processError(index:Int,error:AppError){
        
        print(error.message)

        if(error is Unauthorized){
            self.restoreSession {
                self.getSchedules(index: index)
            }
        }else{
            self.status = Status.Error
        }
        
    }
    
}
