//
//  KardexPageController.swift
//  siase
//
//  Created by Fernando Maldonado on 22/04/22.
//

import Foundation
import UIKit

class KardexPageController : UIViewController{
    
    var career:Career!
    
    private lazy var segmentedControl:UISegmentedControl = {
        let view = UISegmentedControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Kárdex"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
    }
    
}
