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
    
    func getKardex(career:Career,completer:@escaping(Kardex?,AppError? )->Void){
        guard let index = authRepository.currentSession?.carreras.firstIndex(where: {e in
            return e.claveCarrera == career.claveCarrera && e.claveDependencia == career.claveDependencia

        })else{
            completer(nil,AppError(message:"Couldn't find career"))
            return
        }
        networkDataSource.gerKardex(index: index, completer: completer)
    }
    
}
