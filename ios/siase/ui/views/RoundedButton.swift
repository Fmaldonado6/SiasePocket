//
//  RoundedButton.swift
//  siase
//
//  Created by Fernando Maldonado on 26/02/22.
//

import Foundation
import UIKit

class RoundedButton : UIButton {
    
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHovered ?
                self.backgroundColor!.withAlphaComponent(0.15) :
                self.backgroundColor

        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        layer.cornerRadius = 15
        self.backgroundColor = .systemBlue
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implementef")
    }
    
}
