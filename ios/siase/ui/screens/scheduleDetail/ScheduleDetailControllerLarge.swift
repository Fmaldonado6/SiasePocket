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
    
    private var classesMap = [Int : [ClassDetail]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Horario"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never;
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
        view.addSubview(scrollView)

        scrollView.addSubview(scheduleDetailView)
        
        errorView.setOnClickListener {
            self.viewModel.getScheduleDetail(schedule: self.schedule!)
        }
        
        NSLayoutConstraint.activate([
            loadingSpinnerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingSpinnerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            errorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            emptyView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
          
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 5),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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

    
}
