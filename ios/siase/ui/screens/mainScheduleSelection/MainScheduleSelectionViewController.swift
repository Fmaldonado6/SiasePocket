//
//  MainScheduleSelectionViewController.swift
//  siase
//
//  Created by Fernando Maldonado on 14/04/22.
//

import Foundation
import UIKit

class MainScheduleSelectionViewController : UIViewController{
    
    var index:Int!
    var career:Career!
    
    private let viewModel:MainScheduleSelectionViewModel! = DIContainer.shared.resolve(type: MainScheduleSelectionViewModel.self)
    
    private var schedules = [Schedule]()
    
    var horizontalSizeClass : UIUserInterfaceSizeClass?
    
    private let loadingSpinnerView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let label:UILabel = {
        let view = UILabel()
        view.text = "Selecciona la carrera que está cursando actualmente"
        view.font = view.font.withSize(14)
        view.textColor = Colors.Light.primaryColor | Colors.Dark.primaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tableView:UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.backgroundColor = .systemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        return view
    }()
    
    
    private let errorView : ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Horarios"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
        
        horizontalSizeClass = self.view.traitCollection.horizontalSizeClass

        
        viewModel.bindStatus = {status in
            //Required since we scheduled notification in background thread
            DispatchQueue.main.async {
                self.changeStatus(status: status)
            }
        }
        
        viewModel.bindSchedule = {schedules in
            //Required since we scheduled notification in background thread
            DispatchQueue.main.async {
                self.schedules = schedules
                self.tableView.reloadData()
            }
            
        }
        
        self.viewModel.getSchedules(career: career)
        
        setupViews()
        
    }
    
    private func setupViews(){
        view.addSubview(tableView)
        view.addSubview(loadingSpinnerView)
        view.addSubview(errorView)
        
        errorView.setOnClickListener {
            self.viewModel.getSchedules(career: self.career)
        }
        
        NSLayoutConstraint.activate([
            loadingSpinnerView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),
            loadingSpinnerView.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            
            errorView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),
            errorView.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func changeStatus(status:Status){
        
        if(status == Status.Completed){
            let vc = self.horizontalSizeClass == .regular ? MainViewControllerSidebar(style: .doubleColumn) : MainViewController()
            self.navigateToTop(screen: vc)
            return
        }
        
        tableView.isHidden = status != Status.Loaded
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

extension MainScheduleSelectionViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identifier, for: indexPath) as! ScheduleCell
        let index = indexPath.row
        cell.configure(index: index, schedule: schedules[index])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setMainSchedule(career: career, schedule: schedules[indexPath.row])
    }
    
    
}
