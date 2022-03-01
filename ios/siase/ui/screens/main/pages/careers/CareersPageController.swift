//
//  CareersPageController.swift
//  siase
//
//  Created by Fernando Maldonado on 27/02/22.
//

import Foundation
import UIKit

class CaareersPageController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Carreras"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
    }
}
