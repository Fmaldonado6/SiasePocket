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
        view.text = "Selecciona tu horario actual"
        view.font = view.font.withSize(14)
        view.textColor = Colors.Light.onPrimaryContainer | Colors.Dark.onPrimaryContainer
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let view = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        view.dataSource = self
        view.register(ScheduleGridCell.self, forCellWithReuseIdentifier: ScheduleGridCell.identifier)
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
                self.collectionView.reloadData()
            }
            
        }
        
        self.viewModel.getSchedules(career: career)
        
        setupViews()
        
    }
    
    private func setupViews(){
        view.addSubview(collectionView)
        view.addSubview(label)
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
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            label.heightAnchor.constraint(equalToConstant: 50),

            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func changeStatus(status:Status){
        
        if(status == Status.Completed){
            let vc = self.horizontalSizeClass == .regular ? MainViewControllerSidebar(style: .doubleColumn) : MainViewController()
            self.navigateToTop(screen: vc)
            return
        }
        
        collectionView.isHidden = status != Status.Loaded
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


extension MainScheduleSelectionViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleGridCell.identifier, for: indexPath) as! ScheduleGridCell
        cell.configure(index: indexPath.row, schedule: self.schedules[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.setMainSchedule(career: career, schedule: schedules[indexPath.row])
    }
    
}

extension MainScheduleSelectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.cellForItem(at: indexPath)?.layoutSubviews()
        return CGSize(width: self.calculateWidth(), height: 100)
    }
    
    private func calculateWidth() -> CGFloat{
        let screenWidth = self.view.frame.size.width

        if(screenWidth < 700) {return screenWidth}
        else if(screenWidth < 1250) {return screenWidth / 2 - 5}
        
        return screenWidth / 3 - 10
    }
    
}
