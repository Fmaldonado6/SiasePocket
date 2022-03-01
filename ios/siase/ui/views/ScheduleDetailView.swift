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
        
        return view
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addArrangedSubview(hoursView)
        self.addArrangedSubview(classesView)
        self.axis = .horizontal
        setupHours()
        setupDividers()
        
    }
    
    private func setupHours(){
        var i = 7.0
        while i  < 22.0{
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
        for i in 0...29{
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
    
    required init(coder: NSCoder) {
        fatalError("Not implementef")
    }
}
