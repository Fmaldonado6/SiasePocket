//
//  MainViewControllerSidebar.swift
//  siase
//
//  Created by Fernando Maldonado on 26/07/22.
//

import Foundation
import UIKit


@available(iOS 14, *)
class MainViewControllerSidebar : UISplitViewController,UISplitViewControllerDelegate {
    
    private let viewModel:MainSidebarViewModel = DIContainer.shared.resolve(type: MainSidebarViewModel.self)!

    private var primaryViewController: HomePageController!
    
    private var sidebar = Sidebar()
    
    private var currentVC:UIViewController!
    
    private func loadViewControllers() {
        self.primaryViewController = HomePageController()
        self.currentVC = self.primaryViewController
        var navController = UINavigationController(rootViewController: self.primaryViewController)
        self.primaryBackgroundStyle = .sidebar
        
        sidebar.setMenuItemSelected(listener: {vc in
            if(vc == self.currentVC) {
                return
                
            }
            self.currentVC = vc
            navController.setViewControllers([vc], animated: false)

        })
        
        
        self.setViewController(self.sidebar, for: .primary)
        self.setViewController(navController, for: .secondary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        loadViewControllers()
        
        self.sidebar.setOnSidebarLoaded {
            self.viewModel.getCareers()
        }
            
        
        
        viewModel.bindCareers = { careers in
            self.sidebar.loadCareers(careers: careers)
        }
        
        
    }

    
}
