//
//  CareersPageController.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

enum SettingsSectionKeys:Int{
    case MainCareer = 0
    case MainSchedule
    case SignOut
}

enum AbutAppSectionKeys{
    case Developer
    case Designer
    case AppName
    case Version
    case SourceCode
}

class MorePageController : UIViewController{
    
    private let viewModel = DIContainer.shared.resolve(type: MorePageViewModel.self)!
    
    private lazy var tableView:UITableView = {
        let view = UITableView()
        view.backgroundColor = .systemGroupedBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = .none
        
        view.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        return view
    }()
    
    private lazy var settings:[SettingsSection] = [
        SettingsSection(
            label: "Configuración",
            settings: [
                SettingsModel(
                    label: "Cambiar Carrera Principal",
                    icon: "graduationcap",
                    subtitle: "",
                    action: {
                        let vc = MainCareerSelectionController()
                        vc.modalPresentationStyle = .fullScreen
                        self.tabBarController?.tabBar.isHidden = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                ),
                SettingsModel(
                    label: "Cambiar Horario Principal",
                    icon: "clock",
                    subtitle: "",
                    action: {
                        let vc = MainScheduleSelectionViewController()
                        vc.career = self.viewModel.mainCareer
                        vc.modalPresentationStyle = .fullScreen
                        self.tabBarController?.tabBar.isHidden = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                ),
                SettingsModel(
                    label: "Cerrar Sesión",
                    icon: "power",
                    subtitle: "Cierra la sesión actual",
                    action: {
                        
                    }
                ),
            ]
        ),
        SettingsSection(
            label: "Acerca de la app",
            settings: [
                SettingsModel(
                    label: "Desarrollador",
                    icon: "person",
                    subtitle: "Fernando Maldonado",
                    action: {
                        
                    }
                ),
                SettingsModel(
                    label: "Diseñador del ícono",
                    icon: "person",
                    subtitle: "David Lázaro",
                    action: {
                        
                    }
                ),
                SettingsModel(
                    label: "Nombre de la app",
                    icon: "person",
                    subtitle: "Kevin Villalobos",
                    action: {
                        
                    }
                ),
                SettingsModel(
                    label: "Versión",
                    icon: "esim",
                    subtitle: "1.5.1",
                    action: {}
                ),
                SettingsModel(
                    label: "Código Fuente",
                    icon: "chevron.left.forwardslash.chevron.right",
                    subtitle: "Github",
                    action: {}
                ),
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Siase Pocket"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
        setupViews()
        
        viewModel.bindMainCareer = {career in
            if let career = career  {
                let name = career.nombre?.split(separator: "-").last?.capitalized
                self.settings[0]
                    .settings[SettingsSectionKeys.MainCareer.rawValue]
                    .subtitle = name!
                
            }
        }
        
        viewModel.bindMainSchedule = {schedule in
            if let schedule = schedule  {
                self.settings[0]
                    .settings[SettingsSectionKeys.MainSchedule.rawValue]
                    .subtitle = schedule.nombre!
            }
        }
        viewModel.getMainCareer()
        viewModel.getMainSchedule()
    }
    
    private func setupViews(){
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -15),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}


extension MorePageController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].settings.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: tableView.frame.width,
                height: 50
            )
        )
        
        view.backgroundColor = .systemGroupedBackground
        let label = UILabel(
            frame: CGRect(
                x: 15,
                y: 0,
                width: view.frame.width - 15,
                height: view.frame.height
            )
        )
        
        label.text = settings[section].label
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Colors.Light.secondary | Colors.Dark.secondary
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier) as! SettingsCell
        cell.configure(
            index: indexPath.row,
            max: settings[indexPath.section].settings.count,
            model: settings[indexPath.section].settings[indexPath.row]
        )
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settings[indexPath.section].settings[indexPath.row].action()
    }
    
    
}
