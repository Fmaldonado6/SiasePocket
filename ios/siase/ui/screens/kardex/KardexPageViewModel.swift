//
//  KardexPageViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 22/04/22.
//

import Foundation

class KardexPageViewModel:BaseViewModel{
    
    private let kardexRepository:KardexRepository
    
    init(
        authRepository: AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        kardexRepository:KardexRepository = DIContainer.shared.resolve(type: KardexRepository.self)!
    ) {
        self.kardexRepository = kardexRepository
    }
    
}
