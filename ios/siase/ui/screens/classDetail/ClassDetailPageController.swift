//
//  ClassDetailPageController.swift
//  siase
//
//  Created by Fernando Maldonado on 23/04/22.
//

import Foundation
import UIKit

class ClassDetailPageController:UIViewController{
    
    private var classDetail:ClassDetail?
    
    private var details:[ClassDetailCellModel] = []
    
    private func getDetails() -> [ClassDetailCellModel]{
        
        if(classDetail == nil){
            return []
        }
        
        return [
            ClassDetailCellModel(
                label: classDetail!.horaInicio! + " - " + classDetail!.horaFin!,
                subtitle: "Horario"
            ),
            ClassDetailCellModel(
                label: classDetail!.modalidad ?? "?",
                subtitle: "Modalidad"
            ),
            ClassDetailCellModel(
                label: classDetail!.grupo ?? "?",
                subtitle: "Grupo"
            ),
            ClassDetailCellModel(
                label: classDetail!.salon ?? "?",
                subtitle: "Salón"
            ),
            ClassDetailCellModel(
                label: classDetail!.claveMateria ?? "?",
                subtitle: "Clave de materia"
            )
        ]
    }
    
    private var emptyText = {
        let view = UILabel()
        view.font = view.font.withSize(16)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "Selecione una clase para ver su información"
        return view
    }()
    
    private lazy var tableView:UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.separatorStyle = .none
        view.dataSource = self
        view.register(ClassDetailCell.self, forCellReuseIdentifier: ClassDetailCell.identifier)
        return view
    }()
    
    private var opportunityLabel = {
        let view = UILabel()
        view.font = view.font.withSize(16)
        view.textColor = .systemGray
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = classDetail?.nombre ?? ""
        
        navigationItem.largeTitleDisplayMode = .never;
        setupViews()
    }
    
    func setClassDetail(classDetail:ClassDetail){
        self.classDetail = classDetail
        navigationItem.title = classDetail.nombre ?? ""
        details = details.map{it in it}
        self.details = self.getDetails()
        opportunityLabel.text = "Oportunidad " + (classDetail.oportunidad ?? "?")
        emptyText.isHidden = true
        self.tableView.reloadData()
    }
    
    private func setupViews(){
        view.addSubview(tableView)
        view.addSubview(emptyText)

        let labelContainer = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: 40
            )
        )
        
        labelContainer.backgroundColor = .systemGroupedBackground
        opportunityLabel = UILabel(
            frame: CGRect(
                x: 15,
                y: 0,
                width: labelContainer.frame.width - 15,
                height: labelContainer.frame.height
            )
        )
        labelContainer.addSubview(opportunityLabel)
        
        tableView.tableHeaderView = labelContainer
        
        NSLayoutConstraint.activate([
            emptyText.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,constant:-50),
            emptyText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 15),
            emptyText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -15),

            
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
