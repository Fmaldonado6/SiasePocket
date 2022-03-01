//
//  DIContainer.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation

protocol DIContainerProtocol {
  func register<Component>(type: Component.Type, component: Any)
  func resolve<Component>(type: Component.Type) -> Component?
}

final class DIContainer: DIContainerProtocol {
  
  static let shared = DIContainer()
  
  
  private init() {}

  
  var components: [String: Any] = [:]

  func register<Component>(type: Component.Type, component: Any) {
    components["\(type)"] = component
  }

  func resolve<Component>(type: Component.Type) -> Component? {
    return components["\(type)"] as? Component
  }
}
