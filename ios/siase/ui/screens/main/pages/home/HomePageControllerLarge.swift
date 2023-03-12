//
//  MainViewController.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

class HomePageControllerLarge : UIViewController{
    
    private let viewModel:HomePageVieModel = DIContainer.shared.resolve(type: HomePageVieModel.self)!
    
    private var stackViewContainer:UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
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
    
    
    private lazy var todaysClassesView:ScheduleDetailViewLarge = {
        let view = ScheduleDetailViewLarge()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let classDetailPageController = ClassDetailPageController()
    
    private lazy var detailViewContainer : DetailViewContainer<UINavigationController> = {
        let view = DetailViewContainer<UINavigationController>()
        let navController = UINavigationController(rootViewController: self.classDetailPageController)
        view.setView(view: navController)
        view.alpha = 0
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isDetailHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = viewModel.currentSession.nombre.split(separator: " ").first ?? ""
        
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "¡Hola, " + name + "!"
        tabBarItem.title = "inicio"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "sidebar.right"),
            style: .plain,
            target: self,
            action: #selector(toggleDetailView)
        )
        
        
        viewModel.bindTodaySchedule = { classes in
            guard let todayClasses = classes else { return}
            guard let fullSchedule = self.viewModel.getFullSchedule() else {return}
            self.todaysClassesView.setUpSchedule(schedule: fullSchedule)
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
        view.addSubview(stackViewContainer)
        view.addSubview(loadingSpinnerView)
        view.addSubview(errorView)
        
        stackViewContainer.addArrangedSubview(scrollView)
        stackViewContainer.addArrangedSubview(detailViewContainer)
        
        scrollView.addSubview(nextClassView)
        scrollView.addSubview(todaysClassesView)
        
        nextClassView.setNextClassClickListener(){classDetail in
            self.classDetailPageController.setClassDetail(classDetail: classDetail)
            if(self.isDetailHidden) {self.toggleDetailView()}

        }
        
        self.todaysClassesView.setOnClassClicked(){ classDetail in
            
            self.classDetailPageController.setClassDetail(classDetail: classDetail)
            
            if(self.isDetailHidden) {self.toggleDetailView()}
        }
        
        
        errorView.setOnClickListener {
            self.viewModel.getTodaySchedule()
        }
        
        
        NSLayoutConstraint.activate([
            stackViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackViewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackViewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            detailViewContainer.widthAnchor.constraint(equalToConstant: 300),
            
            nextClassView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            nextClassView.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor, multiplier: 0.5),
            
            
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
    
    @objc private func toggleDetailView(){

        self.isDetailHidden = !self.isDetailHidden
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: .transitionCrossDissolve,
            animations: {
                self.stackViewContainer.layoutIfNeeded()
                self.detailViewContainer.isHidden.toggle()
                self.detailViewContainer.alpha = self.isDetailHidden ? 0 : 1
                self.stackViewContainer.layoutIfNeeded()

            })
        
    }
    
    
}
