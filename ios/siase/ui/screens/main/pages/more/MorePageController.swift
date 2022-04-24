//
//  CareersPageController.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

enum SettingsSections:Int{
    case  Settings = 0
    case About
}

enum SettingsSectionKeys:Int{
    case MainCareer = 0
    case MainSchedule
    case SignOut
}

enum AboutAppSectionKeys:Int{
    case Developer = 0
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
                    label: "Calendarizar notificaciones",
                    icon: "bell",
                    subtitle: "Se vuelven a calendarizar las notificaciones",
                    action: {
                        self.viewModel.activateNotifications()
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
                        self.openUrl(url: "https://twitter.com/Fmaldonado4202")
                    }
                ),
                SettingsModel(
                    label: "Diseñador del ícono",
                    icon: "person",
                    subtitle: "David Lázaro",
                    action: {
                        self.openUrl(url: "https://twitter.com/DavidLazaroFern")
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
                    action: {
                        self.openUrl(url: "https://github.com/Fmaldonado6/SiasePocket")
                    }
                ),
            ]
        )
    ]
    
    private func openUrl(url:String){
        UIApplication.shared.open(
            NSURL(string:url)! as URL,
            options: [.universalLinksOnly: false],
            completionHandler: nil
        )
    }
    
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
        
        viewModel.bindNotificationsDone = {done in
            
            DispatchQueue.main.async {
                guard let done = done else{
                    return
                }
                
                let alert = UIAlertController()
                
                
                if(!done) {
                    alert.title = "Ocurrió un error"
                    alert.message = "Ocurrió un error al calendarizar las notificaciones"
                }else{
                    alert.title = "Notificaciones Calendarizadas"
                    alert.message = "Las notificaciones se han calendarizado correctamente"
                }
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
        viewModel.bindMainSchedule = {schedule in
            if let schedule = schedule  {
                self.settings[0]
                    .settings[SettingsSectionKeys.MainSchedule.rawValue]
                    .subtitle = schedule.nombre!
            }
        }
        
        self.settings[SettingsSections.About.rawValue]
            .settings[AboutAppSectionKeys.Version.rawValue]
            .subtitle = UIApplication.appVersion()
        
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
