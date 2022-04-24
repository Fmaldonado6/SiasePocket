//
//  ScheduleDetailController.swift
//  siase
//
//  Created by Fernando Maldonado on 21/04/22.
//

import Foundation
import UIKit

class ScheduleDetailController:UIViewController{
    
    
    var schedule:Schedule? = nil
    var scheduleDetail:[[ClassDetail]]? = nil
    var fullSchedule:ScheduleDetail? = nil
    
    private let viewModel = DIContainer.shared.resolve(type: ScheduleDetailViewModel.self)!
    
    private lazy var segmentedControl:UISegmentedControl = {
        let view = UISegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView:UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    private lazy var scheduleDetailView:ScheduleDetailView = {
        let view = ScheduleDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setupParent(parent: self)
        return view
    }()
    
    private let loadingSpinnerView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Horario"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never;
        setupViews()
        
        viewModel.bindSchedule = {scheduleDetail in
            self.scheduleDetail = scheduleDetail
            self.setupSegmentedControl(scheduleDetail: scheduleDetail)
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
    
    private func setupSegmentedControl(scheduleDetail:[[ClassDetail]]){
        
        for (index,detail) in scheduleDetail.enumerated(){
            
            if(detail.isEmpty){
                continue
            }
            
            self.segmentedControl.insertSegment(
                withTitle: DateHelpers.weekDays[index],
                at: index, animated: true
            )
        }
        self.segmentedControl.selectedSegmentIndex = 0
        setupSchedule(index: 0)
    }
    
    private func setupSchedule(index:Int){
        guard let scheduleDetail = scheduleDetail else {
            return
        }

        let detail = scheduleDetail[index]
        self.scheduleDetailView.setupClasses(classes: detail)
    }
    
    private func setupViews(){
        view.addSubview(segmentedControl)
        view.addSubview(loadingSpinnerView)
        view.addSubview(scrollView)

        scrollView.addSubview(scheduleDetailView)
        segmentedControl.addTarget(self, action: #selector(self.segmentAction(_:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            loadingSpinnerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingSpinnerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 5),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,constant: 5),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scheduleDetailView.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 15),
            scheduleDetailView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scheduleDetailView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func changeStatus(status:Status){
        scrollView.isHidden = status != Status.Loaded
        loadingSpinnerView.isHidden = status != Status.Loading
        
        if(status == Status.Loading){
            loadingSpinnerView.startAnimating()
        }
        else{
            loadingSpinnerView.stopAnimating()
        }
        
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        setupSchedule(index: segmentedControl.selectedSegmentIndex)
    }
    
    
}
