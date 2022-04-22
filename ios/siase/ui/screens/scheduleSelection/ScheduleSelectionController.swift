//
//  ScheduleSelectionController.swift
//  siase
//
//  Created by Fernando Maldonado on 21/04/22.
//

import Foundation
import UIKit

class ScheduleSelectionController:BottomSheet{
    
    
    
    private let viewModel:ScheduleSelectionViewModel = DIContainer.shared.resolve(type: ScheduleSelectionViewModel.self)!
    
    private var isAtTop = true
    private var canDismiss = true

    private lazy var tableView :UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private let header :UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = view.font.withSize(18)
        view.text = "Horarios"
        return view
    }()
    
    private let loadingSpinnerView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    
    private var schedules:[Schedule] = [Schedule]()
    var index:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.bindSchedule = { schedules in
            self.schedules = schedules
            self.tableView.reloadData()
            
        }
        
        viewModel.bindStatus = {status in
            self.changeStatus(status: status)
        }
        
        viewModel.getSchedules(index: index)
        
        setupViews()
    }
    
    private func setupViews(){
        self.maximumContainerHeight = 300
        
        containerView.addSubview(loadingSpinnerView)
        containerView.addSubview(header)
        containerView.addSubview(tableView)
        
        
        
        
        NSLayoutConstraint.activate([
            
            loadingSpinnerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            loadingSpinnerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            
            header.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 20),
            header.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 20),
            header.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20),
            
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor,constant: 20),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
    }
    
    private func changeStatus(status:Status){
        
        tableView.isHidden = status != Status.Loaded
        loadingSpinnerView.isHidden = status != Status.Loading
        
        if(status == Status.Loading){
            loadingSpinnerView.startAnimating()
        }
       else{
            loadingSpinnerView.stopAnimating()
        }

    }
    
    override func handlePanGesture(gesture: UIPanGestureRecognizer) {
        
        if(!canDismiss){
            return
        }
        
        super.handlePanGesture(gesture: gesture)
    }
    
    
}

extension ScheduleSelectionController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if(!isAtTop){
            canDismiss = false
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        canDismiss = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isAtTop = scrollView.contentOffset.y <= 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScheduleDetailController()
        let navController = presentingViewController as? UINavigationController
        vc.schedule = schedules[indexPath.row]
        navController?.pushViewController(vc, animated: true)
        self.animateDismissView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        
        let schedule = schedules[indexPath.row]
        
        config.text = schedule.nombre
        config.textProperties.font = config.textProperties.font.withSize(15)
        let imageConfiguration:UIImage.Configuration = UIImage.SymbolConfiguration(scale: .small)
        config.image = UIImage(systemName: "clock",withConfiguration: imageConfiguration)
        config.image?.withTintColor(Colors.Light.secondary | Colors.Dark.secondary)
        cell.contentConfiguration = config
        return cell
    }
    
}
