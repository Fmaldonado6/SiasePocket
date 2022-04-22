//
//  NextClassView.swift
//  siase
//
//  Created by Fernando Maldonado on 16/04/22.
//

import Foundation
import UIKit

class NextClassView:UIStackView{
    
    
    private let nextClassLabel:UILabel = {
        let view = UILabel()
        view.text = "Siguiente clase"
        view.font = view.font.withSize(20)
        return view
    }()
    
    private let nextClassView:ClassView = {
        let view = ClassView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setClassName(text: "Inteligencia Artificial")
        view.setTimeName(text: "7:00 - 10:00")
        return view
    }()
    
    private let noNextClassLabel:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .systemGray
        view.text = "¡Felicidades, has terminado por hoy!"
        view.font = view.font.withSize(15)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addArrangedSubview(nextClassLabel)
        addArrangedSubview(nextClassView)
        addArrangedSubview(noNextClassLabel)

        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        spacing = 20
        axis = .vertical
        distribution = .fill
        alignment = .fill
        
        NSLayoutConstraint.activate([
            nextClassView.heightAnchor.constraint(equalToConstant: 78),
            noNextClassLabel.heightAnchor.constraint(equalToConstant: 78)
        ])
    }
    
    func setupNextClass(nextClass:ClassDetail?){
        guard let nextClass = nextClass else {
            self.noNextClassLabel.isHidden = false
            self.nextClassView.isHidden = true
            return
        }
        
        self.noNextClassLabel.isHidden = true
        self.nextClassView.isHidden = false
        
        self.nextClassView.setClassName(text: nextClass.nombre ?? "")
        self.nextClassView.setTimeName(text: nextClass.horaInicio! + " - " + nextClass.horaFin!)

    }
    
    required init(coder: NSCoder) {
        fatalError("Not implementef")
    }
}
