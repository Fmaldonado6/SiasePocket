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
    
    private lazy var currentSession:LoginResponse? = {
        preferencesService.getPreferences().session
    }()
    
    init(
        networkDataSource:NetworkDataSource =
            DIContainer.shared.resolve(type: NetworkDataSource.self)!,
        preferencesService:PreferencesService =
            DIContainer.shared.resolve(type: PreferencesService.self)!
        
    ){
        self.networkDataSource = networkDataSource
        self.preferencesService = preferencesService
    }
    
    func checkSession() -> Bool{
        let preferences = preferencesService.getPreferences()
     

        if(preferences.user == nil || preferences.password == nil){
            return false
        }
            
        
        return true
    }
    
    func restoreSession(completer:@escaping (LoginResponse)->Void){
        let preferences = preferencesService.getPreferences()
        self.login(username: preferences.user!, password: preferences.password!, completer: completer)
    }
    
    func login(
        username:String,
        password:String,
        completer:@escaping (LoginResponse)->Void
    ){
        networkDataSource.login(
            user: username,
            password: password
        ){ response in
            self.currentSession = response
            var preferences = Preferences()
            preferences.user = username
            preferences.password = password
            preferences.session = response
            self.preferencesService.savePreferences(newPreferences: preferences)
            completer(response)
        }
    }
}
