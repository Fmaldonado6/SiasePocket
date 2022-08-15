//
//  MainViewController.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

class HomePageController : UIViewController{
    
    private let viewModel:HomePageVieModel = DIContainer.shared.resolve(type: HomePageVieModel.self)!
    
    
    private lazy var  scrollView:UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nextClassView:NextClassView = {
        let view = NextClassView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var todaysClassesView:TodayClassesView = {
        let view = TodayClassesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setupClassViewParent(parent: self)
        return view
    }()
    
    private let loadingSpinnerView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    
    private let errorView : ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = viewModel.currentSession.nombre.split(separator: " ").first ?? ""
        
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "¡Hola, " + name + "!"
        tabBarItem.title = "inicio"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
        
        
        viewModel.bindTodaySchedule = { classes in
            guard let todayClasses = classes else { return}
            self.todaysClassesView.setupClasses(classes: todayClasses)
        }
        
        viewModel.bindStatus = {status in
            self.changeStatus(status: status)
        }
        
        viewModel.bindNextClass = { nextClass in
            self.nextClassView.setupNextClass(nextClass: nextClass)
        }
        
        viewModel.getTodaySchedule()
        
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupViews(){
        view.addSubview(scrollView)
        view.addSubview(loadingSpinnerView)
        view.addSubview(errorView)
        scrollView.addSubview(nextClassView)
        scrollView.addSubview(todaysClassesView)
        
        todaysClassesView.fullScheduleButtonClickListener {
            let vc = ScheduleDetailController()
            vc.fullSchedule = self.viewModel.getFullSchedule()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
        
        nextClassView.setNextClassClickListener(){classDetail in
            let vc = ClassDetailPageController()
            let nav = UINavigationController(rootViewController: vc)
            vc.classDetail = classDetail
            #if targetEnvironment(macCatalyst)
                print("Not available")
            #else
                if let sheet = nav.sheetPresentationController{
                    sheet.detents = [.medium(),.large()]
                }
                self.navigationController?.present(nav, animated: true, completion: nil)
            #endif
        }

        
        errorView.setOnClickListener {
            self.viewModel.getTodaySchedule()
        }
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            nextClassView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            nextClassView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            todaysClassesView.topAnchor.constraint(equalTo: nextClassView.bottomAnchor),
            todaysClassesView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            todaysClassesView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            loadingSpinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingSpinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
    }
    
    private func changeStatus(status:Status){
        scrollView.isHidden = status != Status.Loaded
        loadingSpinnerView.isHidden = status != Status.Loading
        errorView.isHidden = status != Status.Error
        
        if(status == Status.Loading){
            loadingSpinnerView.startAnimating()
        }
        else{
            loadingSpinnerView.stopAnimating()
        }
        
    }
    
    
}
