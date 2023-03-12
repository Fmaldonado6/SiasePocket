//
//  RoundedTextField.swift
//  siase
//
//  Created by Fernando Maldonado on 26/02/22.
//

import Foundation
import UIKit

class RoundedtextField : UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        self.backgroundColor = .lightGray.withAlphaComponent(0.25)
    }

    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 12, dy: 12)

    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx:12,dy:12)

    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
}
