//
//  KardexPageViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 22/04/22.
//

import Foundation
import OrderedCollections

class KardexPageViewModel:BaseViewModel{
    
    private let kardexRepository:KardexRepository
    
    init(
        authRepository: AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        kardexRepository:KardexRepository = DIContainer.shared.resolve(type: KardexRepository.self)!
    ) {
        self.kardexRepository = kardexRepository
    }
    
    private(set) var subjects:[[Subject]] = [[Subject]]()
    {
        didSet{
            bindSubjects(subjects)
        }
    }
    
    var bindSubjects:([[Subject]])->Void = {subjects in}
    
    func getkardex(career:Career){
        status = Status.Loading
        kardexRepository.getKardex(career: career, completer: {(kardex,error)in
            guard kardex == nil else {
                self.processResponse(kardex: kardex!)
                return
                
            }
            guard error == nil else {
                self.processError(career:career,error: error!)
                return
            }
        })
        
    }
    private func processError(career:Career,error:AppError){
        if(error is Unauthorized){
            self.restoreSession {
                self.getkardex(career: career)
            }
        }else{
            self.status = Status.Error
        }
    }
    
    private func processResponse(kardex:Kardex){
        
        var map:OrderedDictionary<String,[Subject]> = [:]
        
        for subject in kardex.materias{
            if(map[subject.semestreMateria!] == nil){
                map[subject.semestreMateria!] = [subject]
            }else{
                map[subject.semestreMateria!]?.append(subject)
            }
        }
        
        subjects = Array(map.values)
        status = Status.Loaded
        
    }
    
}
