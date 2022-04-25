//
//  KardexPageController.swift
//  siase
//
//  Created by Fernando Maldonado on 22/04/22.
//

import Foundation
import UIKit

class KardexPageController : UIViewController{
    
    var career:Career!
    
    private let viewModel = DIContainer.shared.resolve(type: KardexPageViewModel.self)!
    
    private lazy var segmentedControl:NoSwipeSegmentedControl = {
        let view = NoSwipeSegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let segmentedContainer:UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    private lazy var tableView:UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.delegate = self
        view.dataSource = self
        view.register(SubjectCell.self, forCellReuseIdentifier: SubjectCell.identifier)
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
    
    private var subjects:[[Subject]] = [[Subject]]()
    private var currentSemester:[Subject] = [Subject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Kárdex"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never;
        setupViews()
        
        viewModel.bindSubjects = {subjects in
            self.subjects = subjects
            self.currentSemester = subjects[0]
            self.tableView.reloadData()
            self.setupSegmentedControl()
        }
        
        viewModel.bindStatus = {status in
            self.changeStatus(status: status)
        }
        
        viewModel.getkardex(career: career)
    }
    
    private func setupSegmentedControl(){
        
        for (index,semester) in subjects.enumerated(){
            segmentedControl.insertSegment(
                withTitle: "Semestre \(semester.first!.semestreMateria ?? "")",
                at: index, animated: true
            )
        }
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func setupViews(){
        view.addSubview(segmentedContainer)
        view.addSubview(loadingSpinnerView)
        view.addSubview(errorView)
        view.addSubview(tableView)
        
        segmentedContainer.addSubview(segmentedControl)
        
        segmentedControl.addTarget(self, action: #selector(self.segmentAction(_:)), for: .valueChanged)
        
        errorView.setOnClickListener {
            self.viewModel.getkardex(career: self.career)
        }
        
        NSLayoutConstraint.activate([
            loadingSpinnerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingSpinnerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            errorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            segmentedContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            segmentedContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            segmentedContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedContainer.heightAnchor.constraint(equalToConstant: 40),
            
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedContainer.leadingAnchor,constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedContainer.trailingAnchor,constant: -20),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedContainer.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: segmentedContainer.bottomAnchor,constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    private func changeStatus(status:Status){
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
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        self.currentSemester = subjects[segmentedControl.selectedSegmentIndex]
        tableView.reloadData()
    }
    
}

extension KardexPageController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSemester.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubjectCell.identifier) as! SubjectCell
        cell.configure(index: indexPath.row, subject: currentSemester[indexPath.row])
        return cell
    }
    
    
}
