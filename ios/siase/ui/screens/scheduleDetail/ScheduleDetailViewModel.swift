//
//  ScheduleDetailViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 21/04/22.
//

import Foundation
import FirebaseCrashlytics
class ScheduleDetailViewModel:BaseViewModel{
    
    
    let scheduleRepository:ScheduleRepository
    
    init(
        authRepository: AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        scheduleRepository:ScheduleRepository = DIContainer.shared.resolve(type: ScheduleRepository.self)!
    ) {
        self.scheduleRepository = scheduleRepository
    }
    
    private(set) var scheduleDetail:[[ClassDetail]] = [[ClassDetail]]()
    {
        didSet{
            bindSchedule(scheduleDetail)
        }
    }
    
    var bindSchedule:([[ClassDetail]])->Void = {scheduleDetail in}
    
    func getScheduleDetail(schedule:Schedule){
        self.status = Status.Loading
        scheduleRepository.getScheduleDetail(schedule: schedule, completer: {(scheduleDetail,error) in
            guard scheduleDetail == nil else {
                self.processResponse(scheduleDetail: scheduleDetail!)
                return
                
            }
            guard error == nil else {
                self.processError(error: error!,schedule: schedule)
                return
            }
        })
        
    }
    
    private func processError(error:AppError,schedule:Schedule){
        if(error is Unauthorized){
            self.restoreSession {
                self.getScheduleDetail(schedule: schedule)
            }
        }else{
            Crashlytics.crashlytics().record(error: error)
            self.status = Status.Error
        }
    }
    
    func setStatus(status:Status){
        self.status = status
    }
    
    func processResponse(scheduleDetail:ScheduleDetail){
        self.status = Status.Loading
        var list = [[ClassDetail]]()
        list.append(scheduleDetail.lunes.getFormattedDetail())
        list.append(scheduleDetail.martes.getFormattedDetail())
        list.append(scheduleDetail.miercoles.getFormattedDetail())
        list.append(scheduleDetail.jueves.getFormattedDetail())
        list.append(scheduleDetail.viernes.getFormattedDetail())
        list.append(scheduleDetail.sabado.getFormattedDetail())
        
        self.status = Status.Loaded
        self.scheduleDetail = list

    }
    
    
}
