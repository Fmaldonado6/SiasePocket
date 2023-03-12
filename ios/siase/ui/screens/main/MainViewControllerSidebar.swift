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
    
    private let menuItems = [
        Sidebar.Menuitem(name: "Inicio", iconName: "house", viewController: HomePageControllerLarge()),
        Sidebar.Menuitem(name: "Más", iconName: "ellipsis", viewController: MorePageController())
    ]
    
    private var sidebar = Sidebar()
    private lazy var navController = {
        return UINavigationController(rootViewController: menuItems.first!.viewController)
    }()
    
    
    private func loadViewControllers() {
        self.sidebar.setMenuItems(menuItems: menuItems)
        self.primaryBackgroundStyle = .sidebar

        sidebar.setMenuItemSelected(listener: {vc in
            self.navController.setViewControllers([vc], animated: false)
        })
        
        self.maximumPrimaryColumnWidth = self.view.bounds.size.width;
        
        self.setViewController(self.sidebar, for: .primary)
        self.setViewController(self.navController, for: .secondary)

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewControllers()
        
        self.sidebar.setOnSidebarLoaded {
            self.viewModel.getCareers()
        }
        
        self.sidebar.setCareerOptionSelected{ item in
            if(item.type == SidebarItemType.scheduleRow){
                self.viewModel.getCareerSchedules(sidebarItem: item)
            }
            
            if(item.type == SidebarItemType.kardexRow){
                let vc = KardexPageController()
                vc.career = Career(
                    claveDependencia: item.claveDependencia,
                    claveCarrera: item.claveCarrera
                )
                
                self.navController.setViewControllers([vc], animated: false)

            }
            
        }
        
        self.sidebar.setOnScheduleSelected{ item in
            let vc = ScheduleDetailControllerLarge()
            vc.schedule = Schedule(
                claveDependencia: item.claveDependencia,
                claveCarrera: item.claveCarrera,
                periodo: item.periodo
            )
            
            self.navController.setViewControllers([vc], animated: false)
        }
        
        
        
        viewModel.bindCareerSchedule = { item, schedules in
            
            let scheduleSidebarItems = schedules.map { schedule in
                return SidebarItem.scheduleOptionRow(
                    title: schedule.nombre ?? "",
                    image: UIImage(systemName:"clock"),
                    claveCarrera: schedule.claveCarrera,
                    claveDependencia: schedule.claveDependencia,
                    periodo: schedule.periodo
                )
            }
            self.sidebar.appendToCareerSection(sideBarItems: scheduleSidebarItems, to: item,replace: true)
        }
        
        viewModel.bindCareers = { careers in
            self.sidebar.loadCareers(careers: careers)
        }
        
        
    }
    
    
}

