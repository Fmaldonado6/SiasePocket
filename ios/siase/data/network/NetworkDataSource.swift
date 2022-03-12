//
//  NetworkDataSource.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import Alamofire
class NetworkDataSource{
    private let urlBase = "https://siaseapi.herokuapp.com/api/"
    private let preferencesService:PreferencesService
    private lazy var token:String? = {
        let preferences = preferencesService.getPreferences()
        return preferences.session?.token
    }()
    
    init(
        preferencesService:PreferencesService =
            DIContainer.shared.resolve(type: PreferencesService.self)!
    ){
        self.preferencesService = preferencesService
    }

    func login(user:String, password:String,completer:@escaping(LoginResponse)->Void){
        let jsonBody = ["user":user,"password":password]
    
        AF.request(urlBase+"user",method: .post,parameters: jsonBody,encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of:LoginResponse.self){response in
                self.interceptor(response: response, completer: completer)
            }
    }
    
    private func interceptor<T : Decodable>(response:DataResponse<T,AFError>, completer:@escaping (T) -> Void){
        switch(response.result){
            case .success(let data):
                completer(data)
        case .failure(let error):
            response.response?.statusCode
        
            
        }
    }
}
