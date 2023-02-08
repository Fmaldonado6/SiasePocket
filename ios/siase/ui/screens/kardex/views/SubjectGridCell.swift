//
//  SubjectGridCell.swift
//  siase
//
//  Created by Fernando Maldonado on 13/04/22.
//

import Foundation
import UIKit

class SubjectGridCell : UICollectionViewCell{
    
    static let identifier = "SubjectGridCell"
    
    private let subjectView:SubjectView = {
        let view = SubjectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private var index:Int = 0
    
    func configure(index:Int,subject:Subject){
        addSubview(subjectView)
     
        
        self.subjectView.setSubjectText(text: subject.nombre ?? "")
        self.subjectView.setScoreText(text: subject.oportunidades.last ?? "?")
        
        var opportunity = subject.oportunidades.count
        
        if(opportunity == 0){
            opportunity = 1
        }
        
        self.subjectView.setOportunityText(text: "Oportunidad \(opportunity)")
        
        self.backgroundColor = .systemGroupedBackground

        
        NSLayoutConstraint.activate([
            subjectView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            subjectView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
            subjectView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            subjectView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10)
        ])
    }
    
}

