//
//  CareerDetailPageViewController.swift
//  siase
//
//  Created by Fernando Maldonado on 20/04/22.
//

import Foundation
import UIKit

class CareerDetailPageController : UIViewController,UINavigationBarDelegate {
    
    var career:Career!
    var index:Int!
    
    private let schedulesCard:GenericCard = {
        let view = GenericCard()
        view.setTitle(text: "Horarios")
        view.setIcon(iconName: "clock")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let kardexCard:GenericCard = {
        let view = GenericCard()
        view.setTitle(text: "Kárdex")
        view.setIcon(iconName: "text.badge.checkmark")
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private let scrollView:UIScrollView = {
       let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.setValue(1, forKey: "__largeTitleTwoLineMode")
        navigationItem.title = career.nombre?.split(separator: "-").last?.trimmingCharacters(in: .whitespacesAndNewlines).capitalized

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic;
        setupViews()
    }
    
    private func setupViews(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(schedulesCard)
        scrollView.addSubview(kardexCard)
        
        schedulesCard.setClickListener {
            let vc = ScheduleSelectionController()
            vc.index = self.index
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
        }
        
        kardexCard.setClickListener {
            let vc = KardexPageController()
            vc.career = self.career
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            schedulesCard.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 20),
            schedulesCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            schedulesCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            schedulesCard.heightAnchor.constraint(equalToConstant: 85),
            
            kardexCard.topAnchor.constraint(equalTo: schedulesCard.bottomAnchor,constant: 20),
            kardexCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            kardexCard.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            kardexCard.heightAnchor.constraint(equalToConstant: 85),
        ])
        
    }
    
}
