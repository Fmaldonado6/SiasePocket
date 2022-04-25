//
//  MainCareerSelectionController.swift
//  siase
//
//  Created by Fernando Maldonado on 11/03/22.
//

import Foundation
import UIKit

class MainCareerSelectionController : UIViewController{
    
    private let viewModel:MainCareerSelectionViewModel = DIContainer
        .shared.resolve(type: MainCareerSelectionViewModel.self)!
    
    
    
    private let label:UILabel = {
        let view = UILabel()
        view.text = "Selecciona la carrera que está cursando actualmente"
        view.font = view.font.withSize(14)
        view.textColor = Colors.Light.onPrimaryContainer | Colors.Dark.onPrimaryContainer
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var tableView:UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.backgroundColor = .systemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.register(CareerCell.self, forCellReuseIdentifier: CareerCell.identifier)
        return view
    }()
    
    private var careers:[Career] = [Career]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Carreras"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
        viewModel.bindCareers = {careers in
            self.careers = careers
            self.tableView.reloadData()
        }
        
        viewModel.getCareers()

        
        setupViews()

    }
    
    func setupViews(){

        view.addSubview(tableView)
        
        tableView.tableHeaderView = label
        
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: tableView.topAnchor),
            label.leadingAnchor.constraint(equalTo: tableView.leadingAnchor,constant: 20),
            label.trailingAnchor.constraint(equalTo: tableView.trailingAnchor,constant: -20),
            label.heightAnchor.constraint(equalToConstant: 50),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.tableHeaderView = self.tableView.tableHeaderView
    }
    
}

extension MainCareerSelectionController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return careers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CareerCell.identifier, for: indexPath) as! CareerCell
        cell.configure(index: indexPath.row, career: self.careers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MainScheduleSelectionViewController()
        vc.index = indexPath.row
        vc.career = careers[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
