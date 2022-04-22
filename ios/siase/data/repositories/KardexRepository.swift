//
//  KardexRepository.swift
//  siase
//
//  Created by Fernando Maldonado on 22/04/22.
//

import Foundation

class KardexRepository{
    
    private let authRepository:AuthRepository
    private let networkDataSource:NetworkDataSource
    
    init(
        authRepository:AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        networkDataSource:NetworkDataSource = DIContainer.shared.resolve(type: NetworkDataSource.self)!
    ){
        self.authRepository = authRepository
        self.networkDataSource = networkDataSource
    }
    
    func getKardex(career:Career){
        
    }
    
}
