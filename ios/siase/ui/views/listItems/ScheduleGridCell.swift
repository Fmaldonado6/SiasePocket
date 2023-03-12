//
//  ScheduleGridCell.swift
//  siase
//
//  Created by Fernando Maldonado on 08/02/23.
//

import Foundation
import UIKit

class ScheduleGridCell : UICollectionViewCell{
    
    static let identifier = "ScheduleGridCell"
    
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
    
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 90),
            scheduleView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            scheduleView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
            scheduleView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            scheduleView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10)
        ])
    }
    
}

