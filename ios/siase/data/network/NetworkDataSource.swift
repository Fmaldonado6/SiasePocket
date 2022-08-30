//
//  NetworkDataSource.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import Alamofire
class NetworkDataSource{
    private let urlBase = "https://siase-api.azurewebsites.net/api/"
    private let preferencesService:PreferencesService
    private var token:String?
    {
        get{
            let preferences = preferencesService.getPreferences()
            return preferences.session?.token
        }
    }
    
    init(
        preferencesService:PreferencesService =
        DIContainer.shared.resolve(type: PreferencesService.self)!
    ){
        self.preferencesService = preferencesService
    }
    
    func login(user:String, password:String,completer:@escaping(LoginResponse?,AppError?)->Void){
        let jsonBody = ["user":user,"password":password]
        
        AF.request(urlBase+"user",method: .post,parameters: jsonBody,encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of:LoginResponse.self){response in
                self.interceptor(response: response, completer: completer)
            }
    }
    
    func getSchedules(index:Int,completer:@escaping([Schedule]?,AppError?)->Void){
        AF.request(urlBase+"schedules/"+String(index),method: .get,headers: getHeaders())
            .responseDecodable(of:[Schedule].self){ response in
                self.interceptor(response: response, completer: completer)
            }
    }
    
    func getScheduleDetail(
        index:Int,
        periodo:String,
        completer:@escaping(ScheduleDetail?,AppError?)->Void
    ){
        AF.request(urlBase+"schedules/"+String(index)+"/"+periodo,method: .get,headers: getHeaders())
            .responseDecodable(of:ScheduleDetail.self){ response in
                self.interceptor(response: response, completer: completer)
            }
        
    }
    
    func gerKardex(
        index:Int,
        completer:@escaping(Kardex?,AppError?)->Void
    ){
        AF.request(urlBase+"kardex/"+String(index),method: .get,headers: getHeaders())
            .responseDecodable(of:Kardex.self){ response in
                self.interceptor(response: response, completer: completer)
            }
    }
    
    func getHeaders()->HTTPHeaders{
        var headers = HTTPHeaders.default
        guard let savedToken = token else {return headers}
        headers.add(HTTPHeader(name: "Authorization", value: "Bearer: "+savedToken))
        return headers
    }
    
    private func interceptor<T : Decodable>(response:DataResponse<T,AFError>, completer:@escaping (T?,AppError?) -> Void){
        switch(response.result){
        case .success(let data):
            completer(data,nil)
        case .failure(_):
            let code  = response.response?.statusCode
            
            if(code == 400){
                return completer(nil,BadInput(message:response.error?.errorDescription ?? ""))
            }
            
            if(code == 404){
                return completer(nil,NotFoundError(message:response.error?.errorDescription ?? ""))
            }
            
            if(code == 501 || code == 401){
                return completer(nil, Unauthorized(message:response.error?.errorDescription ?? ""))
            }
            
            return completer(nil,AppError(message:response.error?.errorDescription ?? ""))
            
        }
    }
}
