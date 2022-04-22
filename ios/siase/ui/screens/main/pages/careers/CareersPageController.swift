//
//  CareersPageController.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

class CareersPageController : UIViewController{
    
    private let viewModel:CareersPageViewModel = DIContainer.shared.resolve(type: CareersPageViewModel.self)!
    
    private lazy var tableView:UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.register(CareerCell.self, forCellReuseIdentifier: CareerCell.identifier)
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private var careers:[Career] = [Career]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Carreras"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
        
        setupViews()
        
        viewModel.bindCareers = { careers in
            self.careers = careers
            self.tableView.reloadData()
        }
        
        viewModel.getCareers()
    }
    
    private func setupViews(){
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

extension CareersPageController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return careers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CareerCell.identifier, for: indexPath) as! CareerCell
        cell.configure(index: indexPath.row, career: self.careers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CareerDetailPageController()
        vc.career = careers[indexPath.row]
        vc.index = indexPath.row
        vc.modalPresentationStyle = .fullScreen
        self.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
