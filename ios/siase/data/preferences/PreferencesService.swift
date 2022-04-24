//
//  PreferencesService.swift
//  siase
//
//  Created by Fernando Maldonado on 28/02/22.
//

import Foundation

class PreferencesService{
    
    private let preferences:UserDefaults
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    
    init(
        userDefaults:UserDefaults = DIContainer.shared.resolve(type: UserDefaults.self)!
    ){
        self.preferences = userDefaults
    }
    
    
    func savePreferences(newPreferences:Preferences){
        let sessionData = try? jsonEncoder.encode(newPreferences.session)
        let json = String(data: sessionData!, encoding: String.Encoding.utf8)

        preferences.set(newPreferences.user, forKey: PreferencesKeys.UserKey)
        preferences.set(newPreferences.password, forKey: PreferencesKeys.PasswordKey)
        preferences.set(json, forKey: PreferencesKeys.SessionKey)
    }
    
    func getPreferences() -> Preferences{
        var savedPreferences = Preferences()
        
        savedPreferences.user = preferences.string(forKey: PreferencesKeys.UserKey)
        savedPreferences.password = preferences.string(forKey: PreferencesKeys.PasswordKey)
        let jsonData = preferences.string(forKey: PreferencesKeys.SessionKey)
        let json = jsonData?.data(using: .utf8)
        if(json != nil){
            savedPreferences.session = try? jsonDecoder.decode(LoginResponse.self, from: json!)
        }
        
        
        
        return savedPreferences
    }
    
    func delete(){
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
        }
    }
    
    
}
