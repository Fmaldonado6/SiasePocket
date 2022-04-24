//
//  ErrorView.swift
//  siase
//
//  Created by Fernando Maldonado on 24/04/22.
//

import Foundation
import UIKit

class ErrorView:UIStackView{
    
    private let icon:UIImageView = {
        let view = UIImageView()
        
        let imageConfiguration:UIImage.Configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "exclamationmark.circle",withConfiguration: imageConfiguration)
        view.image = image
        view.tintColor = .systemGray
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let button:RoundedButton = {
        let view = RoundedButton()
        view.setTitle("Reintentar", for: .normal)
        view.backgroundColor = Colors.Light.primaryColor | Colors.Dark.primaryColor
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return view
    }()
    
    func setOnClickListener(listener:@escaping()->Void){
        button.setOnClickListener {
            listener()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addArrangedSubview(icon)
        self.addArrangedSubview(button)
    
        self.spacing = 20
        self.axis = .vertical
        self.distribution = .equalSpacing
    }
    
    required init(coder: NSCoder) {
        fatalError("Not implemented")
    }
}


