//
//  DetailViewContainer.swift
//  siase
//
//  Created by Fernando Maldonado on 02/02/23.
//

import Foundation
import UIKit


class DetailViewContainer<T:UIViewController> : UIView {

    
    
    private var onResizeListener: ()->Void = {}
    
    func setOnResizeListener(listener:@escaping ()->Void){
        self.onResizeListener = listener
    }
    
    private var view:T!
    
    func getView()->T{
        return view
    }
    
    func setView(view:T){
        self.addSubview(view.view)
        self.layoutIfNeeded()
        self.view = view
        view.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.view.widthAnchor.constraint(equalTo: self.widthAnchor),
            view.view.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
}

