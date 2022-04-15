//
//  MainCareerRepository.swift
//  siase
//
//  Created by Fernando Maldonado on 11/03/22.
//

import Foundation


class MainCareerRepository{
    
    private let mainScheduleDao:MainScheduleDao
    private let mainCareerDao:MainCareerDao
    private let networkDataSource:NetworkDataSource
    private let authRepository:AuthRepository
    
    init(
        mainScheduleDao:MainScheduleDao = DIContainer.shared.resolve(type: MainScheduleDao.self)!,
        mainCareerDao:MainCareerDao = DIContainer.shared.resolve(type: MainCareerDao.self)!,
        networkDataSouce:NetworkDataSource = DIContainer.shared.resolve(type: NetworkDataSource.self)!,
        authRepository:AuthRepository = DIContainer.shared.resolve(type: AuthRepository.self)!
    ){
        self.mainCareerDao = mainCareerDao
        self.authRepository = authRepository
        self.mainScheduleDao = mainScheduleDao
        self.networkDataSource = networkDataSouce
    }
    
    func getMainCareer()->Career?{
        try? mainCareerDao.getMainCareer()
    }
    
    func getMainSchedule()->Schedule?{
        try? mainScheduleDao.getMainSchedule()
    }
    
    
}
