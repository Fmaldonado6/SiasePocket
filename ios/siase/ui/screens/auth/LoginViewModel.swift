//
//  LoginViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation

class LoginViewModel{
    
    private let authRepository:AuthRepository
    
    init(
        authRepository:AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!
    ){
        self.authRepository = authRepository
    }
    
    private(set) var status:Status = Status.Loading
    {
        didSet {
            self.bindStatus(status)
        }
    }
    
    var bindStatus : ((Status) -> ()) = {status in}
    
    func checkSession(){
        self.status = Status.Loading
        let hasSession = authRepository.checkSession()
        if(hasSession){
            authRepository.restoreSession(){response in
                self.status = Status.Completed
            }
        }else{
            self.status = Status.Loaded
        }
        
        
    }
    
    func login(username:String, password:String){
        status = Status.Loading
        authRepository.login(username: username, password: password) { loginResponse in
            self.status = Status.Completed
        }
    }

}
