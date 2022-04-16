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
    
    func checkSession(){
        self.status = Status.Loading
        let hasSession = authRepository.checkSession()
        if(hasSession){
            authRepository.restoreSession(){response,error in
                if(error != nil){
                    self.status = Status.Loaded
                    return
                }
                self.status = Status.Completed
            }
        }else{
            self.status = Status.Loaded
        }
        
        
    }
    
    func login(username:String, password:String){
        status = Status.Loading
        authRepository.login(username: username, password: password) { loginResponse, error in
            
            if(error != nil){
                self.status = Status.Loaded
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
