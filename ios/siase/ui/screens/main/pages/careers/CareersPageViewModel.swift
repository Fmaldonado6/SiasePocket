//
//  CareersViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 19/04/22.
//

import Foundation

class CareersPageViewModel:BaseViewModel{
    
    
    private(set) lazy var careers:[Career] = authRepository.currentSession!.carreras
    {
        didSet {
            self.bindCareers(careers)
        }
    }
    
    var bindCareers : (([Career]) -> ()) = {careers in}
    
    func getCareers(){
        careers = authRepository.currentSession!.carreras
    }
    
    
}
