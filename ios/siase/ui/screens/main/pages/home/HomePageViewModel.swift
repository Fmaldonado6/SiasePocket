//
//  HomePageViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 28/02/22.
//

import Foundation

class HomePageVieModel{
    
    private let authRepository:AuthRepository
    
    init(
        authRepository:AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!
    ){
        self.authRepository = authRepository
    }
    
    
    
    
}
