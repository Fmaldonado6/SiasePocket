//
//  ScheduleDetailController.swift
//  siase
//
//  Created by Fernando Maldonado on 21/04/22.
//

import Foundation
import UIKit

class ScheduleDetailControllerLarge:UIViewController{
    
    
    var schedule:Schedule? = nil
    var fullSchedule:ScheduleDetail? = nil
    
    private let viewModel = DIContainer.shared.resolve(type: ScheduleDetailViewModel.self)!
    
    private var stackViewContainer:UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView:UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    private lazy var scheduleDetailView:ScheduleDetailViewLarge = {
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
    
    private let emptyView : EmptyView = {
        let view = EmptyView()
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
    
    private var classesMap = [Int : [ClassDetail]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Horario"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never;
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "sidebar.right"),
            style: .plain,
            target: self,
            action: #selector(toggleDetailView)
        )
        
        setupViews()
        
        viewModel.bindFullScheduleDetail = {scheduleDetail in
            self.scheduleDetailView.setUpSchedule(schedule: scheduleDetail)
            self.fullSchedule = scheduleDetail
        }
        
        viewModel.bindStatus = {status in
            self.changeStatus(status: status)
        }
        
        if(schedule != nil){
            viewModel.getScheduleDetail(schedule: schedule!)
        }
        
        if(fullSchedule != nil){
            viewModel.processResponse(scheduleDetail: fullSchedule!)
        }
        
    }
    

    
    private func setupViews(){
        view.addSubview(loadingSpinnerView)
        view.addSubview(errorView)
        view.addSubview(emptyView)
        view.addSubview(stackViewContainer)
        
        stackViewContainer.addArrangedSubview(scrollView)
        stackViewContainer.addArrangedSubview(detailViewContainer)

        scrollView.addSubview(scheduleDetailView)
        
        errorView.setOnClickListener {
            self.viewModel.getScheduleDetail(schedule: self.schedule!)
        }
        
        
        scheduleDetailView.setOnClassClicked(){ classDetail in
            
            self.classDetailPageController.setClassDetail(classDetail: classDetail)
            
            if(self.isDetailHidden) {self.toggleDetailView()}
        }
        
        NSLayoutConstraint.activate([
            stackViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 5),
            stackViewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackViewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            detailViewContainer.widthAnchor.constraint(equalToConstant: 300),
            
            loadingSpinnerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingSpinnerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            errorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            emptyView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            
            scheduleDetailView.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 15),
            scheduleDetailView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scheduleDetailView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func changeStatus(status:Status){
        print(status)
        scrollView.isHidden = status != Status.Loaded
        loadingSpinnerView.isHidden = status != Status.Loading
        errorView.isHidden = status != Status.Error
        emptyView.isHidden = status != Status.Empty

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
