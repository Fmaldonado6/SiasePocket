//
//  CareerGridCell.swift
//  siase
//
//  Created by Fernando Maldonado on 13/04/22.
//

import Foundation
import UIKit

class CareerGridCell : UICollectionViewCell{
    
    static let identifier = "CareerGridCell"
    
    private let careerView:CareerView = {
        let view = CareerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private var index:Int = 0
    
    func configure(index:Int,career:Career){
        addSubview(careerView)
        
        let careerNameSplit = career.nombre?.split(separator: "-")
        let careerName = careerNameSplit?.last?.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        let dependencyName = careerNameSplit?.first?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.careerView.setCareerText(text: careerName ?? "asdasd")
        self.careerView.setDependencyText(text: dependencyName ?? "asdasd")

        self.backgroundColor = .systemGroupedBackground
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 95),
            careerView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            careerView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
            careerView.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            careerView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -5)
        ])
    }
    
}

