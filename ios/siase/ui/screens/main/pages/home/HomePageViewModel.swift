//
//  HomePageViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 28/02/22.
//

import Foundation
import FirebaseCrashlytics
class HomePageVieModel:BaseViewModel{
    
    private let scheduleRepository:ScheduleRepository
    
    init(
        authRepository:AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        scheduleRepository:ScheduleRepository = DIContainer.shared.resolve(type: ScheduleRepository.self)!
    ){
        self.scheduleRepository = scheduleRepository
    }
    
    private(set) lazy var currentSession = self.authRepository.currentSession!
    
    private(set) var todaySchedule:[ClassDetail]? = nil
    {
        didSet{
            bindTodaySchedule(todaySchedule)
        }
    }
    
    private(set) var nextClass:ClassDetail? = nil
    {
        didSet{
            bindNextClass(nextClass)
        }
    }

    var bindTodaySchedule:([ClassDetail]?)->Void = {classes in }
    var bindNextClass:(ClassDetail?)->Void = {nextClass in }
    
    func getFullSchedule() -> ScheduleDetail?{
        return scheduleRepository.fullSchedule
    }

    
    func getTodaySchedule(){
        status = Status.Loading
        todaySchedule = scheduleRepository.getTodaySchedule()
        nextClass = scheduleRepository.getNextClass(schedule: todaySchedule ?? [])
        status = Status.Loaded
    }
    

    
   
    
    
}
