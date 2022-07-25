//
//  EmptyView.swift
//  siase
//
//  Created by Fernando Maldonado on 25/07/22.
//

import Foundation
import UIKit

class EmptyView:UIStackView{
    
    private let icon:UIImageView = {
        let view = UIImageView()
        
        let imageConfiguration:UIImage.Configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "calendar",withConfiguration: imageConfiguration)
        view.image = image
        view.tintColor = .systemGray
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let text:UILabel = {
        let view = UILabel()
        view.text = "No tienes clases presenciales en este horario"
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addArrangedSubview(icon)
        self.addArrangedSubview(text)
    
        self.spacing = 20
        self.axis = .vertical
        self.distribution = .equalSpacing
    }
    
    required init(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

