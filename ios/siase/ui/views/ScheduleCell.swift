//
//  ScheduleCell.swift
//  siase
//
//  Created by Fernando Maldonado on 15/04/22.
//

import Foundation
import UIKit

class ScheduleCell : UITableViewCell{
    
    static let identifier = "ScheduleCell"
    
    private let scheduleView:ScheduleView = {
        let view = ScheduleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private var index:Int = 0
    
    func configure(index:Int,schedule:Schedule){
        addSubview(scheduleView)
        
        self.scheduleView.setScheduletext(text: schedule.nombre ?? "")

        self.backgroundColor = .systemGroupedBackground
        self.selectionStyle = .none

    
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 90),
            scheduleView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            scheduleView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
            scheduleView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            scheduleView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10)
        ])
    }
    
}

