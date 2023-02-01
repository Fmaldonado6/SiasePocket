//
//  ScheduleDetailView.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

class ScheduleDetailView:UIStackView{
    
    private let hourHeight = 78.0
    
    private let hoursView:UIStackView = {
       let view = UIStackView()
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.axis = .vertical
        return view
    }()
    
    private let classesView:UIView = {
       let view = UIView()
        view.frame = view.frame.inset(by: UIEdgeInsets(top: 15.0, left: .zero, bottom: .zero, right: .zero))

        return view
    }()
    
    private weak var parent:UIViewController!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        self.axis = .horizontal
        self.addArrangedSubview(hoursView)
        self.addArrangedSubview(classesView)
        rebuild()
        
    }
    
    func setupParent(parent:UIViewController){
        self.parent = parent
    }
    
    private func setupHours(){
        var i = 7.0
        while i  < 22.5{
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            var dayOrNight = "a.m."
            var realHour = Int(i)

           if (i > 12.5) {
               realHour -= 12
               dayOrNight = "p.m."
           }

            let hour = i.remainder(dividingBy: 1) != 0.0 ? "\(realHour):30 \(dayOrNight)" : "\(realHour):00 \(dayOrNight)"
                            
            label.text = hour
            label.font = label.font.withSize(14)
            label.textAlignment = .center
            
            NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: hourHeight),
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.widthAnchor.constraint(equalTo:container.widthAnchor)
            ])
            
            hoursView.addArrangedSubview(container)
            i += 0.5
        }
    }
    
    private func setupDividers(){
        for i in 0...30{
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            let divider = UILabel()
            divider.translatesAutoresizingMaskIntoConstraints = false
            
            container.addSubview(divider)
            divider.backgroundColor = .systemGray5
            classesView.addSubview(container)

            NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: hourHeight),
                container.widthAnchor.constraint(equalTo: classesView.widthAnchor),
                container.topAnchor.constraint(equalTo: classesView.topAnchor, constant: hourHeight * Double(i)),
                divider.topAnchor.constraint(equalTo: container.topAnchor,constant: 10),
                divider.widthAnchor.constraint(equalTo:container.widthAnchor),
                divider.heightAnchor.constraint(equalToConstant: 1)
            ])
            
        }
    }
    
    private func rebuild(){
        for subView in hoursView.subviews as [UIView] {
            subView.removeFromSuperview()
        }
        
        for subView in classesView.subviews as [UIView] {
            subView.removeFromSuperview()
        }
        
        setupHours()
        setupDividers()
    }

    
    func setupClasses(classes:[ClassDetail]){
        rebuild()
        let realHourHeight = hourHeight * 2
        let initialTimeDate = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        let initialTime = Calendar.current.dateComponents([.hour,.minute], from: initialTimeDate)
        for classDetail in classes{
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            let classView = ClassView()
            classView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(classView)
            classesView.addSubview(container)

            let startTime = Date.parseTime(time:classDetail.horaInicio!)
            let endTime = Date.parseTime(time:classDetail.horaFin!)
            
            let minuteDifference = Calendar.current.dateComponents([.minute], from: initialTime, to: startTime).minute!
            let duration = Calendar.current.dateComponents([.minute], from: startTime,to: endTime).minute!
            
            let margin = (Double(minuteDifference) / 60.0) * realHourHeight
            let height = (Double(duration) / 60.0) * realHourHeight
            
            classView.setClassName(text: classDetail.nombre ?? "")
            classView.setTimeName(text: classDetail.horaInicio! + " - " + classDetail.horaFin!)
            
            classView.setClickListener {
                let vc = ClassDetailPageController()
                let nav = UINavigationController(rootViewController: vc)
                vc.classDetail = classDetail
                
                #if targetEnvironment(macCatalyst)
                    print("Not available")
                #else
                if let sheet = nav.sheetPresentationController{
                    sheet.detents = [.medium(),.large()]
                }
                self.parent.navigationController?.present(nav, animated: true, completion: nil)
                #endif
            }

            classView.backgroundColor = Colors.Light.surfaceCardVariant | Colors.Dark.surfaceCardVariant
            NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: height),
                container.widthAnchor.constraint(equalTo: classesView.widthAnchor),
                container.topAnchor.constraint(equalTo: classesView.topAnchor, constant:margin),
                
                classView.topAnchor.constraint(equalTo: container.topAnchor,constant: 20),
                classView.leadingAnchor.constraint(equalTo:container.leadingAnchor,constant: 10),
                classView.trailingAnchor.constraint(equalTo:container.trailingAnchor,constant: -10),
                classView.heightAnchor.constraint(equalToConstant: height-20),

            ])
            
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("Not implementef")
    }
}
