//
//  MainScheduleSelectionViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 15/04/22.
//

import Foundation


class MainScheduleSelectionViewModel  : BaseViewModel {
    
    private let scheduleRepository:ScheduleRepository
    private let mainCareerRepository:MainCareerRepository
    
    
    init(
        authRepository: AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        scheduleRepository:ScheduleRepository = DIContainer.shared.resolve(type: ScheduleRepository.self)!,
        mainCareerRepository:MainCareerRepository = DIContainer.shared.resolve(type: MainCareerRepository.self)!
    ) {
        self.scheduleRepository = scheduleRepository
        self.mainCareerRepository = mainCareerRepository
    }
    
    private(set) var schedules:[Schedule] = [Schedule]()
    {
        didSet{
            bindSchedule(schedules)
        }
    }
    
    var bindSchedule:([Schedule])->Void = {schedules in}
    
    func getSchedules(career:Career){
        self.status = Status.Loading
        scheduleRepository.getSchedule(career: career){ schedules,error in
            guard schedules == nil else {
                self.processResponse(schedules: schedules!)
                return
                
            }
            guard error == nil else {
                self.processError(career: career,error: error!)
                return
            }
        }
    }
    
    private func processResponse(schedules:[Schedule]){
        self.schedules = schedules
        self.status = Status.Loaded
    }
    
    func setMainSchedule(career:Career,schedule:Schedule){
        status = Status.Loading
        self.mainCareerRepository.setMainCareer(career: career){careerError in
            
            guard careerError == nil else {
                self.status = Status.Error
                return
            }
            
            self.mainCareerRepository.setMainSchedule(schedule: schedule){ scheduleError in
                guard careerError == nil else {
                    self.status = Status.Error
                    return
                }
                self.scheduleRepository.resetSchedule()
                self.status = Status.Completed
                
            }
            
        }
        
    }
    
    private func processError(career:Career,error:AppError){
        
        if(error is Unauthorized){
            self.restoreSession {
                self.getSchedules(career: career)
            }
        }else{
            self.status = Status.Error
        }
        
    }
    
}
