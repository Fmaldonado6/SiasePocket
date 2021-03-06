//
//  MorePageViewMode;.swift
//  siase
//
//  Created by Fernando Maldonado on 23/04/22.
//

import Foundation


class MorePageViewModel:BaseViewModel{
    
    private let mainCareerRepository:MainCareerRepository
    private let scheduleRepository:ScheduleRepository
    
     init(
        authRepository: AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        mainCareerRepository:MainCareerRepository = DIContainer.shared.resolve(type: MainCareerRepository.self)!,
        scheduleRepository:ScheduleRepository = DIContainer.shared.resolve(type: ScheduleRepository.self)!
     ) {
         self.mainCareerRepository = mainCareerRepository
         self.scheduleRepository = scheduleRepository
    }
    
    private(set) var mainCareer:Career? = nil
    {
        didSet{
            bindMainCareer(mainCareer)
        }
    }
    
    
    private(set) var mainSchedule:Schedule? = nil
    {
        didSet{
            bindMainSchedule(mainSchedule)
        }
    }

    private(set) var notificationsDone:Bool? = nil
    {
        didSet{
            bindNotificationsDone(notificationsDone)
        }
    }

    
    var bindMainCareer:(Career?)->Void = {career in}
    var bindNotificationsDone:(Bool?)->Void = {done in}
    var bindMainSchedule:(Schedule?)->Void = {schedule in}
    
    func getMainCareer(){
        mainCareer = mainCareerRepository.getMainCareer()
    }
    
    func activateNotifications(){
        guard let detail = mainCareerRepository.getMainScheduleDetail() else{
            return
        }
        mainCareerRepository.activateNotifications(schedule: detail, completer: {
            self.notificationsDone = true
            self.notificationsDone = nil
        })
    }
    
    func signOut(){
        authRepository.signOut()
        scheduleRepository.resetSchedule()
    }
    
    func getMainSchedule(){
        mainSchedule = mainCareerRepository.getMainSchedule()
    }
    
}
