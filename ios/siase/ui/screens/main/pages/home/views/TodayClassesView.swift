//
//  TodayClassesView.swift
//  siase
//
//  Created by Fernando Maldonado on 16/04/22.
//

import Foundation
import UIKit

class TodayClassesView:UIStackView{
    
    private let todaysClassesLabel:UILabel = {
        let view = UILabel()
        view.text = "Clases de hoy"
        view.font = view.font.withSize(17)
        return view
    }()
    
    private let fullScheduleButton:UIButton = {
        let view = UIButton()
        view.titleLabel?.font = view.titleLabel?.font.withSize(15)
        view.setTitle("Ver horario completo", for: .normal)
        view.setTitleColor(Colors.Light.primaryColor, for: .normal)
        return view
    }()
    
    private let todaysClassesLabelContainer:UIStackView = {
       let view = UIStackView()
        view.distribution = .fill
        view.alignment = .fill
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)

        return view
    }()
    
    
    private let classesView : ScheduleDetailView = {
        let view = ScheduleDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement = true

        return view
    }()
    
    func setupClasses(classes:[ClassDetail]){
        classesView.setupClasses(classes: classes)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        todaysClassesLabelContainer.addArrangedSubview(todaysClassesLabel)
        todaysClassesLabelContainer.addArrangedSubview(fullScheduleButton)

        addArrangedSubview(todaysClassesLabelContainer)
        addArrangedSubview(classesView)
        
        axis = .vertical
        distribution = .fill
        alignment = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("Not implementef")
    }
    
}
