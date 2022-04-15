//
//  ClassView.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

class ClassView : UIStackView{
    
    private let classLabel:UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(15)
        return view
    }()
    
    private let timeLabel:UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(12)
        view.textColor = Colors.Light.onPrimaryContainer
        return view
    }()
    
    func setClassName(text:String){
        classLabel.text = text
    }
    
    func setTimeName(text:String){
        timeLabel.text = text
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = Colors.Light.surfaceVariant
        self.addArrangedSubview(classLabel)
        self.addArrangedSubview(timeLabel)
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        self.spacing = 5
        self.axis = .vertical
        self.distribution = .equalSpacing
        self.alignment = .fill
        self.layer.cornerRadius = 15
        
    }
    
    required init(coder: NSCoder) {
        fatalError("Not implementef")
    }
}
