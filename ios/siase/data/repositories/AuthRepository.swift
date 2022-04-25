//
//  AuthRepository.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation


class AuthRepository{
    
    private let networkDataSource:NetworkDataSource
    
    private let preferencesService:PreferencesService
    private let mainCareerDao:MainCareerDao
    private let mainScheduleDao:MainScheduleDao
    private let mainSheduleClassesDao:MainScheduleClassesDao
    
    var currentSession:LoginResponse?
    {
        set{
            var preferences = self.preferencesService.getPreferences()
            preferences.session = newValue
            self.preferencesService.savePreferences(newPreferences: preferences)
        }
        get{
            self.preferencesService.getPreferences().session
        }
    }
    
    
    
    init(
        networkDataSource:NetworkDataSource =
        DIContainer.shared.resolve(type: NetworkDataSource.self)!,
        preferencesService:PreferencesService =
        DIContainer.shared.resolve(type: PreferencesService.self)!,
        mainCareerDao:MainCareerDao =
        DIContainer.shared.resolve(type: MainCareerDao.self)!,
        mainScheduleDao:MainScheduleDao =
        DIContainer.shared.resolve(type: MainScheduleDao.self)!,
        mainScheduleClassesDao:MainScheduleClassesDao =
        DIContainer.shared.resolve(type: MainScheduleClassesDao.self)!
        
    ){
        self.networkDataSource = networkDataSource
        self.preferencesService = preferencesService
        self.mainCareerDao = mainCareerDao
        self.mainScheduleDao = mainScheduleDao
        self.mainSheduleClassesDao = mainScheduleClassesDao
    }
    
    func checkSession() -> Bool{
        let preferences = preferencesService.getPreferences()
        
        
        if(preferences.user == nil || preferences.password == nil){
            return false
        }
        
        return true
    }
    
    func restoreSession(completer:@escaping (LoginResponse?,AppError?)->Void){
        let preferences = preferencesService.getPreferences()
        self.login(
            username: preferences.user!,
            password: preferences.password!,
            completer: completer
        )
    }
    
    func login(
        username:String,
        password:String,
        completer:@escaping (LoginResponse?,AppError?)->Void
    ){
        networkDataSource.login(
            user: username,
            password: password
        ){ response,error in
            
            if(error != nil){
                return completer(nil,error)
            }
            
            var preferences = Preferences()
            preferences.user = username
            preferences.password = password
            preferences.session = response
            self.preferencesService.savePreferences(newPreferences: preferences)
            
            completer(response,nil)
        }
    }
    
    func signOut(){
        self.preferencesService.delete()
        try? self.mainCareerDao.deleteMainCareer()
        try? self.mainScheduleDao.deleteMainCareer()
        try? self.mainSheduleClassesDao.deleteClasses()
    }
}
