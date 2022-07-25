//
//  MainCareerRepository.swift
//  siase
//
//  Created by Fernando Maldonado on 11/03/22.
//

import Foundation


class MainCareerRepository{
    
    private let mainScheduleDao:MainScheduleDao
    private let mainScheduleClassesDao:MainScheduleClassesDao
    private let mainCareerDao:MainCareerDao
    private let networkDataSource:NetworkDataSource
    private let authRepository:AuthRepository
    private let notificationService:NotificationService
    
    init(
        mainScheduleDao:MainScheduleDao = DIContainer.shared.resolve(type: MainScheduleDao.self)!,
        mainCareerDao:MainCareerDao = DIContainer.shared.resolve(type: MainCareerDao.self)!,
        networkDataSouce:NetworkDataSource = DIContainer.shared.resolve(type: NetworkDataSource.self)!,
        mainScheduleClassesDao:MainScheduleClassesDao = DIContainer.shared.resolve(type: MainScheduleClassesDao.self)!,
        authRepository:AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        notificationService:NotificationService = DIContainer.shared.resolve(type: NotificationService.self)!
    ){
        self.mainCareerDao = mainCareerDao
        self.notificationService = notificationService
        self.authRepository = authRepository
        self.mainScheduleDao = mainScheduleDao
        self.mainScheduleClassesDao = mainScheduleClassesDao
        self.networkDataSource = networkDataSouce
    }
    
    func getMainCareer()->Career?{
        try? mainCareerDao.getMainCareer()
    }
    
    func getMainSchedule()->Schedule?{
        try? mainScheduleDao.getMainSchedule()
    }
    
    func setMainCareer(career:Career,completer:@escaping(AppError?)->Void) {
        do{
            try mainCareerDao.addMainClass(career: career)
        }catch{
            completer(AppError(message: "Couldn't set main career"))
            return
        }
        completer(nil)
    }
    
    func setMainSchedule(schedule:Schedule,completer:@escaping(AppError?)->Void) {
        let index = authRepository.currentSession?.carreras.firstIndex(
            where: {career in
                career.claveCarrera == schedule.claveCarrera
                && career.claveDependencia == schedule.claveDependencia
                
            })
        
        networkDataSource.getScheduleDetail(
            index: index!,
            periodo: schedule.periodo!,
            completer: {(detail,error) in
                
                do{
                    try self.mainScheduleClassesDao.deleteClasses()
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.lunes,
                        weekDay: 2
                    )
                    
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.martes,
                        weekDay: 3
                    )
                    
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.miercoles,
                        weekDay: 4
                    )
                    
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.jueves,
                        weekDay: 5
                    )
                    
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.viernes,
                        weekDay: 6
                    )
                    
                    try self.mainScheduleClassesDao.insertClasses(
                        classes: detail!.sabado,
                        weekDay: 7
                    )
                    
                    try self.mainScheduleDao.addMainSchedule(schedule: schedule)
                }catch{
                    completer(AppError(message: "Couldn't save classes"))
                    return
                }
                
                self.activateNotifications(schedule: detail!, completer: {
                    completer(nil)
                })
                
            })
    }
    
    func requestNotificationPermission(completer:@escaping(Bool,Error?)->Void){
        notificationService.requestPermission(completer: completer)
    }
    
    func getMainScheduleDetail() -> ScheduleDetail?{
        return try? mainScheduleClassesDao.getClasses()
    }
    
    func activateNotifications(schedule:ScheduleDetail,completer:@escaping()->Void){
        
        notificationService.hasPermission{permission in
            print(permission)
            if(!permission){
                completer()
                return
            }
            self.notificationService.removeNotifications()
            
            var classesList = [Int : [ClassDetail]]()
            
            classesList[2] = schedule.lunes.getFormattedDetail()
            classesList[3] = schedule.martes.getFormattedDetail()
            classesList[4] = schedule.miercoles.getFormattedDetail()
            classesList[5] = schedule.jueves.getFormattedDetail()
            classesList[6] = schedule.viernes.getFormattedDetail()
            classesList[7] = schedule.sabado.getFormattedDetail()
            
            
            let calendar = Calendar.current
            
            for (key,weekDays) in classesList{
                
                if(weekDays.isEmpty){
                    continue
                }
                
                
                for classDetail in weekDays{
                    let date = Date.parseTime(time: classDetail.horaInicio!)
                    
                    var components = calendar.dateComponents([.weekday,.hour,.minute,.second], from: Date())
                    
                    components.weekday = key
                    components.hour = date.hour
                    components.minute = date.minute
                    components.second = 0

                    let notification = Notification(
                        identifier: "\(classDetail.claveMateria!)-\(classDetail.nombre!)-\(key)",
                        title: "Siguiente clase",
                        subtitle: "\(classDetail.nombre!) ha empezado",
                        trigger: components
                    )
                    
                    self.notificationService.scheduleNotification(notification: notification)
                }
                
            }
            
            for (key,weekDays) in classesList{
                
                if(weekDays.isEmpty){
                    continue
                }

                for classDetail in weekDays{
                    let date = Date.parseTime(time: classDetail.horaInicio!)

                    var components = DateComponents(calendar: .current, timeZone: .current, hour: date.hour, weekday: key)
                    
                    
                    components.hour = date.hour
                    components.minute = date.minute
                    

                    let componentsDate = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)
                    let date15Min = calendar.date(byAdding: .minute, value: -15, to: componentsDate!)

                    let date15MinComponents = calendar.dateComponents([.weekday,.hour,.minute,.second], from: date15Min!)
                    
                    let notification = Notification(
                        identifier: "\(classDetail.claveMateria!)-\(classDetail.nombre!)-\(key)-15",
                        title: "Siguiente clase",
                        subtitle: "\(classDetail.nombre!) empieza en 15 minutos",
                        trigger: date15MinComponents
                    )
                    
                    self.notificationService.scheduleNotification(notification: notification)
                    
                }
                
            }
            
            completer()
        }
        
        
        
    }
    
}
