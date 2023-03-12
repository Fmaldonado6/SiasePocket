//
//  MainSidebarViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 28/07/22.
//

import Foundation
import FirebaseCrashlytics

class MainSidebarViewModel :BaseViewModel{
    
    let scheduleRepository:ScheduleRepository

    init(
        authRepository: AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        scheduleRepository:ScheduleRepository = DIContainer.shared.resolve(type: ScheduleRepository.self)!
    ) {
        self.scheduleRepository = scheduleRepository
    }
    
    private(set) lazy var careers:[Career] = authRepository.currentSession!.carreras
    {
        didSet {
            self.bindCareers(careers)
        }
    }
    
    var bindCareers : (([Career]) -> ()) = {careers in}
    var bindCareerSchedule : ((SidebarItem,[Schedule]) -> ()) = {sidebarItem, schedules in}
    
    
    func getCareers(){
        careers = authRepository.currentSession!.carreras
    }
    
    
    func getCareerSchedules(sidebarItem:SidebarItem){
        
        let career = Career(claveDependencia: sidebarItem.claveDependencia,claveCarrera: sidebarItem.claveCarrera)
        
        scheduleRepository.getSchedule(career:career){ schedules,error in
            guard schedules == nil else {
                self.processScheduleResponse(sidebarItem:sidebarItem,schedules: schedules!)
                return
                
            }
            guard error == nil else {
                self.processScheduleError(sidebarItem:sidebarItem,error: error!)
                return
            }
        }
    }
    
    private func processScheduleResponse(sidebarItem:SidebarItem,schedules:[Schedule]){
        bindCareerSchedule(sidebarItem,schedules)
    }
    
    private func processScheduleError(sidebarItem:SidebarItem,error:AppError){
        
        if(error is Unauthorized){
            self.restoreSession {
                self.getCareerSchedules(sidebarItem: sidebarItem)
            }
        }else{
            Crashlytics.crashlytics().record(error: error)
        }
        
    }
    

    

    
    
    
}
