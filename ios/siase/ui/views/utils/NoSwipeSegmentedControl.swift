//
//  NoSwipeSegmentedControl.swift
//  siase
//
//  Created by Fernando Maldonado on 22/04/22.
//

import Foundation
import UIKit

class NoSwipeSegmentedControl: UISegmentedControl {
        
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer.isKind(of: UITapGestureRecognizer.self)){
            return false
        }else{
            return true
        }
    }
}
