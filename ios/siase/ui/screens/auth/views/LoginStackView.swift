//
//  LoginStackView.swift
//  siase
//
//  Created by Fernando Maldonado on 26/02/22.
//

import Foundation
import UIKit

class LoginStackView : UIStackView{
    
    private let button:RoundedButton = {
        let view = RoundedButton()
        view.backgroundColor = Colors.Light.primaryColor
        view.setTitle("Iniciar Sesión", for: .normal)
        return view
    }()
    
    private let usernameTextField:RoundedtextField = {
        let view = RoundedtextField()
        view.placeholder = "Matrícula"
        return view
    }()
    
    private let passwordtextField:RoundedtextField = {
        let view = RoundedtextField()
        view.placeholder = "Contraseña"
        view.isSecureTextEntry = true
        return view
    }()
    
    
    func setLoginClickListener(action: @escaping () -> ()){
        button.setOnClickListener {
            action()
        }
    }
    
    func getUsername() -> String?{
        usernameTextField.text
    }
    
    func getPassword() -> String? {
        passwordtextField.text
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addArrangedSubview(usernameTextField)
        self.addArrangedSubview(passwordtextField)
        self.addArrangedSubview(button)
        self.isLayoutMarginsRelativeArrangement = true

        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
        self.spacing = 20
        self.axis = .vertical
        self.distribution = .equalSpacing
    }
    
    required init(coder: NSCoder) {
        fatalError("Not implementef")
    }
}
