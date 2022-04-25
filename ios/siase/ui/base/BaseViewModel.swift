//
//  BaseViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 15/04/22.
//

import Foundation

class BaseViewModel{
    
    internal let authRepository:AuthRepository
    
    init(
        authRepository:AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!
    ){
        self.authRepository = authRepository
    }
    
    internal(set) var status:Status = Status.Loading
    {
        didSet{
            self.bindStatus(status)
        }
    }
    
    var bindStatus : ((Status) -> ()) = {status in}
    
    func restoreSession(process:@escaping () -> Void){
        status = Status.Loading
        authRepository.restoreSession(completer: {(loginResponse,error) in
            if(error != nil){
                self.status = Status.Error
                return
            }
            process()
        })
    }
    
}
