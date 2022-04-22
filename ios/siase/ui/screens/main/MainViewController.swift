//
//  MainViewController.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

class MainViewController : UITabBarController{
    
    
 
    private let homePage:UINavigationController = {
        let homePage = HomePageController()
        let imageConfiguration:UIImage.Configuration = UIImage.SymbolConfiguration(scale: .medium)
        let navController = UINavigationController(rootViewController: homePage)
        navController.tabBarItem.title = "Inicio"
        navController.tabBarItem.image = UIImage(systemName: "house",withConfiguration: imageConfiguration)
        return navController
    }()
    
    private let careersPage:UINavigationController = {
        let careersPage = CareersPageController()
        let imageConfiguration:UIImage.Configuration = UIImage.SymbolConfiguration(scale: .medium)
        let navController = UINavigationController(rootViewController: careersPage)
        navController.tabBarItem.title = "Carreras"
        navController.tabBarItem.image = UIImage(systemName: "graduationcap",withConfiguration: imageConfiguration)
        return navController
    }()
    
    private let morePage:UINavigationController = {
        let morePage = MorePageController()
        let imageConfiguration:UIImage.Configuration = UIImage.SymbolConfiguration(scale: .medium)
        let navController = UINavigationController(rootViewController: morePage)
        navController.tabBarItem.title = "Más"
        
        navController.tabBarItem.image = UIImage(systemName: "ellipsis",withConfiguration: imageConfiguration)
        return navController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = Colors.Light.secondary | Colors.Dark.secondary
        viewControllers = [homePage,careersPage,morePage]
        
    }
 
}
