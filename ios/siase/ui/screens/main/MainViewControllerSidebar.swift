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
    
    private func loadViewControllers() {
        self.primaryViewController = HomePageController()
        let navController = UINavigationController(rootViewController: self.primaryViewController)
        self.primaryBackgroundStyle = .sidebar
        
        sidebar.setMenuItemSelected(listener: {vc in
            self.viewControllers = [self.sidebar, UINavigationController(rootViewController: vc)]

        })
 
        self.viewControllers = [sidebar, navController]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        loadViewControllers()
        
        viewModel.bindCareers = { careers in
            self.sidebar.loadCareers(careers: careers)
        }
        
        viewModel.getCareers()
        
    }

    
}
