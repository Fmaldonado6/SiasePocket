//
//  ClassView.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

class ClassView : UIView{
    
    private let classLabel:UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(15)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private let timeLabel:UILabel = {
        let view = UILabel()
        view.font = view.font.withSize(12)
        view.textColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    func setClassName(text:String){
        classLabel.text = text.lowercased().capitalized
    }
    
    func setTimeName(text:String){
        timeLabel.text = text
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = Colors.Light.surfaceVariant | Colors.Dark.surfaceVariant
        self.addSubview(classLabel)
        self.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            
            classLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 20),
            classLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            classLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20),
            
            timeLabel.topAnchor.constraint(equalTo: classLabel.bottomAnchor,constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20)


        ])
  
        self.layer.cornerRadius = 15
        
    }
    
    required init(coder: NSCoder) {
        fatalError("Not implementef")
    }
}
