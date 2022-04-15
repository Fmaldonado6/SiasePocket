//
//  MainCareerSelectionViewModel.swift
//  siase
//
//  Created by Fernando Maldonado on 13/04/22.
//

import Foundation

class MainCareerSelectionViewModel : BaseViewModel{
    
    
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
    
    func selectCareer(){
        
    }

}
