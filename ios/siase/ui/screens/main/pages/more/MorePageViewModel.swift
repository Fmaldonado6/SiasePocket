//
//  MorePageViewMode;.swift
//  siase
//
//  Created by Fernando Maldonado on 23/04/22.
//

import Foundation


class MorePageViewModel:BaseViewModel{
    
    private let mainCareerRepository:MainCareerRepository
    
     init(
        authRepository: AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!,
        mainCareerRepository:MainCareerRepository = DIContainer.shared.resolve(type: MainCareerRepository.self)!
     ) {
         self.mainCareerRepository = mainCareerRepository
    }
    
    private(set) var mainCareer:Career? = nil
    {
        didSet{
            bindMainCareer(mainCareer)
        }
    }
    
    
    private(set) var mainSchedule:Schedule? = nil
    {
        didSet{
            bindMainSchedule(mainSchedule)
        }
    }

    var bindMainCareer:(Career?)->Void = {career in}
    var bindMainSchedule:(Schedule?)->Void = {schedule in}
    
    func getMainCareer(){
        mainCareer = mainCareerRepository.getMainCareer()
    }
    
    func getMainSchedule(){
        mainSchedule = mainCareerRepository.getMainSchedule()
    }
    
}
