//
//  Exceptions.swift
//  siase
//
//  Created by Fernando Maldonado on 01/03/22.
//

import Foundation

class AppError : Error{
    
}

class BadInput : AppError{
    
}

class Unauthorized : AppError{
    
}

class EmptySearch : AppError{
    
}

class NotFoundError : AppError{
    
}
