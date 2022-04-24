//
//  ClassDetailPageController.swift
//  siase
//
//  Created by Fernando Maldonado on 23/04/22.
//

import Foundation
import UIKit

class ClassDetailPageController:UIViewController{
    
    var classDetail:ClassDetail!
    
    private lazy var details:[ClassDetailCellModel] = [
        ClassDetailCellModel(
            label: classDetail.horaInicio! + " - " + classDetail.horaFin!,
            subtitle: "Horario"
        ),
        ClassDetailCellModel(
            label: classDetail.modalidad ?? "?",
            subtitle: "Modalidad"
        ),
        ClassDetailCellModel(
            label: classDetail.grupo ?? "?",
            subtitle: "Grupo"
        ),
        ClassDetailCellModel(
            label: classDetail.salon ?? "?",
            subtitle: "Salón"
        ),
        ClassDetailCellModel(
            label: classDetail.claveMateria ?? "?",
            subtitle: "Clave de materia"
        )
    ]
    
    private lazy var tableView:UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        
        view.register(ClassDetailCell.self, forCellReuseIdentifier: ClassDetailCell.identifier)
        return view
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = classDetail.nombre ?? ""
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never;
        setupViews()
    }
    
    private func setupViews(){
        view.addSubview(tableView)
        
        let labelContainer = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: 40
            )
        )
        
        labelContainer.backgroundColor = .systemGroupedBackground
        let label = UILabel(
            frame: CGRect(
                x: 15,
                y: 0,
                width: labelContainer.frame.width - 15,
                height: labelContainer.frame.height
            )
        )
        label.text = "Oportunidad " + (classDetail.oportunidad ?? "?")
        label.font = label.font.withSize(16)
        label.textColor = .systemGray
        labelContainer.addSubview(label)
        
        tableView.tableHeaderView = labelContainer
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -15),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ClassDetailPageController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassDetailCell.identifier) as! ClassDetailCell
        cell.configure(
            index: indexPath.row,
            max: details.count,
            model: details[indexPath.row]
        )
        return cell
        
    }
}
