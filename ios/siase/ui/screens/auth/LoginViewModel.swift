//
//  LoginViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation

class LoginViewModel : BaseViewModel {
    
    private let mainCareerRepository:MainCareerRepository
    init(
        authRepository:AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        mainCareerRepository:MainCareerRepository = DIContainer.shared.resolve(type: MainCareerRepository.self)!
    ){
        self.mainCareerRepository = mainCareerRepository
    }

    
    private(set) var needsSelection:Bool?
    {
        didSet{
            self.bindNeedsSelection(needsSelection)
        }
    }
    
    
        
    var bindNeedsSelection:((Bool?)->()) = {bool in}
    
    private(set) var permissionRequested:Bool?
    {
        didSet{
            self.bindPermissionRequested(permissionRequested)
        }
    }
    
    var bindPermissionRequested:((Bool?)->()) = {bool in}
    
    func requestNotificationPermission(){
        mainCareerRepository.requestNotificationPermission(completer: {permission,_ in
            self.permissionRequested = permission
        })
    }
    
    func checkSession(){
        self.status = Status.Loading
        let hasSession = authRepository.checkSession()
        if(hasSession){
            self.status = Status.Completed
        }else{
            self.status = Status.Loaded
        }
        
        
    }
    
    func login(username:String, password:String){
        status = Status.Loading
        authRepository.login(username: username, password: password) { loginResponse, error in
            
            if(error != nil){
                self.status = Status.Error
                return
            }
            
            self.status = Status.Completed
        }
    }
    
    func checkIfNeedsSelection(){
        let mainCareer = mainCareerRepository.getMainCareer()
        let mainSchedule = mainCareerRepository.getMainSchedule()
        
        if(mainCareer == nil || mainSchedule == nil){
            needsSelection = true
            return
        }

        needsSelection = false
    }

}
